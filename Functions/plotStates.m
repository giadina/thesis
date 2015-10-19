function [ estimateVectorStates, confidenceArrayStates] = plotStates( estimateArray, confidenceArray, limit, numberOfStates)
% Arrange variables in order to have an array for each state.


dimension = numberOfStates*numberOfStates;
estimateVectorStates = zeros(limit,1,dimension);
confidenceArrayStates = zeros(limit,2,dimension);

for z=1:size(estimateArray,3)
    for a=1:size(estimateArray,1)
        index = (a - 1)*numberOfStates + 1;
        for b=1:size(estimateArray,2)
            estimateVectorStates(z,1,index) = estimateArray(a,b,z);
            index = index + 1;
        end
    end
end

for z=1:size(confidenceArray,3)
    for a=1:size(confidenceArray,1)
        for b=1:size(confidenceArray,2)
            confidenceArrayStates(z,b,a) = confidenceArray(a,b,z);
        end
    end   
end

end

