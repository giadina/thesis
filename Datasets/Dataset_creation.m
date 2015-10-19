function [ finalDataset, trans ] = Dataset_creation()
%Create a Dataset of 10000 with a normal distribution and a change from
%data 5000 to 5300.
%Out data : finalDataset = a sequence of 10000 data

%Creation of a normal distribution and median estimation
rng(0,'twister');
variance = 2;
mean = 50;
Dataset = variance.*randn(10000,1) + mean;
med = median(Dataset);

%state1 is a vector with data under the median
%state2 is a vector with data above the median
state1 = zeros(1);
state2 = zeros(1);
finalDataset = zeros();

for i=1:length(Dataset)
    if (Dataset(i,:) < med)
        state1(i,:) = Dataset(i,:);
    else
        state2(i,:) = Dataset(i,:);
    end
end

down = state1(find(state1));
up = state2(find(state2));

%fill in a final vector with data taken from down and up vectors. In particular if
%rand < 0.5, the data is extracted from down, otherwise from up. This
%create a finalDataset with a distribution of 50% of being in both states.
d = 1;
u = 1;
for n=1:(length(Dataset)/2)
    if((rand < 0.5 && d < 5000 ) || u > 5000)
        finalDataset(n) = down(d); 
        d = d + 1;
        
    else
        finalDataset(n) = up(u);
        u = u + 1;
        
    end   
end

% Introduction of a change in the middle of the datastream
for n=(length(Dataset)/2):(length(Dataset)/2)+300
    finalDataset(n) = med + 200;
end

for n=(length(Dataset)/2)+300:length(Dataset)
    if((rand < 0.5 && d < 5000 ) || u > 5000)
        finalDataset(n) = down(d); 
        d = d + 1;
        
    else
        finalDataset(n) = up(u);
        u = u + 1;
        
    end   
end


% Estimate the Nij matrix, number of transition from state i to j.
cState = 1;
trans = zeros(2,2);
for z=1:length(finalDataset)
        
        if(finalDataset(z) < med)
            t = 1;
            
        else
            t = 2;
        end
        
        trans(cState,t) = trans(cState,t) + 1;
        cState = t;
end

%Simulate an exponential distribution
%npoints = 10000;
%lambda = 50;
%finalDataset(10001:20000) = simesponenziale(npoints, lambda);
media = 20;
m = 1;
n = 10000;
finalDataset(10001:20000) = esponenziale(media,m,n);

%plot(finalDataset)

end