close all; clear all;

% we are gonna load in the data saved from analytical solution
load('R_H.mat'); 
dataL_H  = fliplr(dataR_H);
dataAM_H = (dataL_H + dataR_H) - abs(dataL_H - dataR_H); 
figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3);
title('Unnormalized')
grid; axis tight

% normalize them (max AM signal must be 1)
dataR_H  = dataR_H/max(dataAM_H);
dataL_H  = dataL_H/max(dataAM_H);
dataAM_H = dataAM_H/max(dataAM_H);
figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3);
title('Normalized (to max modulation)')
grid; axis tight

%% Some explanation up to this point

% No we are gonna test what is the amplitude needed for the modulated
% signal to make the neuron spike. Then we multiply the normalized values
% with that value. The we check if the new values of the pure sinudoids
% elicit action potential near the electrodes!

% check the value -> 35 (each 17.5)

%% Simulation

% initializing simulation param
tend = 2000;
fs   = 100;
dt   = 1/fs; % 0.01

slope = 5e-5; % this is in the units of the current over time!
stim_freq = 1.0; % kHz

% initialize stimulaiton current
I_stim1 = 17.5;    % nA 
freq1   = stim_freq;     % 0.01 => 10 Hz

I_stim2 = 17.5;    % nA 
freq2   = stim_freq + .001;    % 0.01 => 10 Hz

I_stim3 = 0;       % nA 
freq3   = stim_freq + .02;    % 0.01 => 10 Hz

MHH( I_stim1, freq1, I_stim2, freq2, I_stim3, freq3, tend, dt, slope );

%% Effect of pure sinusoids near electrode

% Multiply the normalized data with the value found above (35)
dataR_H  = dataR_H * 35;  % (17.5 + 17.5)
dataL_H  = dataL_H * 35;  
dataAM_H = dataAM_H * 35;
figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3);
title('Scaled')
grid; axis tight

%%
% now we can simply pick two arbitrary points near the electrode and see if
% we see action potential

index = 400;
dataL_point  = dataL_H(index);
dataR_point  = dataR_H(index);
dataAM_point = dataAM_H(index);

figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3); grid; axis tight;
hold on; 
scatter(index, dataL_point, 50, 'k'); 
scatter(index, dataR_point, 50, 'k');
scatter(index, dataAM_point, 50, 'k'); hold off;
title('Stimulation Amplitude')

% initializing simulation param
tend = 2000;
fs   = 100;
dt   = 1/fs; % 0.01

% initialize stimulaiton current
I_stim1 = dataL_point;     % nA 
freq1   = 1.0;    % 0.01 => 10 Hz

I_stim2 = dataR_point;   % nA 
freq2   = 1.01;    % 0.01 => 10 Hz

I_stim3 = 0;   % nA 
freq3   = 1.02;    % 0.01 => 10 Hz

slope = 3e-5; % change to 1, if you do not want a ramp

MHH( I_stim1, freq1, I_stim2, freq2, I_stim3, freq3, tend, dt, slope );

%% VCN model
clear all

% initializing simulation param
tend = 2000e-3; % 2sec
fs   = 30e3;

neuron_type = 'II';
slope =  .00005;
stim_freq = 3000;

% initialize stimulaiton current
I_stim1 = 5.0;    % nA 
freq1   = stim_freq;    % Hz

I_stim2 = 5.0;     % nA 
freq2   = stim_freq + 0;  % Hz

I_stim3 = 0;     % nA 
freq3   = stim_freq + 1.02;  % Hz

VCN( I_stim1, freq1, I_stim2, freq2, I_stim3, freq3, tend, fs, slope, neuron_type );

%% VCN model: here i will try to find the threshold for the modulated signal and move towards surface!
% threshold: 5 for each signal, which means for modulated signal we have 5
% + 5 = 10

clear all

% initializing simulation param
tend = 2000e-3; % 2sec
fs   = 30e3;

neuron_type = 'II';
slope =  .00005;
stim_freq = 3000;

% initialize stimulaiton current
I_stim1 = 5;    % nA 
freq1   = stim_freq;    % Hz

I_stim2 = 5;     % nA 
freq2   = stim_freq + 0;  % Hz

I_stim3 = 0;     % nA 
freq3   = stim_freq + 1.02;  % Hz

VCN( I_stim1, freq1, I_stim2, freq2, I_stim3, freq3, tend, fs, slope, neuron_type );
%% 

% ** First run the normalization (to 1) code from the first cell!

% Multiply the normalized data with the value found above (35)
dataR_H  = dataR_H * 10;  % (5 + 5)
dataL_H  = dataL_H * 10;  
dataAM_H = dataAM_H * 10;
figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3);
title('Scaled')
grid; axis tight

%% Slide!

index = 10;
dataL_point  = dataL_H(index);
dataR_point  = dataR_H(index);
dataAM_point = dataAM_H(index);

figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataR_H+dataL_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3); grid; axis tight;
hold on; 
scatter(index, dataL_point, 50, 'k'); 
scatter(index, dataR_point, 50, 'k');
scatter(index, dataR_point+dataL_point, 50, 'k');
scatter(index, dataAM_point, 50, 'k'); hold off;
title('Stimulation Amplitude')

% initializing simulation param
tend = 2000e-3; % 2sec
fs   = 30e3;

neuron_type = 'II';
slope =  .00005;
stim_freq = 3000;

% initialize stimulaiton current
I_stim1 = dataL_point;    % nA 
freq1   = stim_freq;    % Hz

I_stim2 = dataR_point;     % nA 
freq2   = stim_freq + 20;  % Hz

I_stim3 = 0;     % nA 
freq3   = stim_freq + 1.02;  % Hz

VCN( I_stim1, freq1, I_stim2, freq2, I_stim3, freq3, tend, fs, slope, neuron_type );

%% here is my attempt to show that with NORMALIZED graphs (both E-fields and modulated one)
% we can claim the way the paper does!

close all; clear all;

% we are gonna load in the data saved from analytical solution
load('R_H.mat'); 
dataL_H  = fliplr(dataR_H);
dataAM_H = (dataL_H + dataR_H) - abs(dataL_H - dataR_H); 

% normalize them (max AM signal must be 1)
dataR_H  = dataR_H/max(dataR_H);
dataL_H  = dataL_H/max(dataL_H);
dataAM_H = dataAM_H/max(dataAM_H);
figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3);
title('Normalized (to max modulation)')
grid; axis tight

% Multiply the normalized data with the value found above (35)
dataR_H  = dataR_H * 10;  % (5 + 5)
dataL_H  = dataL_H * 10;  
dataAM_H = dataAM_H * 10;
figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3);
title('Scaled')
grid; axis tight

%% Now slide!

index = 490;
dataL_point  = dataL_H(index);
dataR_point  = dataR_H(index);
dataAM_point = dataAM_H(index);

figure; plot(1:numel(dataL_H), dataL_H,...
             1:numel(dataR_H), dataR_H,...
             1:numel(dataR_H), dataR_H+dataL_H,...
             1:numel(dataR_H), dataAM_H,...
             'LineWidth', 3); grid; axis tight;
hold on; 
scatter(index, dataL_point, 50, 'k'); 
scatter(index, dataR_point, 50, 'k');
scatter(index, dataR_point+dataL_point, 50, 'k');
scatter(index, dataAM_point, 50, 'k'); hold off;
title('Stimulation Amplitude')

% initializing simulation param
tend = 2000e-3; % 2sec
fs   = 30e3;

neuron_type = 'II';
slope =  .00005;
stim_freq = 3000;

% initialize stimulaiton current
I_stim1 = dataAM_point/2; %dataL_point;    % nA 
freq1   = stim_freq;    % Hz

I_stim2 = dataAM_point/2; %dataR_point;     % nA 
freq2   = stim_freq + 25;  % Hz

I_stim3 = 0;     % nA 
freq3   = stim_freq + 1.02;  % Hz

VCN( I_stim1, freq1, I_stim2, freq2, I_stim3, freq3, tend, fs, slope, neuron_type );

% NOTE THAT I HAVE REPLACED THE I_STIM VALUES BY THE MODULATED SIGNAL
% DIVIDED BY 2.. BECAUSE WE CANNOT TALE THE ADDITION ANYMORE!!!

%% Frequency response
% VCN model
clear all

% initializing simulation param
tend = 2000e-3; % 2sec
fs   = 30e3;

neuron_type = 'II';
slope =  .00005;
stim_freq = 3000;

freq_response = zeros(1,300);

for freq_diff = 1:numel(freq_response)

    % initialize stimulaiton current
    I_stim1 = 5.0;    % nA 
    freq1   = stim_freq;    % Hz

    I_stim2 = 5.0;     % nA 
    freq2   = stim_freq + freq_diff;  % Hz

    I_stim3 = 0;     % nA 
    freq3   = stim_freq + 1.02;  % Hz

    V = VCN_freq( I_stim1, freq1, I_stim2, freq2, I_stim3, freq3, tend, fs, slope, neuron_type );
    
    freq_response(freq_diff) = sum(V>0);
    
end
figure;
plot(freq_response); title('Phasic Neuron Frequency Response')
xlabel('Modulation frequency (Hz)');
ylabel('Neuron activity');

% VCN model
clear all

% initializing simulation param
tend = 2000;
fs   = 100;
dt   = 1/fs; % 0.01

slope = 5e-5; % this is in the units of the current over time!
stim_freq = 1.0; % kHz

freq_response = zeros(1,300);

for freq_diff = 1:numel(freq_response)

    % initialize stimulaiton current
    I_stim1 = 17.5;    % nA 
    freq1   = stim_freq;     % 0.01 => 10 Hz

    I_stim2 = 17.5;    % nA 
    freq2   = stim_freq + freq_diff/1000;    % 0.01 => 10 Hz

    I_stim3 = 0;       % nA 
    freq3   = stim_freq + .02;    % 0.01 => 10 Hz

    V = MHH_freq( I_stim1, freq1, I_stim2, freq2, I_stim3, freq3, tend, dt, slope );
    
    freq_response(freq_diff) = sum(V>0);
    
end
figure
plot(freq_response); title('Tonic Neuron Frequency Response')
xlabel('Modulation frequency');
ylabel('Neuron activity');