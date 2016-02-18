function [ meanVector, covMatrix, M, D] = shiftedDimension( X, param )
%SHIFTEDDIMENSION Summary of this function goes here
%   Detailed explanation goes here
[N, p]=size(X);

switch lower(param.type)
    case {'full'}
        init_point = p + 1;
    case {'sel'}
        init_point = CPM_param.initPoint;
end


for m1 = init_point : N-p
    m2 = (N-m1);
    
    S1 = covarianceMatrix(m1,X.');
    S2 = covarianceMatrix(m2,X.');
    
    d = (sqrt(m1*m2)/N) * (meanEstimation(1,m1,X.') - meanEstimation(m1+1,N,X.'));
    Sw = (m1*S1 + m2*S2) / N;
    
    M(m1) = N * log(1 + ((d.'/Sw)* d));
    D(m1) = N * log(abs(Sw)/(abs(S1)^(m1/N) * abs(S2)^(m2/N)));
    
    meanVector(m1) = (100 * M)/(M + D);
    covMatrix(m1) = (100 * D)/(M + D);
end

 meanVector = meanVector.';
 covMatrix = covMatrix.';
end

