function [ distanceVector ] = computeDistance2( observationMatrix )
% Estimate the distance function as the difference ?(P(t) - P(t+w))^2 where P is the estimated matrix
% at each time t and t+window.
% 
% In data : observationMatrix = array containing all the N(ij) matrices;
%                               each matrix represents the number of transition from state i to j.
%
% Out data : distanceVector = distance function estimated as above.
            
distanceVector = zeros(1);
estimateArray = zeros(2,2,size(observationMatrix,3));
distance = 0;

% Compute the estimateArray as N(ij)/N, where N is the total number of
% times the chain leaves state i.
for n=1:size(observationMatrix,3)
    for i=1:size(observationMatrix,1)
        for j=1:size(observationMatrix,2)
            estimateArray(i,j,n) = (observationMatrix(i,j,n) / sum(observationMatrix(i,:,n),2));
        end
    end
end
estimateArray(isnan(estimateArray)) = 0 ;

%Compute the distance function comparing every slot with the training set
for z=1:size(estimateArray,3)-1
    for a=1:size(estimateArray,1)
        for b=1:size(estimateArray,2)
            distance = distance + (estimateArray(a,b,1) - estimateArray(a,b,z+1))^2;
        end
    end
    
    distanceVector(z) = distance;
    distance = 0;
end
 
end
