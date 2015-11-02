function [ hotellingT ] = ShiftDifference( tChange, estimateVector)
%SHIFTDIFFERENCE Summary of this function goes here
%   Detailed explanation goes here

tEnd = size(estimateVector,2);
coeff = sqrt(tChange*(tEnd-tChange)/tEnd);

stdDifference = coeff*(meanEstimation(0,tChange,estimateVector) - meanEstimation(tChange,tEnd,estimateVector));

hotellingT = ((stdDifference.'/covarianceEstimation(tChange, estimateVector))*stdDifference);

end
