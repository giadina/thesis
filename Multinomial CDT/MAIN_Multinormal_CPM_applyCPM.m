clear;
close all;

% Parameters
p = 30; % Number of dimensions
N = 150;
m = 5;
DO_CHANGE = 0;
DO_DEBUG = 0;
NEXP = 500;
ALPHA_VECTOR = [0.1 0.05 0.01];
CPM_type = 'full'; % full, 'sel'
CPM_init = round(N/2) + 1;

%rng('default')

% Generate mu and S
mu = randn(p,1);
S = abs(randn(p,p));
S = S * S';

FILENAME = sprintf('t_p%d_N%d.txt',p,N);
FID = fopen(FILENAME,'w');

CPM_param = [];
CPM_param.type = CPM_type;
CPM_param.initPoint = CPM_init;

mu;
S;
res_likelihood = [];
max_value_vector = [];
max_index_vector = [];
load('COMPUTED_THRESHOLDs.mat');

for nexp = 1:1
    
    mu = randn(p,1);
    
    S = abs(randn(p,p));
    S = S * S';
    
    % Generate Random Variables
    X = [mvnrnd(mu,S,N/2); mvnrnd(mu,S,N/2)];
    
    [ out_cpm, l_max, tau ] = CPM_Multi( X, CPM_param );
    
    for i = 1:3        
        if l_max > THRESHOLD(i)
            counter(i,nexp) = 1;
            
        else
            counter(i,nexp) = 0;
        end
    end
    
    if mod(nexp,100)==0
        nexp;
        for i = 1 : 3
            fprintf ('Expected %f, Measured %f\n', ALPHA_VECTOR(i), sum(counter(i,:))/nexp);
        end
    end
end

for i = 1 : 3
    fprintf ('Expected %f, Measured %f\n', ALPHA_VECTOR(i), sum(counter(i,:))/NEXP);
end
