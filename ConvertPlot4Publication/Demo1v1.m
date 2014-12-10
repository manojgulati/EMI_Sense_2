%Generate some data
y1 = randn(1000,1);
y2 = randn(1000,1);

%Plot using two subplots
figure
subplot(2,1,1)
plot(y1)
ylabel('Amplitude_CM')
subplot(2,1,2)
plot(y2)
ylabel('Amplitude_DM')
xlabel('Frequency')

%Export using the default options (output
ConvertPlot4Publication('testPlot')

%Export again, this time changing the font and using the same x-axis
ConvertPlot4Publication('testPlot2', 'fontsize', 8, 'fontname', 'Arial', 'samexaxes', 'on', 'eps', 'off')
