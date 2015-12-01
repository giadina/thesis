close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

% Variables initialization
N = 10000;
window = [300, 200, 100, 50];
numberOfStates = [2, 3, 4, 5];
ARL_0 = zeros(5,1);
exp = 3;

for ns=1:length(numberOfStates)
    
    thr = load('/THRESHOLDS.mat', sprintf('THRESHOLD_%d', numberOfStates(ns)));
    THRESHOLD = getfield(thr, sprintf('THRESHOLD_%d', numberOfStates(ns)));
    
    for w=1:length(window)
        
        % Compute ARL over 10 iterations
        for run=1:exp
            
            fprintf('%d states, %d elements per window, experiment number %d.\n', numberOfStates(ns), window(w), run);
            [finalDataset] = Data_creation(numberOfStates(ns),N);
            limit = floor(length(finalDataset)/window(w));
            estimateVector = [];
            
            FLAG = ones(5,1);
            while (sum(FLAG) > 0)  % Thresholds still to overcome
                
                % Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
                for i=window(w)+1:window(w):(limit*window(w))+window(w)
                    if (length(finalDataset)+1 >= i)
                        vett = finalDataset(i - window(w):i-1);
                        A = hist(vett,1:numberOfStates(ns))';
                        estimateVector = [estimateVector A/window(w)];
                    end
                end
                
                % Find maximum
                for t=1:size(estimateVector,2)
                    hotellingT(1,t) = ShiftDifference(t, estimateVector, 'approx');
                    [maxT, idx] = max(hotellingT);
                end
                
                % Compare maximum with thresholds
                for i = 1:5
                    if (maxT > THRESHOLD(w,i)) && (FLAG(i) == 1)
                        detection(i,run) = length(estimateVector);
                        FLAG(i) = 0;
                    end
                end
                
                finalDataset = Data_creation(numberOfStates(ns),window(w));
            end
        end
        ARL_0 = [ARL_0 mean(detection,2)];
    end
end

ARL_0(:,1) = [];
