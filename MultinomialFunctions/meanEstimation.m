function [ meanVector ] = meanEstimation( tStart, tEnd, estimateVector )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

coeff = (1/(tEnd-tStart));
meanVector = coeff*(sum(estimateVector(:,tStart+1:tEnd),2));

end