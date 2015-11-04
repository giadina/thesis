function [ hotellingT, maxT, idx, tChange] = applyCPMmean( h,numberOfStates,window,finalDataset )
%APPLYCPMMEAN Summary of this function goes here
%   Detailed explanation goes here
%Variables initialization

limit = floor(length(finalDataset)/window);
estimateVector = [];

%Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
for i=window+1:window:(limit*window)+window
    vett = finalDataset(i - window:i-1);
    A = hist(vett,1:numberOfStates)';
    estimateVector = [estimateVector A/window];
end

% Compute maximum and compare it with the threshold
for col=2:length(estimateVector)
    for t=1:col-1
        hotellingT(col,t) = ShiftDifference(t, estimateVector(:,1:col));
        [maxT(col,1), idx(col,1)] = max(hotellingT(col,:));
        
        if maxT(col,1) >= h
            tChange = idx(col,1);
            dimension = col;
        end
    end
end
end

