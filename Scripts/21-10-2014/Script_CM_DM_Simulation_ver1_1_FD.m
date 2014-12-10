clear all;

fs = 100*(10^6);  %sample frequency in Hz
T  = 1/fs;        %sample period in sec
L  = 2*10^6;        %signal length
t  = (0:L-1) * T; %time vector

A1 = 1.0; %amplitude of x1 (first signal)
A2 = 0.2; %amplitude of x2 (second signal)
A3 = 0.2; %amplitude of x3 (Third signal)

f1 = 50;   %frequency of x1
f2 = 1000;  %frequency of x2
f3 = 1500;  %frequency of x2

x1 = A1*cos(2*pi*f1*t); % Vo*Sin(w1t)    
x2 = A2*cos(2*pi*f2*t); % Vcm*cos(w2t)
x3 = A3*cos(2*pi*f3*t); % Vdm*cos(w3t)

y1 = x1+x2+x3;
y2 = -x1+x2-x3;

% % Computing Vcm and Vdm in time domain
% Vcm_td = (y1+y2)/2;
% 
% Vdm_td = ((y1-y2)/2)-x1;

%%
%Plot signal
figure;
set(gcf,'Color','w'); %Make the figure background white

plot(t,y1,'b'); % Plot time domain Vphase and Vneutral
hold on;
plot(t,y2,'r');
% hold on;
% plot(t,x3);
% set(gca,'Box','on'); %Axes on left and bottom only
% str = sprintf('Signal with %dHz and %dHz components',f1,f2);
% title(str);
xlabel('time (milliseconds)');
ylabel('Amplitude');


%%
%Calculate spectrum
Y1 = fft(y1)/L;
Y2 = fft(y2)/L;
X1 = fft(x1)/L;

Vcm_fd = (Y1+Y2)/2;
Vdm_fd = ((Y1-Y2)/2)-X1;

ampV = 2*abs(Vdm_fd(1:L/2+1)); % to compute magnitude of complex FFT
f = fs/2*linspace(0,1,L/2+1);
% i = L/fs * (max(f1,f2)) + 1; %show only part of the spectrum

%Plot spectrum.
figure;
set(gcf,'Color','w');  %Make the figure background white
% plot(f(1:i), ampY(1:i));
plot(f, ampV);
set(gca,'Box','off');  %Axes on left and bottom only
set(gca,'xscale','log');  
title('Frequency Spectrum of y(t)');
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');