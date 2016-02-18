function [ covValue ] = covarianceMatrix( t, X )
%COVARIANCE Summary of this function goes here
%   Detailed explanation goes here

meanPreChange = meanEstimation(1,t,X);
covValue = 0;
for i=1:t
    vectPre = X(:,i) - meanPreChange;
    covValue = covValue + dot(vectPre,vectPre.');
end
covValue = covValue/t;

end

