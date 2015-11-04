close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Multinomial CDT/')
addpath('Datasets/')

CPM_mode = 'max_t'; %'out_cpm'
numberOfStates = 2;
[finalDataset] = discreteDataset(numberOfStates);

switch lower(CPM_mode)
    case {'max_t'}
        
        %Variables initialization CPM mean
        window = 100;
        h = 13.932;
        % Apply CPM mean
        [ hotellingT, maxT, idx, tChange ] = applyCPMmean(h,numberOfStates,window,finalDataset );
        figure, plot(maxT)
        line([0 100],[h h],'LineWidth',2,'Color', 'b')
        
    case {'out_cpm'}
        
        %Variables initialization CPM mean,s
        CPM_type = 'full'; % full, 'sel'
        CPM_init = round(length(finalDataset)/2) + 1;
        CPM_param = [];
        CPM_param.type = CPM_type;
        CPM_param.initPoint = CPM_init;
        load('COMPUTED_THRESHOLDs.mat');
        % Apply CPM mean,S
        [ out_cpm, l_max, tau ] = CPM_Multi( finalDataset, CPM_param );
        if l_max > THRESHOLD(1)
            counter = tau;
        end
        figure, plot(out_cpm)
        line([0 length(finalDataset)],[THRESHOLD(1) THRESHOLD(1)],'LineWidth',2,'Color', 'b')
end