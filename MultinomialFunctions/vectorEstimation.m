function [ estimateVector ] = vectorEstimation(finalDataset, numberOfStates, window, Data_type)
%VECTORESTIMATION Summary of this function goes here
%   Detailed explanation goes here

limit = floor(length(finalDataset)/window);
estimateVector = [];

for i=window+1:window:(limit*window)+window
    vett = finalDataset(i - window:i-1,:);
    
    switch lower(Data_type)
        case{'gaussian'}
            A = hist(vett,1:numberOfStates);
        case{'discrete'}
            A = hist(vett,1:numberOfStates)';
    end
    
    estimateVector = [estimateVector A/window];
end

end

