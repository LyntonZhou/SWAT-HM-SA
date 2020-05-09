function OF = CompDensity(x, Measurement, Extra, Sim_n,fid_AllOutputs)
% This function computes the density of each x value
if Extra.settings.getRhoFromX
    L = length(Extra.settings.outlets);
    for i=1:length(Measurement)
        Measurement{i}.rho = x(end-L+i);
    end
    x_new = x(1:end-L);
else
    x_new = x;
end
nOutlets = max(textread(fullfile(Extra.settings.out_path, '\pool1', 'fig.fig'), '%*s%*s%*s%*s%*s%n'));

fprintf('========= IPEAT Simulation #: %i =========\n', Sim_n);
[ModPred, n_DayinMonth, n_DayinYear, Constr_val, penalize] = swatmodel(x_new, Extra);

OF = 0;
for out_n =1:length(Extra.settings.outlets)
    [observed, simulated] = calc_ERR(out_n, Measurement, ModPred, Extra.settings, n_DayinMonth, n_DayinYear, nOutlets,fid_AllOutputs);
    if Extra.settings.IndexMU == 1
        simulated = measurement_error(out_n,observed,simulated,Extra); 
    end
    OF = CalcOF(OF, observed, simulated, Extra, Measurement, out_n, Sim_n);
end

constraints = [Sim_n Constr_val];
fprintf(Extra.settings.fid_Constraints, '%s\r\n', sprintf('%-13.4g', constraints));

if penalize
%     for out_n =1:length(Extra.settings.outlets)
        OF = 10e3;
%     end
end

% save output
newStr = [Sim_n x OF];
fprintf(Extra.settings.fid_DDSOut, '%s\r\n', sprintf('%-13.4g', newStr));

return

function [observed, simulated,settings] = calc_ERR(out_n, Measurement, out, settings, n_DayinMonth, n_DayinYear, nOutlets,fid_AllOutputs)
outlet  = settings.outlets(out_n);
OutVar  = settings.OutVars(out_n);
MeasData= Measurement{out_n}.MeasData;

Sim_F  = settings.Sim_F;
Sim_L  = settings.Sim_L;

Obs_F  = Measurement{out_n}.Obs_F;
Obs_L  = Measurement{out_n}.Obs_L;

swat_out = read_output(out, outlet, settings.IPRINT, settings.out_id, settings.ICALIB, n_DayinMonth, n_DayinYear, length(n_DayinYear), nOutlets);

%% convert to the required time-step for the current OF
if (Sim_L < Obs_F) || (Obs_L < Sim_F)
    simulated   = [];
    observed    = [];
else
    first   = max(Sim_F, Obs_F);
    last    = min(Sim_L, Obs_L);
    % Convert Data
    if settings.timesteps(out_n)==0     % Monthly
        if any(settings.timesteps~=0)
            swat_out = mytomonthly(swat_out, Sim_F, Sim_L, settings.ICALIB);
        end
        simulated   = swat_out(nMonth(Sim_F, first) + 1 : end -nMonth(last, Sim_L), OutVar);
        observed    = MeasData(nMonth(Obs_F, first) + 1 : end -nMonth(last, Obs_L), OutVar);
    elseif settings.timesteps(out_n)==2 % Yearly
        if any(settings.ICALIB~=2)
            swat_out = mytoyearly(swat_out, Sim_F, Sim_L, settings.ICALIB);
        end
        simulated   = swat_out(nYear(Sim_F, first) + 1 : end -nYear(last, Sim_L), OutVar);
        observed    = MeasData(nYear(Obs_F, first) + 1 : end -nYear(last, Obs_L), OutVar);
    else                                % Daily
        simulated   = swat_out(first - Sim_F + 1 : end -(Sim_L - last), OutVar);
        observed    = MeasData(first - Obs_F + 1 : end -(Obs_L - last), OutVar);
    end
end
NoNaN = find((observed == -99)~=1);
simulated   = simulated(NoNaN);
observed    = observed(NoNaN);

simOutputs = swat_out(:,settings.OutVars(out_n))';
fprintf(fid_AllOutputs(out_n), '%f\t', simOutputs);
fprintf(fid_AllOutputs(out_n), '\r\n');  
return

function m = Month(Date)
mydate = datevec(Date);
m = mydate(2);
return

function y = Year(Date)
mydate = datevec(Date);
y = mydate(1);
return

function nm = nMonth(startDate, endDate)
nm = (12-Month(startDate))+Month(endDate)+(Year(endDate)-Year(startDate)-1)*12;
return


function ny = nYear(startDate, endDate)
ny = Year(endDate)-Year(startDate);
return


function OF = CalcOF(OF, observed, simulated, Extra, Measurement, out_n, Sim_n)
Stats = statistics(observed, simulated, Extra, Measurement, out_n, Sim_n);
error_stats = [Sim_n, Extra.settings.outlets(out_n), Extra.settings.OutVars(out_n), ...
    Stats.RE,Stats.NS, Stats.R2, Stats.RMSE, Stats.SSE, Stats.LikelihoodFcn];
% error_stats = [Sim_n, Extra.settings.outlets(out_n), Extra.settings.OutVars(out_n), ...
%     Stats.BFR/100,  Stats.RE, Stats.BIAS, Stats.R2, Stats.NS, Stats.RMSE, Stats.SSE, Stats.LikelihoodFcn, Stats.FLF, Stats.KGE];
% Extract OF
switch Extra.settings.OFs(out_n)
    case 0 % 0=BFR
        new_OF  = Stats.BFR/100;
    case 1 % 5=RE
        new_OF  = abs(Stats.RE);    
    case 2 % 1=1-NS
        new_OF  = 1 - Stats.NS;
    case 3 % 2=R2
        new_OF  = Stats.R2;
    case 4 % 3=RMSE
        new_OF  = Stats.RMSE;
    case 5 % 6=SSE
        new_OF  = Stats.SSE;
    case 6 % 7=LikelihoodFunction
        new_OF  = - Stats.LikelihoodFcn;
    case 7 % 4=BIAS
        new_OF  = abs(Stats.BIAS);        
    case 8 % 8=F_LF (low flows)
        new_OF  = Stats.FLF;
    case 9 % 9=1-KGE
        new_OF  = 1 - Stats.KGE;
    case 10 % 10= HRMS
        new_OF  = Stats.HRMS;
end

Weight = Extra.settings.weights(out_n);
OF = OF + new_OF * Weight;

% Save Outputs
fprintf(Extra.settings.fid_errOut, '%s\r\n', sprintf('%-10.4g', error_stats));

return
