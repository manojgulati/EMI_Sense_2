% Matlab code for computing Frequency Spectrum of Common Mode and Differential Mode components of Conducted EMI
% Manoj Gulati
% IIIT-D

% clear all prevsiously stored variables
clear all

File_Path = 'C:\Users\manojg\Dropbox\EMI_Sense_2\EMI_SENSE_2 [Data]\Redpitaya [Data]\Trace-9 [15-12-2014]\';

% Fetch content from files taken from Redpitaya
M1 = csvread(strcat(File_Path,'.csv'));

% Fetch content for Channel-1 (Vphase)
y1  = M1(:,1);
% Fetch content for Channel-2 (Vneutral)
y2  = M1(:,2);

% Adding offset as precribed by redpitaya wiki after measurement data collected using 50 ohm termination. 
% This will be added to compensate for avg. noise captured by AFE of Redpitaya in open circuit mode over 100 traces.
y1  = y1 + 37;
y2  = y2 + 108;

% Scaling factor for digital to analog conversion of ADC values.
% Resolution = 2*Vp/2^14 i.e. 2*1.079V/16384 = 0.0001317 
y1=y1*0.000131;
y2=y2*0.000131;

% Scaling factor for compensating for potential divider added in output section.
% i.e. Using potential divider we scaled the potential of HPF by 1/4.
y1=y1*4;
y2=y2*4;

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
plot(y1(1:16384),'r');
hold on;
plot(y2(1:16384),'b');

%% Paragraph Break

% Computing spectrum for Phase 
Y1 = fft(y1)/L;
% Computing spectrum for Neutral 
Y2 = fft(y2)/L;
% Computing f vector for length fs/2
f = fs/2*linspace(0,1,L/2+1);
% Computing spectrum for Differential Mode EMI 
Y_CM = abs(Y1+Y2)/2; 
% % Computing spectrum for Common Mode EMI 
Y_DM = abs(Y1-Y2)/2; 
% Computing magnitude of Vcm and Vdm for length L/2
ampY_CM = 2*abs(Y_CM(1:L/2+1));
ampY_DM = 2*abs(Y_DM(1:L/2+1));


%% Paragraph Break

%Plot spectrum.
figure;
% figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'Color','w');  %Make the figure background white
subplot(2,1,1);
plot(f/1000000,10*log10(1000*((ampY_DM.^2)/10^6)),'r');
ylabel('Amplitude|Y-DM|(dBm)');
title('Amplitude Spectrum of EMI');
legend('DM');
ylim([-150 -70]);
xlim([0 63]);
grid on;
%hold on;
subplot(2,1,2);
plot(f/1000000,10*log10(1000*((ampY_CM.^2)/10^6)),'b');
ylabel('Amplitude|Y-CM|(dBm)');
xlabel('Frequency (MHz)');
legend('CM');
ylim([-150 -70]);
xlim([0 63]);
grid on;

% Function to plot as per IEEE publication specifications in 4 formats eps, fig, PDF and png
ConvertPlot4Publication(File_Path);

%Export again, this time changing the font and using the same x-axis
% ConvertPlot4Publication('testPlot2', 'fontsize', 8, 'fontname', 'Arial', 'samexaxes', 'on', 'pdf', 'off');

%% Paragraph Break

%Plot spectrum.
figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'Color','w');  %Make the figure background white
subplot(2,1,1);
plot(f/1000000,10*log10(1000*((ampY_DM.^2)/10^6)),'r');
ylabel('Amplitude|Y-DM|(dBm)');
title('Amplitude Spectrum of EMI');
legend('DM');
ylim([-150 -70]);
xlim([0 63]);
grid on;
%hold on;
subplot(2,1,2);
plot(f/1000000,10*log10(1000*((ampY_CM.^2)/10^6)),'b');
ylabel('Amplitude|Y-CM|(dBm)');
xlabel('Frequency (MHz)');
legend('CM');
ylim([-150 -70]);
xlim([0 63]);
grid on;

% Function to plot as per IEEE publication specifications in 4 formats eps, fig, PDF and png
saveas(gcf,strcat(File_Path,'_analyse.bmp'));
