close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Multinomial CDT/')
addpath('Datasets/')

%Variables intialization
CPM = 'meancov_cpm';          %'mean_cpm', 'meancov_cpm';
CPM_mode = 'online';      %'offline', 'online';
Shift_mode = 'exact';    %'exact', 'approx';
Data_type = 'gaussian';   %'gaussian', 'discrete';
numberOfStates = 3;
window = 100;
DELTA = 9;             %If Data_type=discrete DELTA<=1, otherwise DELTA>1
N = 10000;
limit = floor(N/window);
Change = 7500;
changeGaus = floor(Change/window);
confidence = 0.01;

%Generate the dataset
switch lower(Data_type)
    case{'gaussian'}
        finalDataset = gaussianDataset(numberOfStates, DELTA, limit, changeGaus);
        estimateVector = finalDataset.';
    case{'discrete'}
        discreteDataset = discreteDataset(numberOfStates, DELTA, N, Change);
        %Calculate the observation matrix Nij(number of occurence of each state) for non-overlapping slots of '#window' data
        estimateVector = vectorEstimation(discreteDataset,numberOfStates, window);
end

fprintf('Detection with %s dataset, %s CPM, %s modality.\n',Data_type, CPM, CPM_mode);

switch lower(CPM)
    case {'mean_cpm'}
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
        
    case {'meancov_cpm'}
        %Variables initialization CPM mean,s
        CPM_type = 'full'; %'sel'
        CPM_init = round(length(estimateVector)/2) + 1;
        CPM_param = [];
        CPM_param.type = CPM_type;
        CPM_param.initPoint = CPM_init;
        %load('COMPUTED_THRESHOLDs.mat');
        % Apply CPM mean,S
        THRESHOLD = 3.16691;
        [ out_cpm, l_max, tau ] = CPM_Multi(estimateVector.', CPM_param);
        if l_max > THRESHOLD
            counter = tau;
        end
        [ meanVector, covMatrix, M , D] = shiftedDimension(estimateVector.', CPM_param);
        disp(['Change point found at: ', num2str(tau)]);
        figure, plot(out_cpm,'LineWidth',1)
        line([0 length(estimateVector)],[THRESHOLD(1) THRESHOLD(1)],'LineStyle','-.','Color', 'r')
end