function [ discreteData ] = discreteDataset( numberOfStates )
% Generate a random discrete Dataset of 10000 data and a change from instante tChange to the end of the stream;

DELTA = 0.1;
N = 10000;
tChange = 7500;
p1 = zeros(1,numberOfStates);
% p2 = zeros(1,numberOfStates);

for i=1:numberOfStates
    p1(1,i) = 1/numberOfStates;
end

% for i=1:numberOfStates
%     p2(1,i) = rand*DELTA;
% end
% p2 = p2/sum(p2);

% Create the distribution
pd1 = makedist('Multinomial','probabilities',p1);
% pd2 = makedist('Multinomial','probabilities',p2);

% Generate the dataset
% discreteData = [random(pd1,tChange,1); random(pd2,N-tChange,1)];

discreteData = random(pd1,N,1)';
    
end
