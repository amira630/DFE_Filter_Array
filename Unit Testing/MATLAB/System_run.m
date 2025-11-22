clear
clc

Fs = 9e6;        
N  = 48000;      

f_sig = 1e5;                             
t = (0 : N - 1)' / Fs;                    
x_real_clean = 0.25 * sin(2 * pi * f_sig * t);

f_intf_2_4 = 2.4e6;    
f_intf_5 = 5e6;      

A_intf_2_4 = 0.2;
A_intf_5 = 0.2;

intf1 = (A_intf_2_4 * sin(2 * pi * f_intf_2_4 * t));
intf2 = (A_intf_5 * sin(2 * pi * f_intf_5 * t));
interference = intf1 + intf2;
x_real_noisy = x_real_clean + interference;

x_quantized_noisy = fi(x_real_noisy, 1, 16, 15);

Hd_Fractional_Decimator = Fractional_Decimator();
y_frac_noisy = step(Hd_Fractional_Decimator, x_quantized_noisy);

Hd_IIR_2_4 = IIR_2_4();
y_2_4_noisy = filter(Hd_IIR_2_4 , y_frac_noisy);

Hd_IIR_1 = IIR_1(); 
Hd_IIR_2 = IIR_2();
y_filtered_1 = filter(Hd_IIR_1, y_2_4_noisy);
y_filtered = filter(Hd_IIR_2, y_filtered_1);

Hd_cic = CIC();
y_cic = step(Hd_cic, y_filtered);