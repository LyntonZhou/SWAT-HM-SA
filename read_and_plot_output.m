function [obs_cell,sim_cell] = ...
                        read_and_plot_output(swat_out,IPRINT,outlet,...
                        out_data_path,Report_date_F, Report_date_L)
%% Determine the dates for output printing/summerization 
[NBYR,IYR,IDAF,IDAL,NYSKIP,out_dates] = proj_dates(out_data_path);
% if ~exist([path '\rchout.mat'])
%     out=load([path '\rchout.prn']);
%     save([path '\rchout.mat'], 'out');
% else
%     rchmat = load([path '\rchout.mat']);
%     out = rchmat.out;
%     clear rchmat;
% end

% rchmat = load([out_data_path '\rchout.mat']);
% out = rchmat.out;
% %% Compute statistics for outlets of interest
% swat_out = read_rchout(out,IPRINT,ICALIB,out_id,outlet, n_DayinMonth, n_DayinYear);
switch IPRINT 
    case {0}, file_name = [out_data_path '\obs_monthly' num2str(outlet) '.prn']; 
    case {1}, file_name = [out_data_path '\obs_daily' num2str(outlet) '.prn']; 
    case {2}, file_name = [out_data_path '\obs_yearly' num2str(outlet) '.prn']; 
end

% [simulated, sim_plot_start, observed, obs_plot_start, pcp_data] = ...
%                     obs_sim_data(swat_out,out_dates,IPRINT,outlet,path,...
%                     pcp_filename,Report_date_F, Report_date_L);
[simulated,observed,sim_plot_start,obs_plot_start] = ...
                    obs_sim_data(swat_out,out_dates,IPRINT,outlet, ...
                    out_data_path,Report_date_F, Report_date_L);                
%% calculate TKN and NO2+NO3 for observed data
nanObs = observed;
nanObs(nanObs==-99)=NaN;
if ~isempty(nanObs)
    tkn = sum([nanObs(:,3), nanObs(:,6)]');
    no2no3 = sum([nanObs(:,5), nanObs(:,7)]');
else
    tkn = zeros(size(simulated,1),1);
    no2no3 = zeros(size(simulated,1),1);
end
tkn(isnan(tkn))=-99;
no2no3(isnan(no2no3))=-99;
observed(:,14)=tkn;
observed(:,15)=no2no3;

%%
print_out(simulated,outlet,IPRINT,out_data_path,Report_date_F, Report_date_L);

if exist(file_name)
%     [simulated, sim_plot_start, observed, obs_plot_start, pcp_data] = ...
%                     obs_sim_data(swat_out,out_dates,IPRINT,outlet,path,...
%                     pcp_filename,Report_date_F, Report_date_L);
action_type = 'stat';
    switch action_type
        case {'stat'}
            if length(simulated)> length(observed)
                simulated = simulated(obs_plot_start:(obs_plot_start + length(observed) - 1),:);                
            else
                observed = observed (1:length(simulated),:);
            end
            Stats = statistics(simulated, observed, swat_out,out_dates,IPRINT,outlet,out_data_path);
            bfr_diff = Stats.BFR;
            error_out(Stats, outlet,out_data_path);
        case {'plot'}
            if length(simulated)> length(observed)
                simulated = simulated(obs_plot_start:(obs_plot_start + length(observed) - 1),:);
            else
                observed = observed (1:length(simulated),:);
            end
            Stats.BFR = 999.99;
            Stats.RE = -99.0;  Stats.BIAS = -99.0;
            Stats.SSE = -99.0; Stats.RMSE = -99.0;
            Stats.R2 = -99.0;  Stats.NS = -99.0;
    end
else
    Stats.BFR = 999.99;
    Stats.RE = -99.0;  Stats.BIAS = -99.0;
    Stats.SSE = -99.0; Stats.RMSE = -99.0;
    Stats.R2 = -99.0;  Stats.NS = -99.0;
end
obs_cell = observed;
sim_cell = simulated;