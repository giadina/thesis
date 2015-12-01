function [ discreteData ] = Data_creation( numberOfStates,N )
%DATASET without change point

p1 = zeros(1,numberOfStates);

for i=1:numberOfStates
    p1(1,i) = 1/numberOfStates;
end

% Create the distribution
pd1 = makedist('Multinomial','probabilities',p1);

% Generate the dataset
discreteData = random(pd1,N,1)';
    
end

