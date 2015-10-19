close all
clear
clc

addpath('Functions/')
addpath('Datasets/')

%Variables initialization
window = 100;
numberOfStates = 2;
tm = zeros(numberOfStates,numberOfStates);
lambda = [2.57 2.17 1.96 1.64 1.44 1.15]; %confidence level: 99% 97% 95% 90% 85% 75%
nilIntersection = cell(1,length(lambda)); %time instants without intersections for each lambda value
tStart = zeros(numberOfStates*numberOfStates,length(lambda)); %first non-intersection instant
tChange = 76;
temp = {};
rowNames = {'99%' '97%' '95%' '90%' '85%' '75%'};
FN = repmat({zeros(1,numberOfStates*numberOfStates)}, length(rowNames), 1);
FP = repmat({zeros(1,numberOfStates*numberOfStates)}, length(rowNames), 1);
OK = repmat({zeros(1,numberOfStates*numberOfStates)}, length(rowNames), 1);
resultTable = table(FN,FP,OK,...
    'RowNames',rowNames);

for test=1:1000
    
    [finalDataset] = discreteDataset();
    limit = floor(length(finalDataset)/window);
    observationMatrix = zeros(numberOfStates,numberOfStates,limit);
    currentState = finalDataset(1);
    transition = -1;
    c = 1;
    %tEnd = zeros(numberOfStates*numberOfStates,1);
    
    %Calculate the observation matrix Nij(number of transitions among the matrix states) for non-overlapping slots of '#window' data
    for i=1:window:(limit*window)
        for z=i:window+i-1
            transition = finalDataset(z);
            tm(currentState,transition) = tm(currentState,transition) + 1;
            currentState = transition; 
        end
        observationMatrix(:,:,c) = tm;
        c = c + 1;
        tm(:) = 0;
    end
    
    for l=1:length(lambda)
        [distanceVector, estimatePij, confidenceArray] = computeDistance(lambda(l),numberOfStates, observationMatrix);
        [estimateVectorStates, confidenceArrayStates] = plotStates(estimatePij, confidenceArray, limit, numberOfStates);
        [intersection_interval_UP, intersection_interval_DWN, nilIntersection{1,l}] = showIntersections(confidenceArrayStates);
        
        for p=1:size(nilIntersection{1,l},1)
            temp{p,1} = nilIntersection{1,l}{p,1};
        end
        
        %Fill in tStart matrix with the first non-intersection instant for each state
        for elem=1:numberOfStates*numberOfStates
            for i=1:length(temp)
                if(find(temp{i}(1,2:end) == elem))
                    tStart(elem,l) = temp{i}(1,1);
                    break;
                end
            end
        end
    end
    
    %Fill in resultTable with the number of false positive,false negative
    %and correct instant after 1000 tests
    for row=1:size(tStart,1)
        for column=1:size(tStart,2)
            if (tStart(row,column) == 0)
                resultTable.FN{column}(1,row) = resultTable.FN{column}(1,row) + 1;
            elseif (tStart(row,column) < tChange)
                resultTable.FP{column}(1,row) = resultTable.FP{column}(1,row) + 1;
            else
                resultTable.OK{column}(1,row) = resultTable.OK{column}(1,row) + 1;
            end
        end
    end
    
    %     for state=1:size(intersection_interval_UP,3)
    %         UP = intersection_interval_UP(:,:,state);
    %         tEnd(state) = (find(UP ~= 0,1,'last'));
    %     end
    %for val=2:length(lambda)
    %[intersection_interval_UP2, intersection_interval_DWN2, nilIntersection2,confidenceArrayStates2,tStart] = confirmIntersection(lambda(val),estimatePij,observationMatrix,numberOfStates);
    %     plotResults(numberOfStates,distanceVector,estimateVectorStates,intersection_interval_UP, intersection_interval_DWN,confidenceArrayStates);
    %end DA INSERIRE DENTRO PLOTRESULTS,confidenceArrayStates2,intersection_interval_UP2, intersection_interval_DWN2,tEnd,tStart
    
    % interval_dim = zeros();
    % for elem=1:length(confidence)
    %     interval_dim(elem) = confidence(elem,2)-confidence(elem,1);
    % end
    % interval_dim = interval_dim';
end