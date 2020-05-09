function [ExistData,CurrentModelRun,CurrentBestObj,CurrentBestParaSets]...
        = ExistParameterSets(Project_directory)
 ExistData = load([Project_directory '\IPEAT_ParaOBJ.txt']);

SerialNumber = ExistData(:,1);       % Serial # of existed model runs
CurrentModelRun = max(SerialNumber); % Serial # of current model run
[sv,iv] = sort(ExistData(:,end));

% Current Best Objectvie
CurrentBestObj = sv(1);

% Current Best Parameter Sets
CurrentBestParaSets = ExistData(iv(1), 2:end-1);

figure(1)
subplot(1,2,2)          % Plot of the best objective value
plot(iv, sv, '.r', 'MarkerSize', 5); hold on;

% display
disp('----------------------------------------------------------------')    
disp(['   Restart DDS from Model Run #  = ' sprintf('%i',CurrentModelRun)])
disp(['   Latest Best Objective Function = ' num2str(CurrentBestObj)])    
disp('----------------------------------------------------------------')   

return