%%
% STEP - 1
%{ 
1. audioread is function that reads audio files from the computer into matlab.
2. sound1 is the variable that stores the first sound i.e. male1.wav.
3. fs1 is the sampling frequency for the first sound.
4. sound() function is used to play some sound on matlab at some sampling
frequency.
5. pause() is used to give some time delay in seconds.
%}
% Load three audio signals
[sound1, fs1] = audioread('male1.wav');
[sound2, fs2] = audioread('male22.wav');
[sound3, fs3] = audioread('femalee.wav');

% Play the first sound
sound(sound1, fs1);
pause(3);

% Play the second sound
sound(sound2, fs2);
pause(3);

% Play the third sound
sound(sound3, fs3);

%%
% STEP - 2
fsignal1 = fft(sound1,length(sound1)); 
len = length(fsignal1);
fshift=(-len/2 : len/2-1);
shifted = (fftshift(fsignal1));
subplot(3,1,1);
plot(fshift,abs(shifted));
title('Frquency Response of sound 1 in Hz ');

fsignal2 = fft(sound2,length(sound2)); 
len = length(fsignal2);
fshift=(-len/2 : len/2-1);
shifted = (fftshift(fsignal2));
subplot(3,1,2);
plot(fshift,abs(shifted));
title('Frquency Response of sound 2 in Hz ');

fsignal3 = fft(sound3,length(sound3)); 
len = length(fsignal3);
fshift=(-len/2 : len/2-1);
shifted = (fftshift(fsignal3));
subplot(3,1,3);
plot(fshift,abs(shifted));
title('Frquency Response of sound 3 in Hz ');


%%
% STEP - 3
% Designing a low-pass filter
cutoff_frequency = 4000;  % Set your desired cutoff frequency in Hz
order = 100;  % Filter order

% Create a low-pass FIR filter using fir1
lowpass_filter = fir1(order, cutoff_frequency / (fs1 / 2), 'low');

% Apply the filter to the audio signals
filtered_sound1 = filter(lowpass_filter, 10, sound1);
filtered_sound2 = filter(lowpass_filter, 10, sound2);
filtered_sound3 = filter(lowpass_filter, 10, sound3);

% Compute the frequency responses of the filtered signals
fsignal1_filtered = fft(filtered_sound1, length(filtered_sound1));
fsignal2_filtered = fft(filtered_sound2, length(filtered_sound2));
fsignal3_filtered = fft(filtered_sound3, length(filtered_sound3));

% Calculate frequency shift
len_filtered1 = length(fsignal1_filtered);
len_filtered2 = length(fsignal2_filtered);
len_filtered3 = length(fsignal3_filtered);

fshift_filtered1 = (-len_filtered1/2 : len_filtered1/2-1) * (fs1 / len_filtered1);
fshift_filtered2 = (-len_filtered2/2 : len_filtered2/2-1) * (fs2 / len_filtered2);
fshift_filtered3 = (-len_filtered3/2 : len_filtered3/2-1) * (fs3 / len_filtered3);

% Plot frequency responses of filtered signals
subplot(3,1,1);
plot(fshift_filtered1, abs(fftshift(fsignal1_filtered)));
title('Frequency Response of Filtered sound 1 in Hz');

subplot(3,1,2);
plot(fshift_filtered2, abs(fftshift(fsignal2_filtered)));
title('Frequency Response of Filtered sound 2 in Hz');

subplot(3,1,3);
plot(fshift_filtered3, abs(fftshift(fsignal3_filtered)));
title('Frequency Response of Filtered sound 3 in Hz');

%%
% STEP - 4
% Reproduce the filtered signals
sound(filtered_sound1, fs1);
pause(3); % Wait for the first filtered sound to finish

sound(filtered_sound2, fs2);
pause(3); % Wait for the second filtered sound to finish

sound(filtered_sound3, fs3);

%%
% STEP - 5

fs = 80000;
t = 0:1/fs:0.01;
fc1 = 10000;
fc2 = 20000;
fc3 = 30000;
m=0.5;
a=10;
c1=10/m*sin(2*pi*fc1*t);
c2=10/m*sin(2*pi*fc2*t);
c3=10/m*sin(2*pi*fc3*t);

y1=ammod(sound1, fc1, fs, 0, a);
y2=ammod(sound2, fc2, fs, 0, a);
y3=ammod(sound3, fc3, fs, 0, a);

f1 = fft(y1,length(y1)); 
len = length(f1);
fshift=(-len/2 : len/2-1);
shifted = (fftshift(f1));
subplot(3,1,1);
plot(fshift,abs(shifted));
title('Frquency Response of sound 1 in Hz ');

f2 = fft(y2,length(y2)); 
len = length(f2);
fshift=(-len/2 : len/2-1);
shifted = (fftshift(f2));
subplot(3,1,2);
plot(fshift,abs(shifted));
title('Frquency Response of sound 2 in Hz ');

f3 = fft(y3,length(y3)); 
len = length(f3);
fshift=(-len/2 : len/2-1);
shifted = (fftshift(f3));
subplot(3,1,3);
plot(fshift,abs(shifted));
title('Frquency Response of sound 3 in Hz ');

%% 
% STEP - 6
%% 
% STEP - 7
%% 
% STEP - 8
%% 
% STEP - 9
%% 
% STEP - 10
%% 
% STEP - 11