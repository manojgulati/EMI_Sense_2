% Matlab code for computing Frequency Spectrum of Common Mode and Differential Mode components of Conducted EMI
% Manoj Gulati
% IIIT-D

% clear all previously stored variables
clear all

Path1 = 'C:\Users\manojg\Dropbox\EMI_Sense_2\EMI_SENSE_2 [Data]\Redpitaya [Data]\Trace-16 [06-01-2015] CH2\';
Path2 = 'BGN_';
Path3 = 'LC3';
Path4 = '_AVG_100.csv';
File_Path1 = strcat(Path1,Path2,Path3,Path4);
File_Path2 = strcat(Path1,Path3,Path4);

Data_BGN = csvread(File_Path1);
Data_EMI = csvread(File_Path2);

Vect1 = Data_EMI(:,2)-Data_BGN(:,2);
Vect2 = Data_EMI(:,3)-Data_BGN(:,3);

%%
% Plotting Complete FFT Spectrum for CM and DM EMI
f1 = Data_EMI(:,1);

%Plot spectrum.
figure;
% figure('units','normalized','outerposition',[0 0 1 1]);
set(gcf,'Color','w');  %Make the figure background white
subplot(2,1,1);
plot(f1,Vect1,'r');
% semilogx(f1,10*log10(1000*((AmpY_1.^2)/10^6)),'r');
% set(gca,'xlim',[0 5]);
ylabel('Amplitude|Y-DM|(dBm)');
title(strcat('Amplitude Spectrum of EMI {',Path3,'-WindSub }'));
legend('DM EMI');
ylim([-15 20]);
xlim([0 1]);
grid on;
hold on;
subplot(2,1,2);
plot(f1,Vect2,'b');
% semilogx(f1,10*log10(1000*((AmpY_2.^2)/10^6)),'b');
% set(gca,'xlim',[0 5]);
ylabel('Amplitude|Y-CM|(dBm)');
xlabel('Frequency (MHz)');
ylim([-10 30]);
xlim([0 1]);
legend('CM EMI');
grid on;

% Function to plot as per IEEE publication specifications in 4 formats eps, fig, PDF and png
saveas(gcf,strcat(Path1,Path3,'_WindSub1','.bmp'));
