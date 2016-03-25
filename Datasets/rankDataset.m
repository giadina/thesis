function [ finalDataset ] = rankDataset( p, mu, N,tChange,DELTA )
%RANKDATASET Summary of this function goes here
%   Detailed explanation goes here
S = abs(randn(p,p));
S = S * S';
S= eye(p);

% Create the distribution
DELTA_tmp=zeros(1,p);
for i=1:p
    DELTA_tmp(1,i) = DELTA;
end
fd = [mvnrnd(mu,S,tChange);bsxfun(@plus, mvnrnd(mu,S,N-tChange),DELTA_tmp)];
finalDataset = fd.';
end

