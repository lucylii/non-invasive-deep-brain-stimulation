import numpy as np
from scipy.signal import chirp, spectrogram

<<<<<<< HEAD
def gen_chirp(Chirp_init_freq=None, Chirp_init_time=0, Chirp_end_freq=None, Chirp_end_time=None, time_points=None, **kwargs):

    Chirp_signal = chirp(time_points, f0=Chirp_init_freq, f1=Chirp_end_freq, t1=Chirp_end_time, **kwargs)
    
    if len(kwargs) > 0:
        if kwargs['method'] == 'logarithmic':
            freq_ls = Chirp_init_freq * (Chirp_end_freq/Chirp_init_freq)**(time_points/Chirp_end_time)
        elif kwargs['method'] == 'linear':
            freq_ls = np.linspace(Chirp_init_freq, Chirp_end_freq, time_points.shape[0])
        
    else:
        freq_ls = np.linspace(Chirp_init_freq, Chirp_end_freq, time_points.shape[0])
=======
def gen_chirp(Chirp_init_freq=None, Chirp_init_time=0, Chirp_end_freq=None, Chirp_end_time=None, time_points=None):
    
#    Sim_fs = int(1/(time_points[1] - time_points[0]))
    
#    Chirp_signal = np.zeros(time_points.shape)

#    # the starting of the signal should be with the starting frequency
#    Chirp_signal_init = np.sin(2 * np.pi * Chirp_init_freq * time_points[:int(Chirp_init_time*Sim_fs)]) 

#    Chirp_freqs = np.linspace(Chirp_init_freq, Chirp_end_freq, int(Chirp_end_time*Sim_fs) - int(Chirp_init_time*Sim_fs)) / 2
#    Chirp_signal_mid = np.sin(2 * np.pi * Chirp_freqs * time_points[int(Chirp_init_time*Sim_fs):int(Chirp_end_time*Sim_fs)])

#    # the ending should be with the ending frequency
#    Chirp_signal_end = np.sin(2 * np.pi * Chirp_end_freq * time_points[int(Chirp_end_time*Sim_fs):]) 

#    Chirp_signal[:int(Chirp_init_time*Sim_fs)] = Chirp_signal_init
#    Chirp_signal[int(Chirp_init_time*Sim_fs):int(Chirp_end_time*Sim_fs)] = Chirp_signal_mid
#    Chirp_signal[int(Chirp_end_time*Sim_fs):] = Chirp_signal_end
    
#    freq_ls = [Chirp_init_freq] * Chirp_init_time*Sim_fs
#    freq_ls.extend(list(Chirp_freqs))
#    freq_ls.extend([Chirp_end_freq] * Chirp_signal_end.shape[0])

    Chirp_signal = chirp(time_points, f0=Chirp_init_freq, f1=Chirp_end_freq, t1=Chirp_end_time, method='linear')
    freq_ls = np.linspace(Chirp_init_freq, Chirp_end_freq, time_points.shape[0])
>>>>>>> 49ab52c98d8666038ac8bd2ce1a4c4682b8f8873
    
    return (Chirp_signal, freq_ls) # TODO: add another output to display the frequencies



def gen_sin(init_time=0, freq=None, phase=0, time_points=None):
    
    Sim_fs = int(1/(time_points[1] - time_points[0]))
    
    sin_signal = np.zeros(time_points.shape)
    
    sin_signal_init = np.zeros((int(init_time*Sim_fs),))
    
    time_remaining = time_points[int(init_time*Sim_fs):] - init_time 
    sin_signal_end = np.sin(2 * np.pi * freq * (time_remaining + phase))
    
    sin_signal[:int(init_time*Sim_fs)] = sin_signal_init
    sin_signal[int(init_time*Sim_fs):] = sin_signal_end
    
    return sin_signal
    
    
def gen_pulse(init_time=0, on_width=0., off_width=10., time_points=None):
    
    Sim_fs = int(1/(time_points[1] - time_points[0]))
    
    pulse_signal = np.zeros(time_points.shape)
    
    on_signal = np.ones((int(on_width)*Sim_fs,))
    off_signal = np.zeros((int(off_width)*Sim_fs,))
    on_off_signal = np.concatenate((on_signal, off_signal), axis=0)
    
    one_pulse_time = int(on_width) + int(off_width)
    repeat = int((time_points[-1] - init_time) // one_pulse_time)
    
    end_time = init_time + repeat * one_pulse_time
    
    on_off_signal = np.array(list(on_off_signal) * repeat)
    
    pulse_signal[int(init_time*Sim_fs):int(end_time*Sim_fs)] = on_off_signal
    
    return pulse_signal


def gen_slope(init_time=0, end_time=500, time_points=None):
    
    Sim_fs = int(1/(time_points[1] - time_points[0]))
    
    slope_sig = np.zeros(time_points.shape)
    remaining_time = time_points[init_time*Sim_fs:] - init_time
    
    
    slope_period = end_time - init_time
    init_sig = np.ones((init_time*Sim_fs,))
    remaining_sig = np.minimum( remaining_time / slope_period, 1)

    slope_sig[:init_time*Sim_fs] = init_sig
    slope_sig[init_time*Sim_fs:] = remaining_sig
    
    return slope_sig