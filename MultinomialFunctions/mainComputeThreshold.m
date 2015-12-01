close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

%Variables initialization
N = 6250000;
window = 2500;
numberOfStates = 50;
percentili = [99 99.5 99.8 99.9 99.95];
resPercentili = zeros(1,length(percentili));
Shift_mode = 'exact';
% mediaT = zeros(1,3);
% h = 13.932;
% for prova=1:3
%     test = 0;

fileID = fopen('thresholds_p50.txt','w');
for run=1:1
    [finalDataset] = Data_creation(numberOfStates, N);
    limit = floor(length(finalDataset)/window);
    estimateVector = [];
    fprintf('Experiment %d \n', run);
    
    %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
    for i=window+1:window:(limit*window)+window
        vett = finalDataset(i - window:i-1);
        A = hist(vett,1:numberOfStates)';
        estimateVector = [estimateVector A/window];
    end
    
    % Find maximum
    for t=1:size(estimateVector,2)
        hotellingT(1,t) = ShiftDifference(t, estimateVector, Shift_mode);
        [maxT, idx] = max(hotellingT);
    end
    
    %     hotellingTot(run,:) = hotellingT(:,:);
    maxTot(run,1) = maxT;
    %     meanHotelling = mean(hotellingTot);
    %     meanMaxT = mean(maxTot);
    
end

for q=1:length(percentili)
    resPercentili(1,q)= prctile(maxTot,percentili(q));
end

fprintf(fileID,'\n%d\n ',resPercentili);
fclose(fileID);
%controllo superamento soglia fissa
%         if maxT >= h
%             test = test +1;
%         end
%     end
%     mediaT(1,prova) = test;
% end
