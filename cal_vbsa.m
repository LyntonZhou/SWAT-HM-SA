% calculate variance-based sensitivity indices

addpath(genpath('F:\SWAT-HM\SWAT-HMV1.1\SensitivityAnalysis'))
clc
clear 
load XT 
load Extra

N = 500 ; % Base sample size
nNum = numel(Extra.Parlist.parameter_location); % number of test parameters

iRchNo = 6;
YT = zeros(N*(nNum+2),(Extra.settings.Sim_L-Extra.settings.Sim_F+1));
for iSim=1:N*(nNum+2) 
    iSim
%     filename = [Extra.settings.out_path '\ModPred_' num2str(iSim) ];
    filename = ['F:\SWAT-HM\SWAT-HMV1.1\IPEAT\01MATLAB\ModPred_' num2str(iSim)];
    load(filename);
    eval(['temp = ModPred_' num2str(iSim) ';']);
    YT(iSim,:) = temp(temp(:,1)==1,5)';
    eval(['clear ModPred_' num2str(iSim)]); 
end

%% 
YA = mean(YT(1:N,:),2);
YB = mean(YT((N+1):2*N,:),2);
YC = mean(YT((2*N+1):end,:),2);

% YA = YT(1:N,366);
% YB = YT((N+1):2*N,366);
% YC = YT((2*N+1):end,366);
% Compute main (first-order) and total effects:
[ Si, STi ] = vbsa_indices(YA,YB,YC);

% Plot results:
X_Labels = cell(1,nNum);
for ii=1:nNum
    X_Labels(ii) = Extra.Parlist.Symbol(Extra.Parlist.parameter_location(ii));
end
% X_Labels = {'Sm','beta','alfa','Rs','Rf'} ;
figure % plot main and total separately
subplot(121); boxplot1(Si,X_Labels,'main effects')
subplot(122); boxplot1(STi,X_Labels,'total effects')
figure % plot both in one plot:
boxplot2([Si; STi],X_Labels)
legend('main effects','total effects')% add legend
