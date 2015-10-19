close all
clear
clc

addpath('Functions/')
addpath('Datasets/')

%Variables initialization
[finalDataset] = Dataset_creation();
window = 100;
window_training = 300;
numberOfSteps = 2;
tm = zeros(numberOfSteps,numberOfSteps);
currentState = 1;
transition = -1;
c = 1;

slot = finalDataset(1:window_training);
limit = floor(length(finalDataset)/window);
med = median(slot);
myArray = zeros(numberOfSteps,numberOfSteps,limit);

%Calculate the observation matrix Nij for non-overlapping slots of 100 data
%and fill in myArray with these matrices.
%Nij contains states 1 and 2; a data belongs to state 1 if its value is
%under the median, otherwise state 2.
for i=window_training+1:window:(limit*window)
    for z=i:window+i-1
        if(finalDataset(z) < med)
            transition = 1;
        else
            transition = 2;
        end
        tm(currentState,transition) = tm(currentState,transition) + 1;
        currentState = transition;
    end
    myArray(:,:,c) = tm;
    c = c + 1;
    tm(:) = 0;   
end

[lkh, pij] = sumLogLikelihood(myArray);
figure(1)
plot(lkh)
title('Likelihood without training window')

[lkh2, pij2] = sumLogLikelihood2(myArray);
figure(2)
plot(lkh2)
title('Likelihood with training window')
