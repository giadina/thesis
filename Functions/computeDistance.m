function [ distanceVector, estimateArray, confidenceArray] = computeDistance( lambda,numberOfStates,observationMatrix )
% Estimate the distance function as the difference ?(P(t) - P(t+w))^2 where P is the estimated matrix
% at each time t and t+window.
%
% In data : lambda = array of confidence levels
%           numberOfStates = number of state of the markov chain
%           observationMatrix = array containing all the N(ij) matrices; each matrix represents the number of transition from state i to j.                              
%
% Out data : distanceVector = distance function estimated as above.
%            estimateArray = array containing the P(t) matrices estimated from observationMatrix
%            confidenceArray = confidence intervals estimated from lambda

distanceVector = zeros(1);
estimateArray = zeros(numberOfStates,numberOfStates,size(observationMatrix,3));
distance = 0;

% Compute the estimateArray as N(ij)/N, where N is the total number of
% times the chain leaves state i.
for n=1:size(observationMatrix,3)
    for idx=1:size(observationMatrix,1)
        for j=1:size(observationMatrix,2)
            estimateArray(idx,j,n) = (observationMatrix(idx,j,n) / sum(observationMatrix(idx,:,n),2));
        end
    end
end
estimateArray(isnan(estimateArray)) = 0;

confidence = confidence_interval(lambda,estimateArray,observationMatrix,numberOfStates);
confidenceArray = permute(reshape(confidence.', 2,numberOfStates*numberOfStates,[]),[2 1 3]);

%Compute the distance function comparing two adjacent matrices P.
for z=1:size(estimateArray,3)-1
    for a=1:size(estimateArray,1)
        for b=1:size(estimateArray,2)
            distance = distance + (estimateArray(a,b,z) - estimateArray(a,b,z+1))^2;
        end
    end
    distanceVector(z) = distance;
    distance = 0;
end
end