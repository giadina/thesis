close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Multinomial CDT/')
addpath('Datasets/')

%Variables intialization
CPM = 'max_t';           %'max_t', 'out_cpm';
CPM_mode = 'online';    %'offline', 'online';
Shift_mode = 'approx';    %'exact', 'approx';
numberOfStates = 2;
window = 100;
DELTA = 0.3;             %DELTA can be maximum 1
N = 10000;
tChange = 7500;
confidence = 0.01;
[finalDataset] = discreteDataset(numberOfStates, DELTA, N, tChange);
limit = floor(length(finalDataset)/window);
estimateVector = [];

%Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
for i=window+1:window:(limit*window)+window
    vett = finalDataset(i - window:i-1);
    A = hist(vett,1:numberOfStates)';
    estimateVector = [estimateVector A/window];
end

fprintf('Detection with %s CPM, %s modality.\n', CPM, CPM_mode);

switch lower(CPM)
    case {'max_t'}
        fprintf('%s statistic.\n', Shift_mode);
        THRESHOLD = selectThreshold(numberOfStates, window, confidence);
        % Apply CPM mean
        [ hotellingT, maxT, idx, tChange ] = applyCPMmean(THRESHOLD,estimateVector,Shift_mode,CPM_mode);
        disp(['Change point found at: ', num2str(tChange)]);
        switch lower(CPM_mode)
            case {'online'}
                figure, plot(maxT,'LineWidth',1)
                line([0 100],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
                legend('CPM online', 'threshold')
            case {'offline'}
                figure, plot(hotellingT,'LineWidth',1)
                line([0 100],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
                legend('CPM offline', 'threshold')
        end
        
    case {'out_cpm'}
        %Variables initialization CPM mean,s
        CPM_type = 'full'; %'sel'
        CPM_init = round(length(finalDataset)/2) + 1;
        CPM_param = [];
        CPM_param.type = CPM_type;
        CPM_param.initPoint = CPM_init;
        load('COMPUTED_THRESHOLDs.mat');
        % Apply CPM mean,S
        [ out_cpm, l_max, tau ] = CPM_Multi( estimateVector.', CPM_param );
        if l_max > THRESHOLD(1)
            counter = tau;
        end
        disp(['Change point found at: ', num2str(tau)]);
        figure, plot(out_cpm,'LineWidth',1)
        line([0 length(finalDataset)],[THRESHOLD(1) THRESHOLD(1)],'LineStyle','-.','Color', 'r')
end