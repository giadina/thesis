close all
clear
clc

addpath('MultinomialFunctions/')
addpath('Multinomial CDT/')
addpath('Datasets/')

%Variables intialization
CPM = 'cdt1';          %'cdt1', 'cdt2';
CPM_mode = 'online';      %'offline', 'online';
Shift_mode = 'exact';    %'exact', 'approx';
Data_type = 'gaussian';   %'gaussian', 'discrete', 'iris';

%Generate the dataset
window = 3;
confidence = 0.001;

flowers = iris_dataset;
classes = flowers(1:4,51:150);

numberOfStates = size(classes,1);
limit = floor(length(classes)/window);
estimateVector = [];

for i=window+1:window:(limit*window)+window
    vett = classes(:,i - window:i-1);
    A = mean(vett,2);
    
    estimateVector = [estimateVector A];
end

fprintf('Detection with %s dataset, %s, %s modality.\n',Data_type, CPM, CPM_mode);

switch lower(CPM)
    case {'cdt1'}
        fprintf('%s statistic.\n', Shift_mode);
        THRESHOLD = selectThreshold(numberOfStates, 33, confidence, Data_type);
        % Apply CPM mean
        [hotellingT, maxT, idx, tChange, sampleReference] = applyCPMmean(THRESHOLD,estimateVector,Shift_mode,CPM_mode);
        disp(['Change point found at: ', num2str(tChange)]);
        switch lower(CPM_mode)
            case {'online'}
                figure, plot(maxT,'LineWidth',1)
%                 y1=get(gca,'ylim');
%                 hold on
%                 plot([sampleReference sampleReference],y1)
%                 plot([tChange tChange],y1)
                line([0 length(maxT)],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
                legend('CPM online', 'threshold')
                hold off
            case {'offline'}
                figure, plot(hotellingT,'LineWidth',1)
                line([0 length(hotellingT)],[THRESHOLD THRESHOLD],'LineStyle','-.','Color','r')
                legend('CPM offline', 'threshold')
        end
        
    case {'cdt2'}
        %Variables initialization CPM mean,s
        CPM_type = 'full'; %'sel'
        CPM_init = round(length(estimateVector)/2) + 1;
        CPM_param = [];
        CPM_param.type = CPM_type;
        CPM_param.initPoint = CPM_init;
        load('COMPUTED_THRESHOLDs.mat');
        % Apply CPM mean,S
        [ out_cpm, l_max, tau ] = CPM_Multi(estimateVector.', CPM_param);
        if l_max > THRESHOLD(1)
            counter = tau;
        end
        [ meanVector, covMatrix, M , D] = shiftedDimension(estimateVector.', CPM_param);
        disp(['Change point found at: ', num2str(tau)]);
        figure, plot(out_cpm,'LineWidth',1)
        line([0 length(estimateVector)],[THRESHOLD(1) THRESHOLD(1)],'LineStyle','-.','Color', 'r')
end