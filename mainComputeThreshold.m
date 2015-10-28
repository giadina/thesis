close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

%Variables initialization
window = 100;
numberOfStates = 2;
percentili = [99 99.5 99.8 99.9 99.95];
resPercentili = zeros(1,length(percentili));

for run=1:1000
    [finalDataset] = discreteDataset();
    limit = floor(length(finalDataset)/window);
    estimateVector = [];
    c = 1;
    
    %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
    for i=window+1:window:(limit*window)+window
        vett = finalDataset(i - window:i-1);
        A = hist(vett,1:numberOfStates)';
        estimateVector = [estimateVector A/window];
    end
    
    for t=1:length(estimateVector)
        hotellingT(1,t) = ShiftDifference(t, estimateVector);
        maxT = max(hotellingT);
        idx = find(hotellingT==(max(hotellingT)));
    end
    
%     hotellingTot(run,:) = hotellingT(:,:);
    maxTot(run,1) = maxT;
%     meanHotelling = mean(hotellingTot);
%     meanMaxT = mean(maxTot);
    
    for q=1:length(percentili)
        resPercentili(1,q)= prctile(maxTot,percentili(q));
    end
    
end