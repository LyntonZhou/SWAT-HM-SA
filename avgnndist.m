function d = avgnndist(x)
% this function calculates the average nearest-neighbor
% distance for the row vectors in matrix x198
%
m = size(x,1);
dsum = 0;
for i = 1:m
xir = x(i,:); xi = repmat(xir,m,1);
dif2 = (xi-x).^2; di = sum(dif2');
dis = sort(sqrt(di));
% smallest distance should be zero (from xir to itself)
% (this is the nearest-neighbor distance)
dsum = dsum + dis(2);
end
% average nearest-neighbor distance
d = dsum/m;
return;