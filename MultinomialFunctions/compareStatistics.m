close all
clear
clc

addpath('Datasets/')

numberOfStates = 2;
window = 100;
DELTA = 0.3; % DELTA può essere massimo 1
N = 10000;
tChange = 7500;
confidence = 0.01;
CPM_mode = 'online';      %'offline', 'online';
Data_type = 'gaussian';   %'gaussian', 'discrete';

%Generate the dataset
switch lower(Data_type)
    case{'gaussian'}
        finalDataset = gaussianDataset(numberOfStates, DELTA, limit, changeGaus);
        estimateVector = finalDataset.';
    case{'discrete'}
        discreteDataset = discreteDataset(numberOfStates, DELTA, N, Change);
        %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
        estimateVector = vectorEstimation(discreteDataset,numberOfStates, window);
end

THRESHOLD = selectThreshold(numberOfStates, window, confidence);

[hotellingTExact, maxTExact, idxExact, tChangeExact] = applyCPMmean(THRESHOLD,estimateVector,'exact', CPM_mode);
[hotellingTApprox, maxTApprox, idxApprox, tChangeApprox] = applyCPMmean(THRESHOLD,estimateVector,'approx', CPM_mode);

switch lower(CPM_mode)
    case {'online'}
        figure(1), plot(maxTExact,'LineWidth',1)
        line([0 100],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
        legend('Exact statistic')
        
        figure(2), plot(maxTApprox,'LineWidth',1)
        legend('Approximate statistic')
        line([0 100],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
        
    case {'offline'}
        figure(1), plot(hotellingTExact,'LineWidth',1)
        line([0 100],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
        legend('Exact statistic')
        
        figure(2), plot(hotellingTApprox,'LineWidth',1)
        line([0 100],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
        legend('Approximate statistic')
end

difference = (maxTExact - maxTApprox);
