clc; close all; clear all;
%% 

%parameters
bandwidth = 4000; % The bandwidth of each channel in hertz.
guard_band = 300; % The guard band used to separate adjacent channels
signal_to_noise_ratio = 20; % he signal-to-noise ratio used for adding noise to the transmitted signal.
%A flag indicating whether Single Sideband Modulation (SSB) should be used (1 for SSB, 0 for AM modulation).
ssb_modulation = 1;

carrier_frequency1 = bandwidth * 3;
carrier_frequency2 = bandwidth * 4;
carrier_frequency3 = bandwidth * 5;

% it uses the nyquest criteria
sampling_frequency = carrier_frequency3 * 2 + 5000;
%he cutoff frequency for the low-pass filter used in the system.
cutoff_frequency = 2500;

show_graphics = 1;
play_sounds = 1;

%{
In the provided code, B and A represent the coefficients of a Butterworth low-pass filter.
These coefficients are used in the filter function to implement the
low-pass filter operation. Let's break down the meaning of the statement:

A Butterworth filter is a type of analog or digital filter known for its smooth frequency response. It is characterized by its order,
which determines the rate of roll-off in the transition from the passband to the stopband.

The filter is specified to be a fourth-order Butterworth filter. Higher-order filters generally have steeper roll-off characteristics.
%}
[B, A] = butter(4, cutoff_frequency / (sampling_frequency / 2));
low_pass_filter = @(signal) filter(B, A, signal);

[C1, D1] = butter(2, [bandwidth*2 + guard_band, bandwidth*3 - guard_band] / (sampling_frequency / 2));
band_filter3 = @(signal) filter(C1, D1, signal);

[C2, D2] = butter(2, [bandwidth*3 + guard_band, bandwidth*4 - guard_band] / (sampling_frequency / 2));
band_filter4 = @(signal) filter(C2, D2, signal);

[C3, D3] = butter(2, [bandwidth*4 + guard_band, bandwidth*5 - guard_band] / (sampling_frequency / 2));
band_filter5 = @(signal) filter(C3, D3, signal);

signal1 = audioread('male1.wav');
lsignal1 = length(signal1);

signal2 = audioread('male22.wav');
lsignal2 = length(signal2);

signal3 = audioread('femalee.wav');
lsignal3 = length(signal3);

beep_sound = audioread('beep.wav');
beep_player = audioplayer(beep_sound, 44100);

%now we find the minimum length between the loading of two signals
%The min function is used to find the minimum value between these two lengths
min_length = min([lsignal1, lsignal2]);

%this line creates a time vector using the linspace function from 0secs to
%5secs and The purpose of creating this time vector is likely for plotting
%or synchronization purposes. It provides a time axis for representing
%signals or visualizing data.
time = linspace(0, 5, min_length); %the linspace function generates linearly spaced values from a given start and end value.
%% 
disp('STEP - 1, The signals are reproduced as they arrive');

if(play_sounds > 0)%until we have the playblocking function our value of play_sounds will be greater than 0 so that the loop executes.
    p1 = audioplayer(signal1, 44100);%The value 44100 is a common standard sampling frequency used in audio processing. It is often referred to as the "CD quality" sampling rate.
    playblocking(p1);%this function plays the audio in a blocking manner, meaning it waits for the audio playback to finish before moving on to the next line of code.
    playblocking(beep_player);
    
    p2 = audioplayer(signal2, 44100);
    playblocking(p2);
    playblocking(beep_player);
    
    p3 = audioplayer(signal3, 44100);
    playblocking(p3);
end
%% 
disp('STEP - 2, Plot the spectra of the signals as they arrive');
    
if(show_graphics > 0)%same like the play_sounds the value of show_graphics will be greater than 0 until we have a plot function in the code.
    figure
    
    %{
        The output of fft is complex because it includes both magnitude and phase information for each frequency component.
        The absolute value (abs) isolates the magnitude, representing the amplitude of each frequency component.
    
        The fft gives us the DFT version of the input signal and we are
        getting the plot in continuous becuase we have used the plot
        function and if we have used the stem then we would plotted the
        result in discrete form.
    %}
    spectrum1 = abs(fft(signal1));
    subplot(3,1,1), plot(spectrum1), grid on, zoom, title('Signal 1 spectrum');
    
    spectrum2 = abs(fft(signal2));
    subplot(3,1,2), plot(spectrum2), grid on, zoom, title('Signal 2 spectrum');
    
    spectrum3 = abs(fft(signal3));
    subplot(3,1,3), plot(spectrum3), grid on, zoom, title('Signal 3 spectrum');
end
%% 
disp('STEP - 3, The signals are passed through a low pass filter and played');

signal1 = low_pass_filter(signal1);
signal2 = low_pass_filter(signal2);
signal3 = low_pass_filter(signal3);
    
if(show_graphics > 0)
    figure
    
    spectrum1 = abs(fft(signal1));
    subplot(3,1,1), plot(spectrum1), grid on, zoom, title('Filtered Signal 1');
    
    spectrum2 = abs(fft(signal2));
    subplot(3,1,2), plot(spectrum2), grid on, zoom, title('Filtered Signal 2');
    
    spectrum3 = abs(fft(signal3));
    subplot(3,1,3), plot(spectrum3), grid on, zoom, title('Filtered Signal 3');
end
%% 
disp('STEP - 4, Repoduce the signals after passing through the filter');

if(play_sounds > 0)
    beep_player = audioplayer(beep_sound, 44100);
    
    p1 = audioplayer(signal1, 44100);
    playblocking(p1);
    playblocking(beep_player);
    
    p2 = audioplayer(signal2, 44100);
    playblocking(p2);
    playblocking(beep_player);
    
    p3 = audioplayer(signal3, 44100);
    playblocking(p3);
    playblocking(beep_player);
end
%% 
disp('STEP - 5, The signals are modulated to different carriers');

%{
    the sole purpose of using a SSB modulation here is that we can use the
    bandwidth more efficiently.
%}
if(ssb_modulation > 0)
    modulated_signal1 = ssbmod(signal1, carrier_frequency1, sampling_frequency);
    modulated_signal2 = ssbmod(signal2, carrier_frequency2, sampling_frequency);
    modulated_signal3 = ssbmod(signal3, carrier_frequency3, sampling_frequency);
else
    modulated_signal1 = ammod(signal1, carrier_frequency1, sampling_frequency);
    modulated_signal2 = ammod(signal2, carrier_frequency2, sampling_frequency);
    modulated_signal3 = ammod(signal3, carrier_frequency3, sampling_frequency);
end

if(show_graphics > 0)
    figure
    
    spectrum1 = abs(fft(signal1));
    subplot(3,1,1), plot(spectrum1), grid on, zoom, title('Modulated Signal 1');
    
%     spectrum2 = abs(fft(signal2));
    subplot(3,1,2), plot(spectrum2), grid on, zoom, title('Modulated Signal 2');
    
    spectrum3 = abs(fft(signal3));
    subplot(3,1,3), plot(spectrum3), grid on, zoom, title('Modulated Signal 3');
end    
%% 
disp('STEP - 6, The modulated signals are filtered in the defined bands and added');

%{
    we used band pass filter here because we want to get the modulated
    signal frequencies and reject others
%}
filtered_signal1 = band_filter3(modulated_signal1);
filtered_signal2 = band_filter4(modulated_signal2);
filtered_signal3 = band_filter5(modulated_signal3);

% Find the minimum length among the signals
min_length = min([length(filtered_signal1), length(filtered_signal2), length(filtered_signal3)]);

% Sum the signals element-wise up to the minimum length
complete_signal = zeros(min_length, 1);
for i = 1:min_length
    complete_signal(i) = filtered_signal1(i) + filtered_signal2(i) + filtered_signal3(i);
end


if(show_graphics > 0)
    figure
    
    spectrum1 = abs(fft(signal1));
    subplot(4,1,1), plot(spectrum1), grid on, zoom, title('Modulated and filtered Signal 1');
    
    spectrum2 = abs(fft(signal2));
    subplot(4,1,2), plot(spectrum2), grid on, zoom, title('Modulated and filtered Signal 2');
    
    spectrum3 = abs(fft(signal3));
    subplot(4,1,3), plot(spectrum3), grid on, zoom, title('Modulated and filtered Signal 3');
    
    total_spectrum = abs(fft(complete_signal));
    subplot(4,1,4), plot(total_spectrum), grid on, zoom, title('Summed signal');
end   
%% 
disp('STEP - 7, Spectrum of transmitted signal before adding noise');

if (show_graphics > 0)
    figure
    
    total_spectrum = abs(fft(complete_signal));
    subplot(2,1,1), plot(total_spectrum), grid on, zoom, title('Full signal spectrum without noise');
end

complete_signal = awgn(complete_signal, signal_to_noise_ratio);

if (show_graphics > 0)
    total_spectrum = abs(fft(complete_signal));
    subplot(2,1,2), plot(total_spectrum), grid on, zoom, title('Full signal spectrum with noise');
end
%% 
disp('STEP - 8, Upon arrival each band is filtered');

demod_signal1 = band_filter3(complete_signal);
demod_signal2 = band_filter4(complete_signal);
demod_signal3 = band_filter5(complete_signal);

if(show_graphics > 0)
    figure
    
    spectrum1 = abs(fft(demod_signal1));
    subplot(3,1,1), plot(spectrum1), grid on, zoom, title('Spectrum of signal 1 filtered');
    
    spectrum2 = abs(fft(demod_signal2));
    subplot(3,1,2), plot(spectrum2), grid on, zoom, title('Spectrum of signal 2 filtered');
    
    spectrum3 = abs(fft(demod_signal3));
    subplot(3,1,3), plot(spectrum3), grid on, zoom, title('Spectrum of signal 3 filtered');
end
%% 
disp('STEP - 9, Each recovered band is demodulated to return the signal to the baseband frequency');

if(ssb_modulation > 0)
    demod_signal1 = ssbmod(demod_signal1, carrier_frequency1, sampling_frequency);
    demod_signal2 = ssbmod(demod_signal2, carrier_frequency2, sampling_frequency);
    demod_signal3 = ssbmod(demod_signal3, carrier_frequency3, sampling_frequency);
else
    demod_signal1 = ammod(demod_signal1, carrier_frequency1, sampling_frequency);
    demod_signal2 = ammod(demod_signal2, carrier_frequency2, sampling_frequency);
    demod_signal3 = ammod(demod_signal3, carrier_frequency3, sampling_frequency);
end

if(show_graphics > 0)
    figure
    
    spectrum1 = abs(fft(demod_signal1));
    subplot(3,1,1), plot(spectrum1), grid on, zoom, title('Spectrum of signal 1 filtered');
    
    spectrum2 = abs(fft(demod_signal2));
    subplot(3,1,2), plot(spectrum2), grid on, zoom, title('Spectrum of signal 2 filtered');
    
    spectrum3 = abs(fft(demod_signal3));
    subplot(3,1,3), plot(spectrum3), grid on, zoom, title('Spectrum of signal 3 filtered');
end
%% 
disp('STEP - 10, The recovered signal is passed through a low pass filter');

demod_signal1 = low_pass_filter(demod_signal1);
demod_signal2 = low_pass_filter(demod_signal2);
demod_signal3 = low_pass_filter(demod_signal3);

if(show_graphics > 0)
    figure
    
    spectrum1 = abs(fft(demod_signal1));
    subplot(3,1,1), plot(spectrum1), grid on, zoom, title('Spectrum of signal 1 filtered');
    
    spectrum2 = abs(fft(demod_signal2));
    subplot(3,1,2), plot(spectrum2), grid on, zoom, title('Spectrum of signal 2 filtered');
    
    spectrum3 = abs(fft(demod_signal3));
    subplot(3,1,3), plot(spectrum3), grid on, zoom, title('Spectrum of signal 3 filtered');
end
%% 
disp('STEP - 11, Play the reproduced signal after the transmission');

player4 = audioplayer(demod_signal1, 44100);
playblocking(player4);
playblocking(beep_player);

player5 = audioplayer(demod_signal2, 44100);
playblocking(player5);
playblocking(beep_player);

player6 = audioplayer(demod_signal3, 44100);
playblocking(player6);