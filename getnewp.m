
function try1 = getnewp(x,dc)
% this function generates a new trial point p from a
% uniform distribution over x, with margins +/- dc
%
[nrow,ncol] = size(x);
% define lower bound of search domain
xmin = min(x) - dc;
% if outside feasible parameter domain
if min(xmin) < 0, xmin = min(x); end
% define upper bound of search domain
xmax = max(x) + dc;
% if outside feasible parameter domain
if max(xmax) > 1, xmax = max(x); end
% new trial point
try1 = xmin + (xmax-xmin).*rand(1,ncol);
return;