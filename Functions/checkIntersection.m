function [ res, support, testDetectingChange] = checkIntersection(intersection_interval_UP,intersection_interval_DWN,interval_UP,interval_DWN)
% Check if the interval [interval_UP,interval_DWN] intersects [intersection_interval_UP,intersection_interval_DWN]
%
% returns res=1 iff there is a non empty intesection; testDetectingChange indicates the test that failed
%

testDetectingChange = 0;
support = 0;

for state=1:size(intersection_interval_UP,3)
    if intersection_interval_UP(end,:,state) == 0
        tempUP = intersection_interval_UP(:,:,state);
        tempDWN = intersection_interval_DWN(:,:,state);
        upperIntersection(:,:,state) = (interval_DWN(:,:,state) < tempUP(find(tempUP ~= 0,1,'last')));
        lowerIntersection(:,:,state) = (interval_UP(:,:,state) > tempDWN(find(tempDWN ~= 0,1,'last')));
    else
        upperIntersection(:,:,state) = (interval_DWN(:,:,state) < intersection_interval_UP(end,:,state));
        lowerIntersection(:,:,state) = (interval_UP(:,:,state) > intersection_interval_DWN(end,:,state));
    end
end

% returns
res = all(all(upperIntersection .* lowerIntersection));
prova = upperIntersection .* lowerIntersection;
index = 1;
for i=1:size(prova,3)
    if (prova(1,1,i) == 1)
        [support(index)] = i;
        index = index + 1;
    end
end

%change is detected, save the test where the change has
%been detected
if res == 0
    [testDetectingChange] = find(upperIntersection .* lowerIntersection == 0);
    testDetectingChange = testDetectingChange.';
end