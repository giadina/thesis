function [ discreteData ] = discreteDataset( numberOfStates, DELTA, N, tChange )
% Generate a random discrete Dataset of N data and a change starting from tChange untill the end of the stream;

negative = true;
while negative
    p1 = rand(1,numberOfStates);
    p1 = p1/sum(p1);
    
    p2 = rand(1,numberOfStates);
    p2 = p2/sum(p2);
    
    delta0 = sum(abs(p1 - p2));
    epsilon = delta0/DELTA;
    p3 = (p2 - p1)/epsilon + p1;
   
    if any(p3 < 0 | sum(p3) ~= 1)
        disp('Distribution contains negative probabilities or the sum is not one')
    else
        negative = false;
        p2 = p3;
    end
end

% Create the distribution
pd1 = makedist('Multinomial','probabilities',p1);
pd2 = makedist('Multinomial','probabilities',p2);

% Generate the dataset
discreteData = [random(pd1,tChange,1); random(pd2,N-tChange,1)];

end
