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
CPM_mode = 'online';
[finalDataset] = discreteDataset(numberOfStates, DELTA, N, tChange);
THRESHOLD = selectThreshold(numberOfStates, window, confidence);
limit = floor(length(finalDataset)/window);
estimateVector = [];

%Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
for i=window+1:window:(limit*window)+window
    vett = finalDataset(i - window:i-1);
    A = hist(vett,1:numberOfStates)';
    estimateVector = [estimateVector A/window];
end

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
