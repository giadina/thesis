function [ intersection_interval_UP, intersection_interval_DWN, nilIntersection ] = showIntersections(confidenceArrayStates)
% Checks if there is intersection between the current confidence interval instant and the last computed intersection.
% If it exists, the new instersection is computed.
% 
% In data : confidenceArrayStates = array containing confidence intervals for each state of the markov chain;
% 
% Out data : intersection_interval_UP = upper bound of the intersection array
%            intersection_interval_DWN = lower bound of the intersection array
%            nilIntersection = time instants without intersection

interval_DWN = confidenceArrayStates(:,1,:);
interval_UP = confidenceArrayStates(:,2,:);
intersection_interval_UP = confidenceArrayStates(1,2,:);
intersection_interval_DWN = confidenceArrayStates(1,1,:);
nilIntersection = {};
index = 1;

for row = 1:size(interval_DWN,1)
    [res, support, testDetectingChange] = checkIntersection(intersection_interval_UP(:,:,:),intersection_interval_DWN(:,:,:),interval_UP(row,:,:),interval_DWN(row,:,:));
    newRow = [row testDetectingChange];
    if (res == 0)     %res == 0 if there is no intersection
        nilIntersection{index} = newRow;
        index = index + 1;
    end
    if (support)   %support, array of states in which there's intersection 
        for s=1:size(support,2)
            temp = support(1,s);
            [intersection_interval_UP(row,:,temp) , intersection_interval_DWN(row,:,temp)] = computeIntesection(intersection_interval_UP(:,:,temp), intersection_interval_DWN(:,:,temp), interval_UP(row,:,temp), interval_DWN(row,:,temp));
        end
    end
end

nilIntersection = nilIntersection.';
end

