clear;
close all;

% Parameters
ALPHA_VECTOR = [0.1 0.05 0.01];
N_VECTOR = [150];
P_VECTOR = [30];
NEXP = 500;
CPM_type = 'full'; % full, 'sel'
CPM_init = round(N/2) + 1;

DO_CHANGE = 0;
DO_DEBUG = 0;
DO_EMAIL = 0;


% MAIN
fprintf('--- COMPUTING THRESHOLDS for CPM ---\n')

CPM_param = [];
CPM_param.type = CPM_type;
CPM_param.initPoint = CPM_init;

for p = P_VECTOR
    for N = N_VECTOR
        
        res_likelihood = [];
        
        fprintf('p=%d N=%d NEXP=%d\n:::\n',p,N,NEXP);
        
        %
        FILENAME = sprintf('t_p%d_N%d.txt',p,N);
        FID = fopen(FILENAME,'w');
        for i =1: length(ALPHA_VECTOR)
            fprintf(FID,'%s ', ALPHA_VECTOR(i));
        end
        fprintf(FID,'\n');
        
        for nexp = 1:NEXP
            
            mu = randn(p,1);
            
            S = abs(randn(p,p));
            S = S * S';
            
            % Generate Random Variables
            X = [mvnrnd(mu,S,N)];
            %figure, plot(X(:,1),X(:,2),'+')
            %axis equal
            if DO_DEBUG
                % Parameter Estimation L1
                mu_est_m1 = mean(X(1:m,:))';
                S_est_m1 = cov(X(1:m,:));
                
                % Compute Likelihood function
                for i = 1:N
                    l(i) = - p * log(2*pi) - log( det(S)) - (X(i,:)' - mu)'*inv(S)*(X(i,:)' - mu);
                end
                
                % Compute Likelihood function
                for i = 1:m
                    l_m(i) = - p * log(2*pi) - log(det(S_est_m1)) - (X(i,:)' - mu_est_m1)'*inv(S_est_m1)*(X(i,:)' - mu_est_m1);
                end
                
                max_l_m = sum(l_m(1:m));
                l1= -m * p * log(2*pi) - m * log (det(S_est_m1)) - m * p;
                
                % Parameter Estimation L2
                mu_est_m2 = mean(X(m+1:N,:))';
                S_est_m2 = cov(X(m+1:N,:));
                l2 =-(N-(m+1)+1) * p * log(2*pi) - (N-(m+1)+1)* log (det(S_est_m2)) - (N-(m+1)+1) * p;
                
                % Parameter Estimation L0
                mu_est_N = mean(X(1:N,:))';
                S_est_N = cov(X(1:N,:));
                l0 =-N * p * log(2*pi) - N * log (det(S_est_N)) - N * p;
                
                
                l = l1+l2-l0;
            end
            
            
            [ out_cpm, l_max, tau ] = CPM_Multi( X, CPM_param );
            res_likelihood = [res_likelihood; out_cpm];
            
            %figure, plot(out_cpm*2/(p*(p+3)))
            
            if mod(nexp,100)==0
                fprintf('curr_nexp=%d\n',nexp);
            end
            
        end
        
        figure, plot(mean(res_likelihood));
        
        
        %x = p+1:N -p - 1;
        %ev = (N-2*p-1)./((x-p).*(N-p-x));
        
        %hold on, plot(x,ev,'rd');
        %diff = zeros (size(res_likelihood));
        %for i = 1:NEXP
        %    diff(i,x) = res_likelihood(i,x) - ev;
        %end
        
        max_diff_exp = max(res_likelihood');
        
        sorted_max_diff_exp = sort(max_diff_exp);
        
        
        for i = 1 : length(ALPHA_VECTOR)
            THRESHOLD(i) = sorted_max_diff_exp(1+ceil(NEXP*(1-ALPHA_VECTOR(i))));
        end
        
        save('COMPUTED_THRESHOLDs.mat','THRESHOLD');
        
        for i = 1:length(ALPHA_VECTOR)
            fprintf(FID,'%s ', THRESHOLD(i));
        end
        
        
        
        fprintf(FID,'\np=%d N=%d NEXP=%d',p,N,NEXP);
        fclose(FID);
        
        if DO_EMAIL
            conf_mail(FILENAME, FILENAME);
        end
        
    end
    
end

fprintf('\nCompleted!\n');