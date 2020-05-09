function d = pnndist(x,p)
% this function calculates the distance from p to its
% nearest neighbor in matrix x (p is a row vector)
m = size(x,1); 
xp = repmat(p,m,1);
dif2 = (x-xp).^2;
dp = sum(dif2,2);
d = min(sqrt(dp)); 
return,