% Matlab code for computing Frequency Spectrum
% Manoj Gulati
% IIIT-D

% clear all previously stored variables
clear all

% Fetch content from files acquired from Redpitaya
M1 = csvread('\manojg\Dropbox\SENSE_2 [Data]\Redpitaya [Data]\Trace-5 [12-12-2014]\c1.csv');

% Fetch content for Channel-1
y1  = M1(:,1);
% Fetch content for Channel-2
% y2  = M1(:,2);

% Scaling factor for digital to analog conversion of ADC values.
% Resolution = 2*Vp/2^14 i.e. 2*1.079V/16384 = 0.0001317 
y1=y1*0.000131;
y2=y2*0.000131;

% Configuration Parameters
fs = 125*(10^6);  %sample frequency in Hz
T  = 1/fs;        %sample period in s
L  = 16384;       %signal length
t  = (0:L-1) * T; %time vector

% Dummy signals for testing algorithm (uncomment to verify FFT computation)
% f1 = 5*10^6;
% f2 = 10*10^6;
% y1 = 5*sin(2*pi*f1*t)+10*sin(2*pi*f2*t);%test signal
% y2 = 5*sin(2*pi*f1*t)-10*sin(2*pi*f2*t);%test signal

% Plot time domain data
plot(y1(1:100));
hold on;
plot(y2(1:100));

% Computing spectrum for Phase 
Y1 = fft(y1)/L;
% Computing spectrum for Neutral 
Y2 = fft(y2)/L;
% Computing f vector for length fs/2
f = fs/2*linspace(0,1,L/2+1);

ampY1 = 2*abs(Y1(1:L/2+1));
ampY2 = 2*abs(Y2(1:L/2+1));


%Plot spectrum.

figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'Color','w');  %Make the figure background white
subplot(2,1,1);

% Computing power V^2/R and converting it to dB scale in dBm i.e. 10log10(V^2/1meg-ohm)
% Frequency normalized by 1000000 to plot in terms of MHz

plot(f/1000000,10*log10(1000*((ampY1.^2)/10^6)),'r');
ylabel('Amplitude(dBm)');
title('Amplitude Spectrum of EMI');
legend('Channel-1');
% ylim([-150 -40]);
xlim([0 63]);
grid on;
%hold on;
subplot(2,1,2);

% Computing power V^2/R and converting it to dB scale in dBm i.e. 10log10(V^2/1meg-ohm)
% Frequency normalized by 1000000 to plot in terms of MHz

plot(f/1000000,10*log10(1000*((ampY1.^2)/10^6)),'b');
ylabel('Amplitude(dBm)');
xlabel('Frequency (MHz)');
legend('Channel-2');
% ylim([-150 -40]);
xlim([0 63]);
grid on;
