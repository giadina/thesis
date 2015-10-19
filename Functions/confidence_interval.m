function [ interval ] = confidence_interval( lambda,estimateArray, observationMatrix, numberOfStates)
% Estimate the confidence interval of a guassian distribution as
% [p-(sqrt(p(1-p))lambda/sqrt(n)), p+(sqrt(p(1-p))lambda/sqrt(n))]
%
% In data : lambda = array of confidence levels
%           estimateArray = array containing the P(t) matrices estimated from observationMatrix
%           observationMatrix = array containing all the N(ij) matrices; each matrix represents the number of transition from state i to j.
%           numberOfStates = number of state of the markov chain
%                                        
% Out data : interval = confidence interval
%            
dimension = numberOfStates*numberOfStates;
interval=zeros(size(estimateArray,3)*dimension,2);
index = 1;

for n=1:size(estimateArray,3)
    for i=1:size(estimateArray,1)
        for j=1:size(estimateArray,2)
            interval(index,1) = (estimateArray(i,j,n)-(lambda*sqrt(prod(estimateArray(i,:,n),2))/sqrt(sum(observationMatrix(i,:,n),2))));
            interval(index,2) = (estimateArray(i,j,n)+(lambda*sqrt(prod(estimateArray(i,:,n),2))/sqrt(sum(observationMatrix(i,:,n),2))));
            index = index + 1;
        end
    end
end
end