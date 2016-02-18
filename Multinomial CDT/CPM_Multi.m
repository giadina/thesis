function [ l, l_max, tau ] = CPM_Multi( X, param )
%CPM_MULTI Summary of this function goes here
%   Detailed explanation goes here

[N, p]=size(X);

l = zeros (1,N);

switch lower(param.type)
    case {'full'}
        init_point = p + 1;
    case {'sel'}
        init_point = CPM_param.initPoint;
end
        

for m = init_point : N-p-1
    
    % Analysis 1:m
    S_est_m1 = cov(X(1:m,:));
    %if (rank(S_est_m1) == p)
    %    l1(m)= -m * p * log(2*pi) - m * log (det(S_est_m1)) - m * p;
    %else
        eig_computed = eig(S_est_m1);
        eig_computed = sort(eig_computed,'descend');
        det_approx = prod(eig_computed(1:rank(S_est_m1)));
        l1(m)= -m * rank(S_est_m1) * log(2*pi) - m * log (det_approx) - m * rank(S_est_m1);
    %end
    
    det_1 (m) = log (det_approx);
    
    % Analysis m+1:N
    S_est_m2 = cov(X(m+1:N,:));
    %if (rank(S_est_m2) == p)
    %    l2(m)= - (N-(m+1)+1) * p * log(2*pi) - (N-(m+1)+1) * log (det(S_est_m2)) - (N-(m+1)+1) * p;
    %else
        eig_computed = eig(S_est_m2);
        eig_computed = sort(eig_computed,'descend');
        det_approx = prod(eig_computed(1:rank(S_est_m2)));
        l2(m)= -(N-(m+1)+1) * rank(S_est_m2) * log(2*pi) - (N-(m+1)+1) * log (det_approx) - (N-(m+1)+1) * rank(S_est_m2);
    %end
    
    det_2 (m) = log (det_approx);
    
    % Parameter Estimation L0
    mu_est_N = mean(X(1:N,:))';
    S_est_N = cov(X(1:N,:));
    l0(m) =-N * p * log(2*pi) - N * log (det(S_est_N)) - N * p;
    
    det_0 (m) = log(det(S_est_N));
    
    l(m) = l1(m)+l2(m)-l0(m);
    
end

% Correction of the expected value
x = init_point:N -p - 1;
ev = (N-2*p-1)./((x-p).*(N-p-x));

l = l*2/(p*(p+3));


% C
l(x) = l(x) - ev; 
[l_max,tau] = max(l);

end

