%% Parallel Computing 
load XT 
load Extra 
tic 
ifile = 1; 
for iSim=1:400 
   x_new = XT(iSim,:); 
   fprintf('========= SWAT-HM Simulation #: %i =========\n', iSim); 
   eval(['[ModPred_' num2str(iSim) ', n_DayinMonth, n_DayinYear, Constr_val, penalize] = swatmodel1(ifile, x_new, Extra);']); 
   eval(['save ModPred_' num2str(iSim) ' ModPred_' num2str(iSim) ';']); 
   eval(['clear ModPred_' num2str(iSim) ';']); 
end 
toc 
