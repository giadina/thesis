close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

%Variables initialization
window = 300;
numberOfStates = 2;
percentili = [99 99.5 99.8 99.9 99.95];
resPercentili = zeros(1,length(percentili));
Shift_mode = 'exact';
Data_type = 'gaussian';
DELTA = 0;
N = 10000;
tChange = 7500;
maxTot = zeros(1000,1);
limit = floor(N/window);
value = 0;

FILENAME = sprintf('thresholds_w%d_NS%d.txt', window,numberOfStates);
fileID = fopen(FILENAME,'w');
for run=1:1000
    switch lower(Data_type)
        case{'gaussian'}
            finalDataset = gaussianDataset(numberOfStates, DELTA, limit, floor(tChange/window));
            estimateVector = finalDataset.';
        case{'discrete'}
            finalDataset = Data_creation(numberOfStates, N);
            %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
            estimateVector = vectorEstimation(finalDataset,numberOfStates, window);
    end
    fprintf('Experiment %d \n', run);
    
    % Find maximum
    for t=1:size(estimateVector,2)
        hotellingT(1,t) = ShiftDifference(t, estimateVector, Shift_mode,value);
        [maxT, idx] = max(hotellingT);
    end
    
    maxTot(run,1) = maxT;
end

for q=1:length(percentili)
    resPercentili(1,q)= prctile(maxTot,percentili(q));
end

fprintf(fileID,'\n%d\n ',resPercentili);
fclose(fileID);