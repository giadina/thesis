clear;
close all;

% Parameters
p = 20; % Number of dimensions
N = 200;
m = 5;
DO_CHANGE = 0;
DO_DEBUG = 0;
NEXP = 20;
CPM_type = 'full'; % full, 'sel'
CPM_init = round(N/2) + 1;
CPM_param = [];
CPM_param.type = CPM_type;
CPM_param.initPoint = CPM_init;

% Generate mu and S
mu = randn(p,1);
mu_delta = randn(p,1);

while (1)
    S = abs(randn(p,p));
    S = S * S';
    
    if DO_CHANGE
        mu_delta = randn(p,1);
        S_delta = abs(randn(p,p));
        S_delta = S_delta * S_delta';
    else
        mu_delta = mu;
        mu_delta(1) = mu_delta(1) + 1;
        S_delta = S;
    end
    
    if (sum(eig(S)>=0)==p && sum(eig(S_delta)>=0)==p )
        break
    end
end

mu;
S;
res_likelihood = [];

for N = 10:10:500
    for nexp = 1:NEXP
        
        %Initialize the dataset
        X = [];
        
        while (1)
            % Generate Random Variables
            X = [X; mvnrnd(mu,S,1)];
            
            % Explore the
            out_cpm = CPM_Multi( X, CPM_param );
        end
        
        out_cpm = CPM_Multi( X, CPM_param );
        res_likelihood = [res_likelihood; out_cpm];
        
        %figure, plot(out_cpm*2/(p*(p+3)))
    end
end

figure, plot(mean(res_likelihood));
figure, plot(mean(res_likelihood)/(p*(p+3)/2));
