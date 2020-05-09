function [s_new] = Perturbation(stest,dUtempt,dLtempt,Para_Perturb)

%% DDS perturbation parameter
k6 = Para_Perturb;

%% Method 1:
% Standard Gaussian random number baed upon Numerical recipes gasdev and 
% Marsaglia-Bray Algorithm
k3 = 2.0;
while k3 >= 1.0 || k3 == 0.0            
    k7 = rand;
    k8 = rand;
    k1 = 2.0 * k7 - 1.0;
    k2 = 2.0 * k8 - 1.0;            
    k3 = k1 * k1 + k2 * k2;            
end
k3 = (-2.0 * log(k3)/k3)^0.5;
k4 = rand;
if k4 < 0.5
    k5 = k1 * k3;
else
    k5 = k2 * k3;                
end
%keyboard
s_new = stest + k6 * (dUtempt-dLtempt) * k5 ; 

%%  Generate normally distributed random number by MATLAB function
% s_new = stest + k6 * (dUtempt-dLtempt) * normrnd(0,1) ;
%keyboard

%% Check if s_new is overshooting the feasible bound
if s_new > dUtempt             % Upper bound management
    s_new = dUtempt - (s_new-dUtempt);
    if s_new < dLtempt
        s_new = dUtempt;
    end
elseif s_new < dLtempt         % Lower bound management
    s_new = dLtempt + (dLtempt-s_new);
    if s_new > dUtempt
        s_new = dLtempt;
    end
end