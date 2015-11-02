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
% mediaT = zeros(1,3);
% h = 13.932;
% for prova=1:3
%     test = 0;
for run=1:1000
    [finalDataset] = discreteDataset(numberOfStates);
    limit = floor(length(finalDataset)/window);
    estimateVector = [];
    
    %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
    for i=window+1:window:(limit*window)+window
        vett = finalDataset(i - window:i-1);
        A = hist(vett,1:numberOfStates)';
        estimateVector = [estimateVector A/window];
    end
    
    for t=floor(length(estimateVector)/2):length(estimateVector)
        hotellingT(1,t) = ShiftDifference(t, estimateVector);
        [maxT, idx] = max(hotellingT);
    end
    
%     hotellingTot(run,:) = hotellingT(:,:);
    maxTot(run,1) = maxT;
%     meanHotelling = mean(hotellingTot);
%     meanMaxT = mean(maxTot);
    
    for q=1:length(percentili)
        resPercentili(1,q)= prctile(maxTot,percentili(q));
    end
    
end
%controllo superamento soglia fissa
%         if maxT >= h
%             test = test +1;
%         end
%     end
%     mediaT(1,prova) = test;
% end
