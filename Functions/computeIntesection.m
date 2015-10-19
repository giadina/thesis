function [up,down] = computeIntesection(intersection_interval_UP,intersection_interval_DWN,interval_UP,interval_DWN)
% intersection_interval_UP,
% intersection_interval_DWN,
% interval_UP,
% interval_DWN
%
% the output will be two column vectors indicating the upper and lower bound
% of intersection

if intersection_interval_UP(end,:,:) == 0
    up = min(intersection_interval_UP(find(intersection_interval_UP ~= 0, 1, 'last' )),interval_UP);
    down = max(intersection_interval_DWN(find(intersection_interval_DWN ~= 0, 1, 'last' )),interval_DWN);
else
    up = min(intersection_interval_UP(end,:,:),interval_UP);
    down = max(intersection_interval_DWN(end,:,:),interval_DWN);
end
%end

