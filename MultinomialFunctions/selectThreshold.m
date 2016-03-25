function [ h ] = selectThreshold( numberOfStates, limit, confidence, Data_type )
%SELECTTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here

confRow = [0.01 0.005 0.002 0.001 0.0005];
if (numberOfStates <= 5)
    windowColumn = [NaN 33 50 100 200]';
else
    windowColumn = [NaN limit]';
end

switch lower(Data_type)
    case{'gaussian'}
        thr = load('/GAUSSIAN_THRESHOLDS.mat', sprintf('THRESHOLD_%d', numberOfStates));
        THRESHOLD = getfield(thr, sprintf('THRESHOLD_%d', numberOfStates));
        
    case{'discrete'}
        thr = load('/DISCRETE_THRESHOLDS.mat', sprintf('THRESHOLD_%d', numberOfStates));
        THRESHOLD = getfield(thr, sprintf('THRESHOLD_%d', numberOfStates));
end

THRESHOLD = [confRow; THRESHOLD];
THRESHOLD = [windowColumn THRESHOLD];
[a,b] = find(THRESHOLD == limit);
[c,d] = find(THRESHOLD == confidence);
h = THRESHOLD(a,d);
end

