close all
clear
clc

addpath('../MultinomialFunctions/')
addpath('../Datasets/')

%Variables intialization
Data_type = 'gaussian';   %'gaussian', 'discrete';
Shift_mode = 'exact';
window = [300, 200, 100, 50];
numberOfStates = [2, 3, 4, 5];
confidence = [0.01, 0.005, 0.002, 0.001, 0.0005];
DELTA = 0;
N = 10000;
tChange = 7500;
mediaT = zeros(1,3);

for ns=1:length(numberOfStates)
    for w=1:length(window)
        limit = floor(N/window(w));
        for c=1:length(confidence)
            THRESHOLD = selectThreshold(numberOfStates(ns), window(w), confidence(c), Data_type);
            
            fprintf('%d stati, finestra di %d campioni, confidenza del %d, soglia %d.\n',numberOfStates(ns), window(w), confidence(c), THRESHOLD);
            for prova=1:3
                fp = 0;
                for run=1:1000
                    fprintf('esperimento numero %d, esecuzione numero %d\n',run, prova);
                    %Generate the dataset
                    switch lower(Data_type)
                        case{'gaussian'}
                            finalDataset = gaussianDataset(numberOfStates(ns), DELTA, limit, floor(tChange/window(w)));
                            estimateVector = finalDataset.';
                        case{'discrete'}
                            finalDataset = Data_creation(numberOfStates(ns), N);
                            %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
                            estimateVector = vectorEstimation(finalDataset,numberOfStates(ns), window(w));
                    end
                    
                    for t=1:size(estimateVector,2)
                        hotellingT(1,t) = ShiftDifference(t, estimateVector, Shift_mode);
                        [maxT, idx] = max(hotellingT);
                    end
                    if maxT >= THRESHOLD
                        fp = fp +1;
                    end
                    
                end
                mediaT(1,prova) = fp;
            end
            
            FP = mean(mediaT);
            fileID = fopen('FP_gaussian.txt','a');
            fprintf(fileID,'\n%d falsi positivi, %d stati, finestra di %d campioni, confidenza del %d %, soglia %d.\n',FP,numberOfStates(ns),window(w),confidence(c),THRESHOLD);
            fclose(fileID);
        end
    end
end