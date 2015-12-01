function [ covValue ] = approxCovarianceEstimation( estimateVector )
%APPROXCOVARIANCEESTIMATION Summary of this function goes here
%   Detailed explanation goes here

%Cov approssimata prendendo solo la prima parte di pulled covariance
meanPreChange = meanEstimation(0,floor(size(estimateVector,2)/2),estimateVector);
covValue = 0;
for i=1:size(estimateVector,2)/2
    vectPre = estimateVector(:,i) - meanPreChange;
    covValue = covValue + dot(vectPre,vectPre.');
end
covValue = covValue/(size(estimateVector,2)/2 - 2);

end

