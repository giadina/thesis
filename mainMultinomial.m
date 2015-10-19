close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

%Variables initialization
window = 100;
numberOfStates = 2;
[finalDataset] = discreteDataset();
limit = floor(length(finalDataset)/window);
observationVector = zeros(numberOfStates,limit);
estimateVector = zeros(numberOfStates,limit);
c = 1;

%Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
for i=1:window:(limit*window)
    for z=i:window+i-1
        observationVector(finalDataset(z),c) = observationVector(finalDataset(z),c) + 1;
    end
    c = c + 1;
end
estimateVector(:,:) = observationVector(:,:)/window;

for t=1:length(estimateVector)
    %covarianceVector = covarianceEstimation(t,estimateVector);
    hotellingT(1,t) = ShiftDifference(t, estimateVector);
    maxT = max(hotellingT);
    idx = find(hotellingT==(max(hotellingT)));
    if maxT >= 300
        tChange = idx;
    end
end
figure(1)
plot(hotellingT)