clear all
M1 = csvread('C:\Users\Puneet\Dropbox\EMI_Sense_2\EMI_SENSE_2 [Data]\Redpitaya [Data]\Trace-1 [09-12-2014]\bgn1.csv');
y1  = M1(:,1);
y2  = M1(:,2);

fs = 125*(10^6);  %sample frequency in Hz
T  = 1/fs;        %sample period in s
L  = 16384;       %signal length
t  = (0:L-1) * T; %time vector

% Dummy signals for testing algorithm
% f1 = 5*10^6;
% f2 = 10*10^6;
% y1 = 5*sin(2*pi*f1*t)+10*sin(2*pi*f2*t);%test signal
% y2 = 5*sin(2*pi*f1*t)-10*sin(2*pi*f2*t);%test signal

% PLot time domain data
plot(y1(1:100))
hold on
plot(y2(1:100))

%%
% Computing spectrum for Phase 
Y1 = fft(y1)/L;
% Computing spectrum for Neutral 
Y2 = fft(y2)/L;
% Computing f vector for length fs/2
f = fs/2*linspace(0,1,L/2+1);
% Computing spectrum for Differential Mode EMI 
Y_CM = abs(Y1+Y2)/2; 
% Computing spectrum for Common Mode EMI 
Y_DM = abs(Y1-Y2)/2; 
% Computing magnitude of Vcm and Vdm for length L/2
ampY_CM = 2*abs(Y_CM(1:L/2+1));
ampY_DM = 2*abs(Y_DM(1:L/2+1));

%%
%Plot spectrum.
% figure;
figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'Color','w');  %Make the figure background white
% plot(f, 10*log10((ampY.^2)/10^6));
plot(f,10*log10((ampY_DM.^2)/10^6),'r');
hold on;
plot(f,10*log10((ampY_CM.^2)/10^6),'b');
set(gca,'Box','off');  %Axes on left and bottom only
title('Single-Sided Amplitude Spectrum of y(t)');
xlabel('Frequency (Hz)');
ylabel('|Amp-CM(f)| and |Amp-DM(f)|');
ylim([-120 -30])

ConvertPlot4Publication('testPlot')

%Export again, this time changing the font and using the same x-axis
ConvertPlot4Publication('testPlot2', 'fontsize', 8, 'fontname', 'Arial', 'samexaxes', 'on', 'eps', 'off')
