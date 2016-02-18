function [ estimateVector ] = vectorEstimation(finalDataset, numberOfStates, window)
%VECTORESTIMATION Summary of this function goes here
%   Detailed explanation goes here

limit = floor(length(finalDataset)/window);
estimateVector = [];

for i=window+1:window:(limit*window)+window
    vett = finalDataset(i - window:i-1,:);
    A = hist(vett,1:numberOfStates)';
    
    estimateVector = [estimateVector A/window];
end

end

