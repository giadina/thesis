close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

%Variables initialization
window = 100;
numberOfStates = 2;
h = 13.932;
[finalDataset] = discreteDataset();
limit = floor(length(finalDataset)/window);
estimateVector = [];

%Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
for i=window+1:window:(limit*window)+window
    vett = finalDataset(i - window:i-1);
    A = hist(vett,1:numberOfStates)';
    estimateVector = [estimateVector A/window];
end

for col=2:length(estimateVector)
    for t=1:col-1
        hotellingT(col,t) = ShiftDifference(t, estimateVector(:,1:col));
        [maxT(col,1), idx(col,1)] = max(hotellingT(col,:));
        
        if maxT >= h  %esecuzione normale
            tChange = idx;
        end
    end
end

% figure(1)
% plot(hotellingT)
% line([0 100],[h h],'LineWidth',2,'Color', 'b')