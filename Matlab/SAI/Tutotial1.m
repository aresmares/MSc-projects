clear all
clc


% In Matlab, generate random (N) noise with 501 elements
Elements_Number = 501;

Random_Noise = 0.6*wgn(Elements_Number,1,0);
% generate a clean sinusoid signal (X) of the same length with gain 0.2
Fs = 1000;
Fc = 100;
t = 0:1/Fs:(Elements_Number-1)/Fs;
Sine_Signal = 0.2*sin(2*pi*Fc*t);

% create a new signal that is the sum of N and X
New_Signal = Random_Noise + Sine_Signal;

% what is the power spectral density of each signal
figure

subplot(3,1,1)
[fs_Random_Noise,PSD_Random] = power_spectral_density(Random_Noise, Fs);
subplot(3,1,2)
[fs_Sine_Signal,PSD_Sine_Signal] = power_spectral_density(Sine_Signal, Fs);
subplot(3,1,3)
[fs_New_Signal,PSD_New_Signal] = power_spectral_density(New_Signal, Fs);

% compute the mean frequency of each signal
Random_Noise_mf = meanfreq(Random_Noise, Fs);
Sine_Signal_mf = meanfreq(Sine_Signal, Fs);
New_Signal_mf = meanfreq(New_Signal, Fs);

% compute the rms of each signal


% Calculate the Signal-to-noise ratio
% visualize all 3 signals



function [freq, psdx] = power_spectral_density(Signal,Fs)
N = length(Signal);
xdft = fft(Signal);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) *abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:Fs/length(Signal):Fs/2;

plot(freq,psdx)
grid on

xlabel('Freq(Hz)')
ylabel('PSD')
end

function mean_freq= meanfreq(Freq,Power)
ch = length(Power)
Density = Power./sum(Power);
mean_freq = sum(Freq.*Density);

end