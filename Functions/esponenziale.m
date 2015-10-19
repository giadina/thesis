function [exp] = esponenziale(media,m,n)

if nargin < 1
    error('ci deve essere almeno un argomento');
end

mean(media < 0) = NaN;

if nargin == 1
    exp = -media .* log(rand(size(media)));
else
    if nargin == 2
        u = rand(m);
    elseif nargin == 3
        u = rand(m,n);
    end
exp = -media .* log(u);
end

end

