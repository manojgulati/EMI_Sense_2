clear all
M = csvread('BGN.csv');
y  = M(:,2);
fs = 125*(10^6);        %sample frequency in Hz
T  = 1/fs;        %sample period in s
L  = 16384;        %signal length
t  = (0:L-1) * T; %time vector

%%
%Plot signal
% figure;
% set(gcf,'Color','w'); %Make the figure background white
% plot(fs*t(1:100), y(1:100));
% set(gca,'Box','on'); %Axes on left and bottom only
% str = sprintf('Signal with %dHz and %dHz components',f1,f2);
% title(str);
% xlabel('time (milliseconds)');
% ylabel('Amplitude');


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
plot(f, 10*log10((ampY.^2)/10^6));
set(gca,'Box','off');  %Axes on left and bottom only
title('Single-Sided Amplitude Spectrum of y(t)');
xlabel('Frequency (MHz)');
ylabel('|Y(f)|');