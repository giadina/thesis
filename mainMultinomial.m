close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Datasets/')

% h = [43.093 38.145 35.586 33.863 32.562 31.543 30.746 30.023 29.399 28.862 28.359 27.935 27.541 27.179 26.846 26.531...
%     26.266 25.968 25.712 25.499 25.266 25.084 24.871 24.703 24.527 23.790 23.155 22.719 22.367 22.020 21.757 21.506...
%     21.341 21.155 20.993];
h = 20.993;
%Variables initialization
window = 100;
numberOfStates = 5;
test = 0;
for run=1:1000
    %f = 1;
    [finalDataset] = discreteDataset();
    limit = floor(length(finalDataset)/window);
    observationVector = zeros(numberOfStates,limit);
    estimateVector = zeros(numberOfStates,limit);
    c = 1;
    
    %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
    for i=1:window:(limit*window)
        for z=i:window+i-1
            observationVector(finalDataset(z),c) = observationVector(finalDataset(z),c) + 1;
        end
        c = c + 1;
    end
    estimateVector(:,:) = observationVector(:,:)/window;
    
    for t=1:length(estimateVector)
   %for t=26:length(estimateVector)
        hotellingT(1,t) = ShiftDifference(t, estimateVector);
        maxT = max(hotellingT);
        idx = find(hotellingT==(max(hotellingT)));
        
        %if maxT >= log(h)  esecuzione normale
        % tChange = idx;
        %end
        
        %if(t<=50 || (rem(t,5) == 0))
        %   if hotellingT(1,t) >= log(h(f))
        %        test = test +1;
        %   end
        % end
        %f = f+1;
    end
    %controllo superamento soglia fissa
    if maxT >= log(h)
        test = test +1;
    end
end


%figure(1)
%plot(hotellingT)
%line([0 100],[h h],'LineWidth',2,'Color', 'b')