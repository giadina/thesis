function [ discreteData ] = discreteDataset(  )
% Generate a random discrete Dataset of 10000 data and a change from instante tChange to the end of the stream;

numberOfStates = 2;
DELTA = 0.1;
N = 10000;
tChange = 7500;
p1 = zeros(1,numberOfStates);
p2 = zeros(1,numberOfStates);

for i=1:numberOfStates
    p1(1,i) = 1/numberOfStates;
end

for i=1:numberOfStates
    p2(1,i) = 1/numberOfStates;
end
p2 = [1/2-DELTA 1/2+DELTA];

% Create the distribution
pd1 = makedist('Multinomial','probabilities',p1);
pd2 = makedist('Multinomial','probabilities',p2);

% Generate the dataset
discreteData = [random(pd1,tChange,1); random(pd2,N-tChange,1)];

% discreteData = zeros(1,10000);
% numberOfStates = 2;
% tChange = 7500;
% window = 100;
% 
% for n=1:tChange
%     discreteData(n) = floor(rand*numberOfStates) + 1;
% end
% 
% for i=tChange:window:(length(discreteData)-window)
%     for n=i:window+i
%         if n <= i+70
%             discreteData(n) = 1;
%         else
%             discreteData(n) = 2;
%         end
%     end
% end
end
