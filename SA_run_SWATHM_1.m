%% Parallel Computing 
clear; close all; fclose all; clc; 
load XT 
load Extra 
tic 
ifile = 1; 
for iSim=1:28400 
   x_new = XT(iSim,:); 
   fprintf('========= SWAT-HM Simulation #: %i =========\n', iSim); 
   fprintf([datestr(now) '\n']); 
   eval(['[ModPred_' num2str(iSim) ', n_DayinMonth, n_DayinYear] = swatmodel1(ifile, x_new, Extra);']); 
   eval(['save(' '''' Extra.settings.out_path '\ModPred_' num2str(iSim) '''' ',' '''' 'ModPred_' num2str(iSim) '''' ');']); 
   eval(['clear ModPred_' num2str(iSim) ';']); 
end 
toc 
