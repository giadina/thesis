close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Multinomial CDT/')
addpath('Datasets/')

%Variables intialization
CPM = 'max_cpm';          %'max_cpm', 'out_cpm';
CPM_mode = 'online';      %'offline', 'online';
Shift_mode = 'approx';    %'exact', 'approx';
Data_type = 'gaussian';   %'gaussian', 'discrete';
numberOfStates = 5;
window = 300;
DELTA = 5;             %DELTA can be maximum 1
N = 10000;
tChange = 7500;
confidence = 0.01;

%Generate the dataset
switch lower(Data_type)
    case{'gaussian'}
        finalDataset = gaussianDataset(numberOfStates, DELTA, N, tChange);
    case{'discrete'}
        finalDataset = discreteDataset(numberOfStates, DELTA, N, tChange);
end

%Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
estimateVector = vectorEstimation(finalDataset,numberOfStates, window, Data_type);

fprintf('Detection with %s dataset, %s CPM, %s modality.\n',Data_type, CPM, CPM_mode);

switch lower(CPM)
    case {'max_cpm'}
        fprintf('%s statistic.\n', Shift_mode);
        THRESHOLD = selectThreshold(numberOfStates, window, confidence);
        % Apply CPM mean
        [ hotellingT, maxT, idx, tChange ] = applyCPMmean(THRESHOLD,estimateVector,Shift_mode,CPM_mode);
        disp(['Change point found at: ', num2str(tChange)]);
        switch lower(CPM_mode)
            case {'online'}
                figure, plot(maxT,'LineWidth',1)
                line([0 length(maxT)],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
                legend('CPM online', 'threshold')
            case {'offline'}
                figure, plot(hotellingT,'LineWidth',1)
                line([0 length(hotellingT)],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
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
        [ out_cpm, l_max, tau ] = CPM_Multi(estimateVector.', CPM_param);
        if l_max > THRESHOLD(1)
            counter = tau;
        end
        disp(['Change point found at: ', num2str(tau)]);
        figure, plot(out_cpm,'LineWidth',1)
        line([0 length(finalDataset)],[THRESHOLD(1) THRESHOLD(1)],'LineStyle','-.','Color', 'r')
end