%% This script computes error statistics for calibration
function Stats = statistics(obs_select, sim_select, Extra, Measurement, out_n,Sim_n)
Outvar          = Extra.settings.OutVars(out_n);
IPRINT          = Extra.settings.timesteps(out_n);
out_data_path   = Extra.settings.outPool{1};
rho             = Measurement{out_n}.rho;
sigma           = Measurement{out_n}.Sigma;
Transformation  = Extra.settings.Transformation(out_n);
if ~isempty(Extra.settings.TransParameters)
    TransParameters = Extra.settings.TransParameters(out_n);
else
    TransParameters = [];
end
TransType       = Extra.settings.TransType(out_n);

%% Measurement Uncertainty Calculation (Probability Distribution)
if Extra.settings.IndexMU == 2
    SelectDataLength = length(obs_select);
    [CF,CF_RE] = Correction_Factor(out_n,SelectDataLength,obs_select,sim_select,Extra);    
else
    CF = 0;
    CF_RE = 0;
end
CorrectionF = [CF',CF_RE];
% Save Outputs
fprintf(Extra.settings.fid_CF, '%s%s\r\n', sprintf('%-7.0f', Sim_n),sprintf('%10.3g', CorrectionF));

data_diff   = obs_select - sim_select;
log_data_diff = log(obs_select) - log(sim_select);

%% Compute error statistics
% Compute baseflow ratio difference 
if Outvar == 0
    if IPRINT == 1
        Stats.BFR = bflow(obs_select,sim_select,out_data_path);
        if isempty(Stats.BFR); Stats.BFR = 999.99; end
    else
        Stats.BFR = 999.99;
    end
    Stats.RE    = 999.99;
    Stats.BIAS  = 999.99;
    Stats.SSE   = 999.99;
    Stats.RMSE  = 999.99;
    Stats.R2    = 999.99;
    Stats.NS    = 999.99;
else
    Stats.BFR = 999.99;
    % Compute percent difference
    Stats.RE    = (mean(obs_select) - mean(sim_select))/mean(obs_select)*100;
    % Compute Bias term
    Stats.BIAS  = sum(data_diff)/length(obs_select);
    % Compute Global Optimization Criterion (GOC; van Griensven et al., WRR 2003)for outlet m
    Stats.SSE   = sum(data_diff .^ 2);
    Stats.RMSE  = sqrt(Stats.SSE/length(obs_select));
    % Compute correlation coefficient
    if Stats.RE==100
        Stats.R2=0;
    else
        corr1=corrcoef(sim_select,obs_select);
        Stats.R2=corr1(1,2);
    end
    % Compute Nash Sutcliff coefficient
    obs_mean=mean(obs_select);
    error_sq=(data_diff).^2;
    Stats.NS=1 - sum(error_sq) / sum((obs_select-obs_mean).^2);
    
    %% Transform data if needed
    if Transformation > 1
        if ~isempty(obs_select)
            if TransType == 1
                Transformed_data = apply_Transformation(obs_select, sim_select, Transformation, TransParameters, TransType);
                obs_select      = Transformed_data(:,1);
                sim_select      = Transformed_data(:,2);
            else
%                 data_diff       = apply_Transformation(obs_select, sim_select, method, parameters);
            end
        end
    end
    
    Stats.LikelihoodFcn = LikelihoodF(sim_select, obs_select, rho, sigma);
    
    % compute F_LF (for low flow)
    Stats.FLF = sqrt((mean(log_data_diff))^2);
    
    % compute KGE (Kling-Gupta)
    alpha = var(sim_select) /var(obs_select);
    beta  = mean(sim_select)/mean(obs_select);
    r     = corr(obs_select, sim_select, 'type', 'pearson');
    Stats.KGE = 1-sqrt((r-1)^2 + (alpha-1)^2 + (beta-1)^2);
    
    % compute HRMS (for high flows)
    Stats.HRMS = sqrt((mean(data_diff))^2);
end

return


function OF = LikelihoodF(sim_select, obs_select, rho, sigma)
if isempty(rho), rho = 1; end
Err     = obs_select - sim_select;
Err_2   = Err(2:end) - rho * Err(1:end-1);
N       = length(Err);

% Now compute the log-likelihood
OF      = - N * log(2*pi) ...
          - (N/2) * log(sigma^2 / (1-rho^2)) ...
          - (1/2) * (1-rho^2) * (Err(1) / sigma)^2 ...
          - (1/2) * sum((Err_2 / sigma).^2);

return