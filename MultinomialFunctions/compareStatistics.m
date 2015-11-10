close all
clear
clc

addpath('Datasets/')

numberOfStates = 2;
[finalDataset] = discreteDataset(numberOfStates);
window = 100;
h = 13.932;

[hotellingTExact, maxTExact, idxExact, tChangeExact] = applyCPMmean(h,numberOfStates,window,finalDataset,'exact');
figure(1), plot(maxTExact)
line([0 100],[h h],'LineWidth',2,'Color','b')

[hotellingTApprox, maxTApprox, idxApprox, tChangeApprox] = applyCPMmean(h,numberOfStates,window,finalDataset,'approx');
figure(2), plot(maxTApprox)
line([0 100],[h h],'LineWidth',2,'Color','b')

difference = (maxTExact - maxTApprox);
