% ======================================================================= %
%  Integrated Parameter Estimation and Uncertainty Analysis Tool (IPEAT)  %
%                             Developed by                                %
%                            Haw Yen , Ph.D.                              %
%      Colorado State University / USDA-ARS / Texas A&M University        %
%                                                                         %
%                       last update 2018-02-01(Thu)                       %
% ======================================================================= %
function IPEATmain1

addpath(genpath('F:\SWAT-HM\SWAT-HMV1.1\SensitivityAnalysis'))
clear; close all; fclose all; clc;
t0 = clock;

%% Input Block for SWAT simulations
settings.poolsize   = 2;
[settings, rho, sigma]	= sim_settings(settings);
% rmdir(settings.out_path,'s');
% mkdir(settings.out_path);

% if exist([settings.out_path '\temp*'], 'dir')
%     rmdir ([settings.out_path '\temp*'],'s');
% end
% if exist([settings.out_path '\pool*'], 'dir')
%     rmdir ([settings.out_path '\pool*'],'s');
% end
% delete ([settings.out_path '\output.*']);
% delete ([settings.out_path '\outputb.*']);

if size(unique(settings.timesteps),2) > 1
    settings.IPRINT = 1;
else
    settings.IPRINT = unique(settings.timesteps);
end
[DDSPar, Extra, Restart] = loadDDSSetting;
fid_AllOutputs = zeros();
[settings,fid_AllOutputs] = copySWATfolder(settings, Restart,fid_AllOutputs);

%%
settings.file_id = id_func(settings.n_sub, settings.outTemp{1});
% streamorder([settings.TxtInOut_path '\fig.fig']);

% [~, Symbol, ~, ~, x0, par_f, lb, ub]
Parlist = readParfile(settings.user_inputs_path);
parameter_location = find(Parlist.par_f==1);

%% Define the measured data
Measurement = load_measurements(settings, rho, sigma);

if isempty(rho)
    settings.getRhoFromX = 1;
    L = length(settings.outlets);
    ParRange.minn = [Parlist.lb(parameter_location)', .10*ones(1,L)];
    ParRange.maxn = [Parlist.ub(parameter_location)', .99*ones(1,L)];
else
    settings.getRhoFromX = 0;
    ParRange.minn = Parlist.lb(parameter_location)';
    ParRange.maxn = Parlist.ub(parameter_location)';
end

Extra.Parlist	= Parlist;
Extra.settings  = settings;
% save settings Parlist
save Extra Extra;

%% Lingfeng Zhou
% Perform VBSA sampling
% Define input distribution and ranges:
nNum = numel(ParRange.minn); % number of uncertain parameters
DistrFun  = 'unif'  ; % Parameter distribution
DistrPar  = mat2cell(transpose(cell2mat(struct2cell(ParRange))),ones(1,nNum)); % Parameter ranges

% Sample parameter space using the resampling strategy proposed by 
% (Saltelli, 2008; for reference and more details, see help of functions
% vbsa_resampling and vbsa_indices) 
SampStrategy = 'lhs' ;
N = 2000 ; % Base sample size.
% Comment: the base sample size N is not the actual number of input 
% samples that will be evaluated. In fact, because of the resampling
% strategy, the total number of model evaluations to compute the two
% variance-based indices is equal to N*(M+2) 
X = AAT_sampling(SampStrategy,nNum,DistrFun,DistrPar,2*N);
[ XA, XB, XC ] = vbsa_resampling(X);
%  total input sampling
XT = [XA; XB; XC];
save XT XT

% auto-create SA_run_SWATHM_X.m file 
delete ('SA_run_SWATHM_*');
noDist = settings.poolsize;
for ifile = 1:noDist
    iSim_S = (ifile-1)*ceil(N*(nNum+2)/noDist)+1;
    iSim_E = ifile*ceil(N*(nNum+2)/noDist);
    if ifile==noDist; iSim_E=N*(nNum+2); end
    file_run = ['SA_run_SWATHM_' num2str(ifile) '.m'];
    fid = fopen(file_run,'w');
    fprintf(fid,'%%%% Parallel Computing \n');
    fprintf(fid,'clear; close all; fclose all; clc; \n');
    fprintf(fid,'load XT \n');
    fprintf(fid,'load Extra \n');
    fprintf(fid,'tic \n');
    fprintf(fid,'ifile = %i; \n',ifile);
    fprintf(fid,'for iSim=%i:%i \n',iSim_S,iSim_E);
    fprintf(fid,'   x_new = XT(iSim,:); \n');
    fprintf(fid,'   fprintf(''========= SWAT-HM Simulation #: %%i =========\\n'', iSim); \n');
    fprintf(fid,'   fprintf([datestr(now) ''\\n'']); \n');
    fprintf(fid,'   eval([''[ModPred_'' num2str(iSim) '', n_DayinMonth, n_DayinYear, Constr_val, penalize] = swatmodel1(ifile, x_new, Extra);'']); \n');
    % save([Extra.settings.out_path '\ModPred_' num2str(iSim)],['ModPred_' num2str(iSim)])
    % eval(['save(' '''' Extra.settings.out_path '\ModPred_' num2str(iSim) '''' ',' '''' 'ModPred_' num2str(iSim) '''' ');']);
%     fprintf(fid,'   eval([''save ModPred_'' num2str(iSim) '' ModPred_'' num2str(iSim) '';'']); \n');
    fprintf(fid,'   eval([''save('' '''''''' Extra.settings.out_path ''\\ModPred_'' num2str(iSim) '''''''' '','' '''''''' ''ModPred_'' num2str(iSim) '''''''' '');'']); \n');
    fprintf(fid,'   eval([''clear ModPred_'' num2str(iSim) '';'']); \n');
    fprintf(fid,'end \n');
    fprintf(fid,'toc \n');
    fclose(fid);
end

fclose(settings.fid_errOut);
fclose(settings.fid_DDSOut);
fclose(settings.fid_Constraints);
fclose(settings.fid_CF);
% % Compute main (first-order) and total effects:
% [ Si, STi ] = vbsa_indices(YA,YB,YC);


%% Call DDS procedure
% DDS(DDSPar, ParRange, Measurement, Extra, Restart,fid_AllOutputs);


%% Compute CPU runtime
runtime1=fix(etime(clock,t0)/60);
runtime2=round((etime(clock,t0)/60-fix(etime(clock,t0)/60))*60);
disp(['runtime: ' num2str(runtime1) ' min     ' num2str(runtime2) ' sec'])

return


function [settings,fid_AllOutputs] = copySWATfolder(settings, Restart,fid_AllOutputs)
TxtInOut_path       = settings.TxtInOut_path;
user_inputs_path    = settings.user_inputs_path;
out_path            = settings.out_path;
poolsize            = settings.poolsize;
IPRINT              = settings.IPRINT;
simdate             = settings.simdate;
n_warmup            = settings.n_warmup;

%% Project Setup
out_id    = [0  ,1 ,1  ,1   ,1   ,1   ,1   ,1   ,1   ,1     ,1     ,0 ,0 ,0];
           % bfr,sf,sed,orgn,orgp,no3n,nh4n,no2n,minp,solpst,sorpst,tp,tn,tpst

ICALIB    = [0, 0, 0];
            % set all to zero to get the loads: Sediment (ton), P & N (kg), Pesticide (mg) 

swat_directory  = '..\02ControlFiles';
bflow_directory  = '..\04Baseflow';

if ~exist(out_path, 'dir')
    mkdir(out_path);
end

for i=1:poolsize
    outTemp{i} = [out_path '\temp' num2str(i)]; %#ok<AGROW>
    copyfile(TxtInOut_path, outTemp{i});
    copyfile(user_inputs_path, outTemp{i});
    copyfile(swat_directory, outTemp{i});
    copyfile(bflow_directory, outTemp{i});
    
    outPool{i} = [out_path '\pool' num2str(i)]; %#ok<AGROW>
    copyfile(outTemp{i}, outPool{i});

    n_sub = proj_setup(outPool{i}, out_id, ICALIB, IPRINT, simdate, n_warmup);
end

out_dates = proj_dates(outTemp{i});

ErrorOut_fname      = [out_path '\IPEAT_Stats.txt'];
DDSOut_fname        = [out_path '\IPEAT_ParaOBJ.txt'];
Constraints_fname   = [out_path '\Constraints.txt'];
CF_fname            = [out_path '\CorrectionFactor.txt'];

if isequal(lower(Restart), 'no')
    fid_errOut      = fopen(ErrorOut_fname, 'w');
    fprintf(fid_errOut, '%s\r\n', 'Serial# Station  Vars       PBIAS(%)    NSE       R2        RMSE      SSE       LikeH');
    fid_DDSOut      = fopen(DDSOut_fname, 'w');
    fid_Constraints = fopen(Constraints_fname, 'w');
    fprintf(fid_Constraints, '%s\r\n', 'Serial# DENITRIFICATION NO3_LEACHED P_LEACHED    SSQ/(SSQ+SQ)   SSQ_NO3      SQ_NO3');
    for i=1:size(settings.outlets,2)    
        fname = [settings.out_path '\SimOut' num2str(settings.outlets(i)) 'Var' num2str(settings.OutVars(i)) 'Tstep' num2str(settings.timesteps(i)) '.txt'];
        fid_AllOutputs(i) = fopen(fname, 'w');
    end
    fid_CF = fopen(CF_fname, 'w');    
    fprintf(fid_CF, '%s\r\n', 'Serial# CorrectionF1 Correction2');    
else
    fid_errOut      = read_exist_data(ErrorOut_fname);
    fid_DDSOut      = read_exist_data(DDSOut_fname);
    fid_Constraints = read_exist_data(Constraints_fname);
    for i=1:size(settings.outlets,2)
        fname = [settings.out_path '\SimOut' num2str(settings.outlets(i)) 'Var' num2str(settings.OutVars(i)) 'Tstep' num2str(settings.timesteps(i)) '.txt'];        
        fid_AllOutputs(i) = read_exist_data(fname);
    end  
    fid_CF          = read_exist_data(CF_fname);    
end

settings.outTemp     = outTemp;
settings.outPool     = outPool;
settings.n_sub       = n_sub;
settings.out_dates   = out_dates;
settings.out_id      = out_id;
settings.fid_errOut  = fid_errOut;
settings.fid_DDSOut  = fid_DDSOut;
settings.fid_Constraints = fid_Constraints;
settings.fid_CF      = fid_CF;
return


function Parlist = readParfile(user_inputs_path)
parFilename = [user_inputs_path '\IPEAT_Para.set'];

[Parlist.par_n,...
 Parlist.Symbol,...
 Parlist.Input_File,...
 Parlist.units,...
 Parlist.x0,...
 Parlist.par_f,...
 Parlist.lb,...
 Parlist.ub] = ...
            textread(parFilename,'%n%s%s%s%n%n%n%n','headerlines',2); %#ok<REMFF1>
Parlist.parameter_location = find(Parlist.par_f==1);

return


function fid_w = read_exist_data(Fname)
copyfile(Fname, 'temp.txt');

fid_w = fopen(Fname, 'w');
old_fid = fopen('temp.txt', 'r');
L = 0;
while feof(old_fid) == 0
    L = L+1;
    line = fgets(old_fid);
    if ~isempty(strtrim(line))
        fprintf(fid_w,'%s', line);
    end
end

fclose(old_fid);
delete('temp.txt');
return