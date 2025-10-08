from math import log
import numpy as np
import matplotlib.pyplot as plt
np.seterr(divide='ignore', invalid='ignore');
fftResolution = 1024

plt.figure(figsize=(12,4))
def CICResponse(R,M,N, widebandResponse=1):

    Hfunc = lambda w : np.abs( (np.sin((w*M)/2.)) / (np.sin(w/(2.*R))) )**N
        
    if widebandResponse:
        # 0 to R*pi
        w = np.arange(fftResolution) * np.pi/fftResolution * R
    else:
        # 0 to pi
        w = np.arange(fftResolution) * np.pi/fftResolution

    gain = (M*R)**N
    xAxis = np.arange(fftResolution) / (fftResolution * 2) 
    magResponse = np.array(list(map(Hfunc, w)))
    #plt.plot(xAxis, 20.0*np.log10(magResponse/gain), label="N = {}, M = {}".format(N,M))
    return magResponse

def plotConfig(title):
    axes = plt.gca(); axes.set_xlim([0,0.5]); axes.set_ylim([-140,1])
    plt.grid(); plt.legend()
    plt.title(title)
    plt.xlabel('Normalised freq (2pi radians/sample)')
    plt.ylabel('Normalised Filter Magnitude Response (dB)')
    plt.show()
