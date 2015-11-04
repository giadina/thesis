clear;
close all;

% Parameters
p1 = [1/3 1/3 1/3];
DELTA = 0.1;
p2 = [1/3-DELTA 1/3+DELTA 1/3];
N = 10000;
TS = 100;
W = 100;
K = length(p1);

% Create the distribution
pd1 = makedist('Multinomial','probabilities',p1);
pd2 = makedist('Multinomial','probabilities',p2);

% Generate the dataset
%rng('default');  % for reproducibility
r = [random(pd1,N,1); random(pd2,N,1)];

% CUSUM
estimated_param = [];
for t = W + 1 : W: length(r)
    vett = r (t - W : t);
    A = hist(vett,1:K);
    y(t) = mnpdf(A,p1);
    estimated_param = [estimated_param; A];
end

