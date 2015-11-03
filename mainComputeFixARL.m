close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

% Variables initialization
window = [300, 200, 100, 50];
numberOfStates = [2, 3, 4, 5];
ARL_0 = zeros(5,1);
exp = 10;

for ns=1:length(numberOfStates)
    
    thr = load('/THRESHOLDS.mat', sprintf('THRESHOLD_%d', numberOfStates(ns)));
    THRESHOLD = getfield(thr, sprintf('THRESHOLD_%d', numberOfStates(ns)));
    
    for w=1:length(window)
        
        % Compute ARL over 10 iterations
        for run=1:exp
            
            counter = 1;
            FLAG = ones(5,1);
            while (sum(FLAG) > 0)  % Thresholds still to overcome
                
                [finalDataset] = discreteDataset(numberOfStates(ns));
                limit = floor(length(finalDataset)/window(w));
                estimateVector = [];
                
                % Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
                for i=window(w)+1:window(w):(limit*window(w))+window(w)
                    vett = finalDataset(i - window(w):i-1);
                    A = hist(vett,1:numberOfStates(ns))';
                    estimateVector = [estimateVector A/window(w)];
                end
                
                % Find maximum
                for t=1:length(estimateVector)
                    hotellingT(1,t) = ShiftDifference(t, estimateVector);
                    [maxT, idx] = max(hotellingT);
                end
                
                % Compare maximum with thresholds
                for i = 1:5
                    if (maxT > THRESHOLD(w,i)) && (FLAG(i) == 1)
                        detection(i,run) = counter;
                        FLAG(i) = 0;
                    end
                end
                
                counter = counter + 1;
            end
        end
        ARL_0 = [ARL_0 mean(detection,2)];
    end
end

ARL_0(:,1) = [];
