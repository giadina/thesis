function [ covarianceVector ] = covarianceEstimation( tChange, estimateVector )
%COVARIANCEESTIMATION Summary of this function goes here
%   Detailed explanation goes here

coeff = size(estimateVector,2)-2;
tEnd = size(estimateVector,2);
sumPreChange = 0;
sumPostChange = 0;
meanPreChange = meanEstimation(0,tChange,estimateVector);
meanPostChange = meanEstimation(tChange,tEnd,estimateVector);

for i=1:tChange
    vectPre = estimateVector(:,i) - meanPreChange;
    sumPreChange = sumPreChange + dot(vectPre,vectPre.');
end
for ii=tChange+1:tEnd
    vectPost = estimateVector(:,ii) - meanPostChange;
    sumPostChange = sumPostChange + dot(vectPost,vectPost.');
end

covarianceVector = (sumPreChange + sumPostChange)/coeff;
end

