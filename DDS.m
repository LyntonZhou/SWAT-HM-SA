function DDS(DDSPar,ParRange,Measurement,Extra,RestartMechanism,fid_AllOutputs)
disp('% ======================================================================= %');
disp('%  Integrated Parameter Estimation and Uncertainty Analysis Tool (IPEAT)  %');
disp('%                             Developed by                                %');
disp('%                            Haw Yen , Ph.D.                              %');
disp('%      Colorado State University / USDA-ARS / Texas A&M University        %');
disp('%                                                                         %');
disp('%                       last update 2018-02-01(Thu)                       %');
disp('% ======================================================================= %');

% Allocate the size of all active matrices
P = zeros(1,DDSPar.ndraw);

Ini_runs = ceil(0.005 * DDSPar.ndraw);   % Initial model runs for DDS proceParRange.maxnre
Tol_runs = DDSPar.ndraw - Ini_runs;      % Actual total model runs of DDS loop
% stest = zeros();                       % Matrix allocation of proposed para set

%% I. Initial Settings
%  Case 1: RestartMechanism = 0  &  Extra.UseInitial = 0
%  Case 2: RestartMechanism = 0  &  Extra.UseInitial = 1
%  Case 3: RestartMechanism = 1  &  Extra.UseInitial = 0
%  Case 4: RestartMechanism = 1  &  Extra.UseInitial = 1
if isequal(lower(RestartMechanism), 'no')
    if isequal(lower(Extra.UseInitial), 'no') % Case 1
        for j=1:Ini_runs
            stest = generateRandom(ParRange);
            if Extra.settings.IndexIU == 1
                pcp_update(stest,Extra);
            end                
            Ftest = CompDensity(stest, Measurement, Extra, j,fid_AllOutputs);
            % display
            ICALL = j;                       
            if j == 1
                sbest = stest;           % Current best para set
                Fbest = Ftest;           % Current best objective value
            elseif j >= 1
                if Ftest <= Fbest
                    sbest = stest;
                    Fbest = Ftest;
                end
            end    
            Display_results(DDSPar,ICALL,Ftest,'.r',Fbest)         
        end
    elseif isequal(lower(Extra.UseInitial), 'yes')  % Case 2
        sbest = Extra.Parlist.x0(Extra.Parlist.par_f==1)';
        ICALL = 1;
        if Extra.settings.IndexIU == 1
            pcp_update(sbest,Extra);
        end        
        Fbest = CompDensity(sbest, Measurement, Extra, ICALL,fid_AllOutputs);
        OF = Fbest;
        Display_results(DDSPar,ICALL,OF,'.b',Fbest)
    end
elseif isequal(lower(RestartMechanism), 'yes')
    % Complete this part later
    [ExistData, CurrentModelRun, CurrentBestObj, sbest] = ...
        ExistParameterSets(Extra.settings.out_path);
    Tol_runs = DDSPar.ndraw - CurrentModelRun;
    ICALL = CurrentModelRun;
    Fbest = CurrentBestObj;
    if Extra.settings.IndexIU == 1
        pcp_update(sbest,Extra);
    end    
end

%% II. DDS Updating Procedure
swap = 0;                        % Number of para set being swapped
for i=1:Tol_runs
    if isequal(lower(RestartMechanism), 'yes')
        m = i + CurrentModelRun;  
    else
        m = i;
    end
    % Probability of decision variables being selected
    P(m) = 1 - log(m) / log(Tol_runs);
    figure(1); subplot(1,2,1)  % Plot P(i)
    plot(m,P(m),'.','MarkerSize',5); hold on;
    xlim([0,DDSPar.ndraw])
    ylim([0,1])
    xlabel('Number of Model Runs')
    ylabel('P(m)') 
    %%              Perturbation criteria 
    %               1.randomly identified in total population
    %               2.certain number of points in each DV set
    dvn_counter = 0.0; % counter of how many DV seleceted for perturbation
    stest = sbest;
    for j=1:sum(Extra.Parlist.par_f)  
        RandomV = rand;
        if RandomV < P(m)
            ParRange.maxntempt = ParRange.maxn(j);
            ParRange.minntempt = ParRange.minn(j);
            s_tempt = stest(j);
            [s_new] = Perturbation(s_tempt,ParRange.maxntempt,ParRange.minntempt,DDSPar.PertSize);
            stest(j) = s_new;
        end
    end

    if dvn_counter == 0.0 % When P(i) is low, perturb at least one DV
        RI = randi(sum(Extra.Parlist.par_f)); % One random index of DV
        ParRange.maxntempt = ParRange.maxn(RI);
        ParRange.minntempt = ParRange.minn(RI); 
        s_tempt = stest(RI);
        [s_new] = Perturbation(s_tempt,ParRange.maxntempt,ParRange.minntempt,DDSPar.PertSize);
        stest(RI) = s_new;
    end
    
    ICALL = ICALL + 1;
    if Extra.settings.IndexIU == 1
        pcp_update(stest,Extra);
    end    
    Ftest = CompDensity(stest, Measurement, Extra, ICALL,fid_AllOutputs);
    if Ftest <= Fbest
        sbest = stest;
        Fbest = Ftest;
        swap = swap + 1;
        BestRun = i+1;
    end

    % Current_s_best = sbest  %Current best para set
    Current_v_best = Fbest;   %Current best objective value
    Display_results(DDSPar,ICALL,Ftest, '.r',Current_v_best)
end    
disp('==========================================================')
disp(['Best IPEAT Simulation# = ' sprintf('%i',BestRun)])    
disp(['Best Objective Function = ' , num2str(Current_v_best)])          
disp('==========================================================')          

function randnum = generateRandom(ParRange)
nNum = numel(ParRange.minn);
randnum = ParRange.minn + rand(1,nNum) .* (ParRange.maxn - ParRange.minn);

return


function Display_results(DDSPar,ICALL,OF, colorCode,Current_v_best)
% DDS_out = [num2str(ICALL) sprintf('%15.5f',[current_x OF])];
disp(['IPEAT Simulation# = ' sprintf('%i',ICALL) '   &&   Objective Function = ' , num2str(OF)])    
% fprintf(Extra.settings.fid_DDSOut,'%s\n', DDS_out);
figure(1)
subplot(1,2,2)          % Plot of the best objective value
plot(ICALL, Current_v_best, colorCode,'MarkerSize', 5); hold on;
xlim([0, DDSPar.ndraw])
xlabel('Number of Model Runs')
ylabel('f')

return
