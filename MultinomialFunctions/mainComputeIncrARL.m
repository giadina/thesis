close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

% Variables initialization
N = 10000;
window = 200;
numberOfStates = 3;
confidence = 0.01;
exp = 20;

THRESHOLD = selectThreshold(numberOfStates, window, confidence);
% Compute ARL over exp iterations
for run=1:exp
    
    fprintf('%d states, %d elements per window, experiment number %d.\n', numberOfStates, window, run);
    
    [finalDataset] = Data_creation(numberOfStates,N);
    %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
    estimateVector = vectorEstimation(finalDataset,numberOfStates, window);
    FLAG = 1;
    counter = 1;
    maxT = 0;
    
    while FLAG  % Thresholds still to overcome
        
        % Find maximum
        for t=1:size(estimateVector,2)
            hotellingT(1,t) = ShiftDifference(t, estimateVector, 'approx');
            [maxT, idx] = max(hotellingT);
        end
        
        % Compare maximum with thresholds 
        if (maxT > THRESHOLD)
            detection(run,1) = counter;
            FLAG = 0;
        else
            counter = counter + 1;
            fD = Data_creation(numberOfStates,window);
            eV = vectorEstimation(fD,numberOfStates, window);
            estimateVector = [estimateVector eV];
        end
    end
    
    fileID = fopen('ARL.txt','a');
    fprintf(fileID,'\n%d counter\n',counter);
    fclose(fileID);
end
ARL_0 = mean(detection,1);
fileID = fopen('ARL.txt','a');
fprintf(fileID,'\n%d arl\n',ARL_0);
fclose(fileID);
