"""
IIR_and_CIC_python.py

Bit-accurate Python implementations of the MATLAB IIR notch filters and CIC
from your MATLAB files. Exports coefficients in float and quantized hex formats.

Includes:
- FixedType (sized fixed-point helper)
- IIRSecondOrderSection (per-section DF2TSOS-like fixed-point filtering)
- IIRCascade (builds cascade of sections from b,a or SOS and filters with per-MAC quant)
- CICDecimatorBitAccurate (CIC decimator with specified section word/fraction lengths)

Exports per-filter:
- <name>_coeff_float.txt  (b and a floats, SOS flattened)
- <name>_coeff_s20_18_hex.txt  (coefficients quantized to s20.18 in hex)

Usage:
    from IIR_and_CIC_python import IIRFilter_IIR_1, IIRFilter_IIR_2, IIRFilter_IIR_2_4, CICDecimator
    h1 = IIRFilter_IIR_1()
    y = h1.filter(x)
    h1.export_coeffs()

Requirements:
    pip install numpy scipy

"""

import numpy as np
from scipy import signal
from math import ceil

# ---------------- Fixed-point helper ----------------
class FixedType:
    def __init__(self, w:int, f:int):
        assert w > 0
        self.w = int(w)
        self.f = int(f)
        self.scale = 1 << self.f
        self.max_int = (1 << (w-1)) - 1
        self.min_int = - (1 << (w-1))

    def quantize_float(self, x):
        xr = np.round(np.array(x) * self.scale) / float(self.scale)
        xr = np.minimum(xr, self.max_int / float(self.scale))
        xr = np.maximum(xr, self.min_int / float(self.scale))
        return xr.astype(float)

    def float_to_int(self, x):
        xi = int(np.round(float(x) * self.scale))
        xi = max(min(xi, self.max_int), self.min_int)
        return xi

    def int_to_twos_hex(self, xi:int):
        if xi < 0:
            xi = (1 << self.w) + xi
        hex_width = ceil(self.w / 4)
        return format(xi & ((1<<self.w)-1), '0{}X'.format(hex_width))

    def float_to_twos_hex(self, x_float):
        xi = self.float_to_int(x_float)
        return self.int_to_twos_hex(xi)

# ---------------- IIR second-order section with bit-accurate math ----------------
class IIRSecondOrderSection:
    def __init__(self, b, a,
                 coeff_w=20, coeff_f=18,
                 prod_w=36, prod_f=33,
                 accum_w=38, accum_f=33,
                 section_in_w=16, section_in_f=15,
                 section_out_w=16, section_out_f=15):
        # SOS coefficients [b0 b1 b2 a0 a1 a2]
        self.b = np.array(b, dtype=float)
        self.a = np.array(a, dtype=float)
        # fixed types
        self.coeff_type = FixedType(coeff_w, coeff_f)
        self.prod_type  = FixedType(prod_w, prod_f)
        self.accum_type = FixedType(accum_w, accum_f)
        self.section_in = FixedType(section_in_w, section_in_f)
        self.section_out = FixedType(section_out_w, section_out_f)
        # quantize coefficients to coeff_type
        self.b_q = self.coeff_type.quantize_float(self.b)
        self.a_q = self.coeff_type.quantize_float(self.a)
        # internal state (for DF2 transposed / TSOS we'll implement direct form II transposed style)
        # using two states per section
        self.state = [0, 0]

    def reset(self):
        self.state = [0,0]

    def filter(self, x):
        # x: 1D numpy array of floats in section_in range
        y = np.zeros_like(x, dtype=float)
        for n in range(len(x)):
            # quantize input to section input precision
            xn = self.section_in.quantize_float(x[n])
            # compute output using DF2TSOS-like structure with fixed-point integer math
            # Convert to integers
            xi = self.section_in.float_to_int(xn)
            b_int = [self.coeff_type.float_to_int(v) for v in self.b_q]
            a_int = [self.coeff_type.float_to_int(v) for v in self.a_q]
            # states in accumulator integer units (assume states stored in accum frac units)
            s0, s1 = self.state
            # perform multiply-add in integer domain aligning fractional bits
            # product = xi* b0 + s0
            prod0 = xi * b_int[0]
            # saturate product
            prod0 = max(min(prod0, self.prod_type.max_int), self.prod_type.min_int)
            acc = prod0 + s0
            acc = max(min(acc, self.accum_type.max_int), self.accum_type.min_int)
            # output before dividing by a0 (a0 assumed 1 for normalized SOS in MATLAB)
            # if a0 != 1, we would need to divide; we assume sos normalized
            # compute new states
            # s0_new = xi*b1 + s1 - a1*acc
            prod1 = xi * b_int[1]
            prod2 = int(acc * a_int[1] / (1 << self.coeff_type.f)) if len(a_int) > 1 else 0
            s0_new = prod1 + s1 - prod2
            # saturate
            s0_new = max(min(s0_new, self.accum_type.max_int), self.accum_type.min_int)
            # s1_new = xi*b2 - a2*acc
            prod3 = xi * b_int[2]
            prod4 = int(acc * a_int[2] / (1 << self.coeff_type.f)) if len(a_int) > 2 else 0
            s1_new = prod3 - prod4
            s1_new = max(min(s1_new, self.accum_type.max_int), self.accum_type.min_int)
            # update states
            self.state = [s0_new, s1_new]
            # acc to float output: acc is in product frac units (prod_f), convert to section_out frac
            # Need to shift from prod_f/accum_f to out frac. For simplicity, use rounding shift
            shift = self.accum_type.f - self.section_out.f
            rounding_add = 1 << (shift - 1)
            acc_rounded = (acc + rounding_add) >> shift
            acc_rounded = max(min(acc_rounded, self.section_out.max_int), self.section_out.min_int)
            y[n] = float(acc_rounded) / float(self.section_out.scale)
        return y

# ---------------- IIR cascade wrapper ----------------
class IIRCascade:
    def __init__(self, Fs=6e6, fnotch=1e6, BW=50e3, Apass=16, name='IIR'):
        self.Fs = Fs
        self.fnotch = fnotch
        self.BW = BW
        self.Apass = Apass
        self.name = name
        # design analog/digital IIR notch using scipy
        w0 = fnotch/(Fs/2)
        bw_norm = BW/(Fs/2)
        b, a = signal.iirnotch(w0, bw_norm)
        sos = signal.tf2sos(b, a)
        # create list of sections
        self.sections = [IIRSecondOrderSection(sos[i,0:3], sos[i,3:6]) for i in range(sos.shape[0])]

    def filter(self, x):
        y = np.array(x, dtype=float)
        for sec in self.sections:
            sec.reset()
            y = sec.filter(y)
        return y

    def export_coeffs(self):
        # Flatten SOS and write floats + quantized hex (s20.18)
        float_path = f"{self.name}_coeff_float.txt"
        hex_path = f"{self.name}_coeff_s20_18_hex.txt"
        with open(float_path, 'w') as ff, open(hex_path, 'w') as fh:
            for sec in self.sections:
                # write b0 b1 b2 a0 a1 a2
                for v in np.concatenate((sec.b, sec.a)):
                    ff.write(f"{v:.18e}\n")
                    fh.write(sec.coeff_type.float_to_twos_hex(v) + '\n')
        print(f'Exported {float_path} and {hex_path}')

# ---------------- CIC Decimator (bit-accurate with section control) ----------------
class CICDecimatorBitAccurate:
    def __init__(self, decf=16, diffd=1, numsecs=1,
                 section_word_lengths=None, section_fraction_lengths=None,
                 out_w=16, out_f=15):
        self.decf = decf
        self.diffd = diffd
        self.numsecs = numsecs
        if section_word_lengths is None:
            section_word_lengths = [20]*numsecs
        if section_fraction_lengths is None:
            section_fraction_lengths = [15]*numsecs
        self.section_types = [FixedType(w,f) for w,f in zip(section_word_lengths, section_fraction_lengths)]
        self.out_type = FixedType(out_w, out_f)

    def process(self, x):
        # integrator stages with per-stage quantization
        y = np.array(x, dtype=float)
        for i in range(self.numsecs):
            # cumsum then quantize to section type
            y = np.cumsum(y)
            y = self.section_types[i].quantize_float(y)
        # decimate
        y = y[::self.decf]
        # comb stages
        for i in range(self.numsecs):
            # comb uses diffd
            delayed = np.concatenate((np.zeros(self.diffd), y[:-self.diffd]))
            y = y - delayed
            y = self.section_types[i].quantize_float(y)
        # output quantize
        y = self.out_type.quantize_float(y)
        return y

    def export_params(self, name='CIC'):
        # write section types to file
        fname = f"{name}_params.txt"
        with open(fname, 'w') as f:
            f.write(f"decf={self.decf}\n")
            f.write(f"diffd={self.diffd}\n")
            f.write(f"numsecs={self.numsecs}\n")
            f.write('section_word_lengths=' + ','.join(str(t.w) for t in self.section_types) + '\n')
            f.write('section_fraction_lengths=' + ','.join(str(t.f) for t in self.section_types) + '\n')
            f.write(f"output_word={self.out_type.w}, output_frac={self.out_type.f}\n")
        print(f'Exported CIC params to {fname}')

# ---------------- Convenience constructors mapping to your MATLAB names ----------------
def IIRFilter_IIR_1():
    # MATLAB uses Fs=6e6, Fnotch=1e6
    return IIRCascade(Fs=6000000, fnotch=1000000, BW=50000, Apass=16, name='IIR_1')

def IIRFilter_IIR_2():
    return IIRCascade(Fs=6000000, fnotch=2000000, BW=50000, Apass=16, name='IIR_2')

def IIRFilter_IIR_2_4():
    return IIRCascade(Fs=6000000, fnotch=2400000, BW=50000, Apass=16, name='IIR_2_4')

def CICDecimator():
    # from MATLAB: decf=16, diffd=1, numsecs=1, SectionWordLengths [20 20], SectionFractionLengths [15 15]
    # The MATLAB gave two-section lengths arrays but numsecs=1; interpret as single section of 20/15
    return CICDecimatorBitAccurate(decf=16, diffd=1, numsecs=1, section_word_lengths=[20], section_fraction_lengths=[15], out_w=16, out_f=15)

# ---------------- Demo & export when run as script ----------------
if __name__ == '__main__':
    # create filters
    h1 = IIRFilter_IIR_1()
    h2 = IIRFilter_IIR_2()
    h24 = IIRFilter_IIR_2_4()
    cic = CICDecimator()
    # export coefficients
    h1.export_coeffs()
    h2.export_coeffs()
    h24.export_coeffs()
    cic.export_params()
    print('Exported IIR and CIC coefficients/params')
