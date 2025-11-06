import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import firwin2
from scipy.signal import freqz

fs = 6e6  # Sample rate
R = 8   # Decimation factor
N = 1   # Number of sections
Q = 3   # CIC order

# Cut off is the cutOff as a fraction of the sample rate
# i.e 0.5 = nyquist frequency
def getFIRCompensationFilter(R,N,Q,cutOff,numTaps,calcRes=1024):
    
    w = np.arange(calcRes) * np.pi/(calcRes - 1)    
    Hcomp = lambda w : ((N*R)**Q)*(np.abs((np.sin(w/(2.*R))) / (np.sin((w*N)/2.)) ) **Q)
    cicCompResponse = np.array(list(map(Hcomp, w)))
    # Set DC response to 1 as it is calculated as 'nan' by Hcomp
    cicCompResponse[0] = 1
    # Set stopband response to 0
    cicCompResponse[int(calcRes*cutOff*2):] = 0        
    normFreq = np.arange(calcRes) / (calcRes - 1)
    taps = firwin2(numTaps, normFreq, cicCompResponse)
    return taps

def plotFIRCompFilter(R,N,Q,cutOff,taps, yMin, yMax, wideband=False):    
    
    plt.figure(figsize=(12,4))
    
    if wideband:        
        interp = np.zeros(len(taps)*R)
        interp[::R] = taps
        freqs,response = freqz(interp)
    else:
        freqs,response = freqz(taps)
    
    if wideband:
        w = np.arange(len(freqs)) * np.pi/len(freqs) * R
    else:
        w = np.arange(len(freqs)) * np.pi/len(freqs)
        
    Hcic = lambda w : (1/((N*R)**Q))*np.abs( (np.sin((w*N)/2.)) / (np.sin(w/(2.*R))) )**Q
    cicMagResponse = np.array(list(map(Hcic, w)))

    combinedResponse = cicMagResponse * response
    
    plt.plot(freqs/(2*np.pi),20*np.log10(abs(cicMagResponse)), label="CIC Filter")
    plt.plot(freqs/(2*np.pi),20*np.log10(abs(response)), label="Compensation Filter")
    plt.plot(freqs/(2*np.pi),20*np.log10(abs(combinedResponse)), label="Combined Response")
    axes = plt.gca(); axes.set_xlim([0,0.5]); axes.set_ylim([yMin,yMax])
    plt.grid(); plt.legend()
    plt.title("CIC Compensation filter N={}, Q={}, Cutoff={}fs, Taps={}".format(N,Q,cutOff,len(taps)))
    plt.xlabel('Normalised freq (2$\pi$ radians/sample)')
    plt.ylabel('Normalised Filter Magnitude Response (dB)')

taps = getFIRCompensationFilter(R=R,N=N,Q=Q,cutOff=1/(2*R),numTaps=64)
print("Full Response")
plotFIRCompFilter(R=R,N=N,Q=Q,cutOff=1/(2*R),taps=taps,yMin=-100,yMax=5)
print("Zoom in on passband ripple")
plotFIRCompFilter(R=R,N=N,Q=Q,cutOff=1/(2*R),taps=taps,yMin=-0.5,yMax=0.5)
plt.show()