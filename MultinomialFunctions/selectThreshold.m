function [ h ] = selectThreshold( numberOfStates, window, confidence )
%SELECTTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here

confRow = [0.01 0.005 0.002 0.001 0.0005];
if (numberOfStates <= 5)
    windowColumn = [NaN 300 200 100 50]';
else
    windowColumn = [NaN window]';
end
thr = load('/THRESHOLDS.mat', sprintf('THRESHOLD_%d', numberOfStates));
THRESHOLD = getfield(thr, sprintf('THRESHOLD_%d', numberOfStates));
THRESHOLD = [confRow; THRESHOLD];
THRESHOLD = [windowColumn THRESHOLD];
[a,b] = find(THRESHOLD == window);
[c,d] = find(THRESHOLD == confidence);
h = THRESHOLD(a,d);
end

