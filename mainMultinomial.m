close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

%Variables initialization
window = 100;
numberOfStates = 2;
h = 13.932;
% for prova=1:3
%     test = 0;
%     for run=1:1000
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
    
    if maxT >= h  %esecuzione normale
        tChange = idx;
    end
end

%controllo superamento soglia fissa
%         if maxT >= h
%             test = test +1;
%         end
%   end
%     mediaT(1,prova) = test;
% end

figure(1)
plot(hotellingT)
line([0 100],[h h],'LineWidth',2,'Color', 'b')