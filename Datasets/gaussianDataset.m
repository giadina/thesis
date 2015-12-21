function [ finalDataset ] = gaussianDataset(numberOfStates, DELTA, N, tChange)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Generate mu and S
mu = randn(numberOfStates,1);
S = abs(randn(numberOfStates,numberOfStates));
S = S * S';

% Create the distribution
X = [mvnrnd(mu,S,tChange); mvnrnd(mu,S,N-tChange)+DELTA];

% Generate the dataset
finalDataset = X.';
end

