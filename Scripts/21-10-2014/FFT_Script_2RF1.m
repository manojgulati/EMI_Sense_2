clear all;
Temp = csvread('5RF1.csv');

fs = 100*(10^6);        %sample frequency in Hz
T  = 1/fs;        %sample period in s
L  = 10^6;        %signal length
t  = (0:L-1) * T; %time vector

%A1 = 0.2; %amplitude of x1 (first signal)
%A2 = 1.0; %amplitude of x2 (second signal)
%f1 = 1;   %frequency of x1
%f2 = 50;  %frequency of x2

%x1 = A1*sin(2*pi*f1 * t); %sinusoid 1
%x2 = A2*sin(2*pi*f2 * t); %sinusoid 2
% M = csvread('2RF1.csv');

y  = Temp(:,2);

%%
%Plot signal
figure;
set(gcf,'Color','w'); %Make the figure background white
plot(fs*t(1:100), y(1:100));
set(gca,'Box','on'); %Axes on left and bottom only
% str = sprintf('Signal with %dHz and %dHz components',f1,f2);
% title(str);
xlabel('time (milliseconds)');
ylabel('Amplitude');


%%
%Calculate spectrum
Y = fft(y)/L;
ampY = 2*abs(Y(1:L/2+1));
f = fs/2*linspace(0,1,L/2+1);
% i = L/fs * (max(f1,f2)) + 1; %show only part of the spectrum

%Plot spectrum.
figure;
set(gcf,'Color','w');  %Make the figure background white
% plot(f(1:i), ampY(1:i));
plot(f, ampY);
set(gca,'Box','off');  %Axes on left and bottom only
title('Single-Sided Amplitude Spectrum of y(t)');
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');