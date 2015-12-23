close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

%Variables initialization
N = 10000;
window = 100;
numberOfStates = 2;
percentili = [99 99.5 99.8 99.9 99.95];
resPercentili = zeros(1,length(percentili));
Shift_mode = 'exact';
maxTot = zeros(1000,1);

fileID = fopen('thresholds_p50.txt','w');
for run=1:1000
    [finalDataset] = Data_creation(numberOfStates, N);
    fprintf('Experiment %d \n', run);
    
    %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
    estimateVector = vectorEstimation(finalDataset,numberOfStates, window, 'discrete');
    
    % Find maximum
    for t=1:size(estimateVector,2)
        hotellingT(1,t) = ShiftDifference(t, estimateVector, Shift_mode);
        [maxT, idx] = max(hotellingT);
    end
   
    maxTot(run,1) = maxT;
end

for q=1:length(percentili)
    resPercentili(1,q)= prctile(maxTot,percentili(q));
end

fprintf(fileID,'\n%d\n ',resPercentili);
fclose(fileID);