function [ hotellingT ] = ShiftDifference( tChange, estimateVector)
%SHIFTDIFFERENCE Summary of this function goes here
%   Detailed explanation goes here

tEnd = length(estimateVector);
coeff = sqrt(tChange*(tEnd-tChange)/tEnd);

stdDifference = coeff*(meanEstimation(0,tChange,estimateVector) - meanEstimation(tChange,tEnd,estimateVector));

hotellingT = ((stdDifference.'/covarianceEstimation(tChange, estimateVector))*stdDifference);

end
