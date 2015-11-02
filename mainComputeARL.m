close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

%Variables initialization
window = 300;
numberOfStates = 2;
THRESHOLD = [15.4024 19,5527 22,7474 25,4283 27,0774];

for run=1:10
    counter = 1;
    FLAG = ones(5,1);
    while (sum(FLAG) > 0)
        [finalDataset] = discreteDataset();
        limit = floor(length(finalDataset)/window);
        estimateVector = [];
        
        %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
        for i=window+1:window:(limit*window)+window
            vett = finalDataset(i - window:i-1);
            A = hist(vett,1:numberOfStates)';
            estimateVector = [estimateVector A/window];
        end
        
        %Find maximum
        for t=1:length(estimateVector)
            hotellingT(1,t) = ShiftDifference(t, estimateVector);
            [maxT, idx] = max(hotellingT);
        end
        
        for i = 1:5
            if (maxT > THRESHOLD(i)) && (FLAG(i) == 1)
                detection(i,run) = counter;
                FLAG(i) = 0;
            end
        end
        counter = counter + 1;
    end
end

ARL_0 = mean(detection,2);