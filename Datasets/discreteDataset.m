function [ discreteData ] = discreteDataset(  )
% Generate a random discrete Dataset of 10000 data and a change from instante tChange to the end of the stream;

discreteData = zeros(1,10000);
numberOfStates = 2;
tChange = 7500;

for n=1:tChange
    discreteData(n) = floor(rand*numberOfStates) + 1;
end

%change introduction at tChange
for i=tChange:300:9900
    for n=i:i+38
        discreteData(n) = 1;
    end
    for n=i+39:2:i+71
        discreteData(n) = 2;
        discreteData(n+1) = 1;
    end
    for n=i+73:i+100
        discreteData(n) = 2;
    end
    if (n < length(discreteData))
        for n=i+101:i+145
            discreteData(n) = 1;
        end
        for n=i+146:2:i+176
            discreteData(n) = 2;
            discreteData(n+1) = 1;
        end
        for n=i+178:i+200
            discreteData(n) = 2;
        end
        
        for n=i+201:i+237
            discreteData(n) = 1;
        end
        for n=i+238:2:i+272
            discreteData(n) = 2;
            discreteData(n+1) = 1;
        end
        for n=i+274:i+300
            discreteData(n) = 2;
        end
    end
end
end
