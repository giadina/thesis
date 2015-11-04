clear;
close all;

% Parameters
ALPHA_VECTOR = [0.1 0.05 0.01];
N_VECTOR = [150];
P_VECTOR = [30];
NEXP = 30;
CPM_type = 'full'; % full, 'sel'
CPM_init = round(N_VECTOR/2) + 1;

DO_CHANGE = 0;
DO_DEBUG = 0;
DO_EMAIL = 0;


% MAIN
fprintf('--- COMPUTING ARL for CDT ---\n')

load('COMPUTED_THRESHOLDs.mat');

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
            
            FLAG = ones(3,1);
            while (sum(FLAG) > 0)
                
                [ out_cpm, l_max, tau ] = CPM_Multi( X, CPM_param );
                
                for i = 1:3
                    if (l_max > THRESHOLD(i)) && (FLAG(i) == 1)                        
                        detection(i,nexp) = length(X);
                        FLAG(i) = 0;
                    end
                end
                
                X = [X; mvnrnd(mu,S,1)];                                
            end
            
                                  
            %figure, plot(out_cpm*2/(p*(p+3)))
            
            if mod(nexp,5)==0
                fprintf('curr_nexp=%d\n',nexp);
            end
            
        end
        

        ARL_0 = mean(detection,2);
        
        
        fprintf(FID,'\np=%d N=%d NEXP=%d',p,N,NEXP);
        fclose(FID);
        
        if DO_EMAIL
            conf_mail(FILENAME, FILENAME);
        end
        
    end
    
end

fprintf('\nCompleted!\n');