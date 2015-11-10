function [ hotellingT ] = ShiftDifference( tChange, estimateVector,Shift_mode,covValue)
%SHIFTDIFFERENCE Summary of this function goes here
%   Detailed explanation goes here

tEnd = size(estimateVector,2);
coeff = sqrt(tChange*(tEnd-tChange)/tEnd);

stdDifference = coeff*(meanEstimation(0,tChange,estimateVector) - meanEstimation(tChange,tEnd,estimateVector));

switch lower(Shift_mode)
    case {'exact'}
        hotellingT = ((stdDifference.'/covarianceEstimation(tChange, estimateVector))*stdDifference);
    case {'approx'}
        hotellingT = ((stdDifference.'/covValue)*stdDifference);
end

end
