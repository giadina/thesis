close all
clear
clc

addpath('Datasets/')

%Variables
threshold = 4.6250;
k = 0;
p = 4;
mu = zeros(1,p);
N = 100;
tChange = 75;
DELTA = -25;
training = 25;

for i=1:p
    g(i,1) = 1/p;
end

finalDataset = rankDataset(p, mu, N,tChange,DELTA);
% fd = iris_dataset;
% finalDataset = fd(:,1:100);

%Training set
% subMean = mean(finalDataset(:,1:training),2);
% finalDataset = bsxfun(@minus,finalDataset,subMean);
minElement = [];
antiRankMatrix = sort(finalDataset(:,1:training));
[minumun,idx] = min(finalDataset(:,1:training));
for i=1:training
    minElement(idx(1,i),i) = 1;
end

FLAG = 1;
for t=training+1:size(finalDataset,2)
    id = zeros(p,1);
    ar = sort(finalDataset(:,t));
    [minumun,idx] = min(finalDataset(:,t));
    id(idx,1) = 1;
    antiRankMatrix = [antiRankMatrix ar];
    minElement = [minElement id];
    
    S1m = sum(minElement(:,1:t-1),2);
    S2m = t*g;
    
    comp1 = bsxfun(@plus,(S1m - S2m),bsxfun(@minus,minElement(:,t),g));
    comp2 = diag((S2m+g).^-1);
    
    C = ((comp1.'*comp2)*comp1);
    
    if C <= k
        S1 = 0;
        S2 = 0;
    else
        S1 = (bsxfun(@minus,S1m,minElement(:,t))*(C - k))/C;
        S2 = (bsxfun(@plus,S2m,g)*(C - k))/C;
    end
    
    elem1 = S1 - S2;
    
    if (S2 == 0)
        elem2 = diag(1/S2);
    else
        diagonal = [1/S2(1,1),1/S2(2,1),1/S2(3,1),1/S2(4,1)];
        elem2 = diag(diagonal);
    end
    
    statistic(1,t) = ((elem1.'*elem2)*elem1);
    %     result = 0;
    %     for c=1:p
    %         result = result + ((elem1(c,1)).^2)/S2(c,1);
    %     end
    %     statistic(1,t) = result;
    
    while FLAG
        if statistic(1,t) > threshold
            tau = t;
            FLAG = 0;
        else
            tau = 0;
        end
        break;
    end
    
end

figure, plot(statistic,'LineWidth',1)
line([0 length(statistic)],[threshold threshold],'LineStyle','-.','Color','r')
disp(['Change point found at: ', num2str(tau)]);