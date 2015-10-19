close all
clear
clc

addpath('Functions/')
addpath('Datasets/')

%Variables initialization
window = 100;
numberOfStates = 2;
[finalDataset] = discreteDataset();
limit = floor(length(finalDataset)/window);
observationVector = zeros(numberOfStates,limit);
estimateVector = zeros(numberOfStates,limit);
c = 1;

%Calculate the observation matrix Nij(number of transitions among the matrix states) for non-overlapping slots of '#window' data
for i=1:window:(limit*window)
    for z=i:window+i-1
        observationVector(finalDataset(z),c) = observationVector(finalDataset(z),c) + 1;
    end
    c = c + 1;
end

estimateVector(:,:) =  observationVector(:,:)/window;