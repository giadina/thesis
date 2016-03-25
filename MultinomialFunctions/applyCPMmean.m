function [ hotellingT, maxT, idx, tChange, sampleReference] = applyCPMmean( h,estimateVector,Shift_mode, CPM_mode)
%APPLYCPMMEAN Summary of this function goes here
%   Detailed explanation goes here
if strcmp(Shift_mode,'approx')
    value = approxCovarianceEstimation(estimateVector);
elseif strcmp(Shift_mode,'exact')
    value = 0;
end
% Set covariance value based on Shift modality
switch lower(CPM_mode)
    case {'online'}
        FLAG = 1;
        training = 3;
        for col=training:size(estimateVector,2)
            for t=1:col-1
                hotellingT(col,t) = ShiftDifference(t, estimateVector(:,1:col),Shift_mode, value);
                [maxT(col,1), idx(col,1)] = max(hotellingT(col,:));
                
                % Compute maximum and compare it with the threshold
                while FLAG
                    if maxT(col,1) >= h
                        tChange = idx(col,1);
                        sampleReference = col;
                        FLAG = 0;
                    else
                        tChange = 0;
                    end
                    break;
                end
            end
            
        end
        
    case {'offline'}
        for t=1:size(estimateVector,2)
            hotellingT(1,t) = ShiftDifference(t, estimateVector, Shift_mode,value);
            [maxT, idx] = max(hotellingT);
        end
        if maxT >= h
            tChange = idx;
        else
            tChange = 0;
        end
end

end