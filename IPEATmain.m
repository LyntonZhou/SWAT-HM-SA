% ======================================================================= %
%  Integrated Parameter Estimation and Uncertainty Analysis Tool (IPEAT)  %
%                             Developed by                                %
%                            Haw Yen , Ph.D.                              %
%      Colorado State University / USDA-ARS / Texas A&M University        %
%                                                                         %
%                       last update 2018-02-01(Thu)                       %
% ======================================================================= %
function IPEATmain
clear all; close all; fclose all; clc;
t0 = clock;

%% Input Block fOR SWAT simulations
settings.poolsize   = 1;
[settings, rho, sigma]	= sim_settings(settings);
delete ([settings.out_path '\output.*']);
delete ([settings.out_path '\outputb.*']);

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

%% Call DDS procedure
DDS(DDSPar, ParRange, Measurement, Extra, Restart,fid_AllOutputs);
fclose(settings.fid_errOut);
fclose(settings.fid_DDSOut);
fclose(settings.fid_Constraints);
fclose(settings.fid_CF);

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