function [ intersection_interval_UP2, intersection_interval_DWN2, nilIntersection2,confidenceArrayStates2,tStart ] = confirmIntersection( lambda,estimateArray,observationMatrix,numberOfStates )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

confidence2 = confidence_interval(lambda,estimateArray,observationMatrix,numberOfStates);
confidenceArray2 = permute(reshape(confidence2.', 2,numberOfStates*numberOfStates,[]),[2 1 3]);
confidenceArrayStates2 = zeros(size(observationMatrix,3),2,numberOfStates*numberOfStates);
tStart = zeros(numberOfStates*numberOfStates,1);

for z=1:size(confidenceArray2,3)
    for a=1:size(confidenceArray2,1)
        for b=1:size(confidenceArray2,2)
            confidenceArrayStates2(abs(z-size(confidenceArray2,3))+1,b,a) = confidenceArray2(a,b,z);
        end
    end   
end

[intersection_interval_UP2, intersection_interval_DWN2, nilIntersection2] = showIntersections(confidenceArrayStates2);
for i=1:length(nilIntersection2)
  nilIntersection2{i}(1,1) = (size(confidenceArrayStates2,1)-nilIntersection2{i}(1,1))+1;
end

for elem=1:numberOfStates*numberOfStates
    for i=1:length(nilIntersection2)
        if(find(nilIntersection2{i}(1,2:end) == elem))
            tStart(elem) = nilIntersection2{i}(1,1);
            break;
        end
    end
end
end

