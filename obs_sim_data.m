% function [simulated, sim_plot_start, observed, obs_plot_start, pcp_data] = ...
%                     obs_sim_data(swat_out,out_dates,IPRINT,outlet,path,...
%                     pcp_filename, Report_date_F, Report_date_L)
function [simulated,observed,sim_plot_start,obs_plot_start] = ...
            obs_sim_data(swat_out,out_dates,IPRINT,outlet,out_data_path,...
                         Report_date_F, Report_date_L)     
%% Report dates
[from_yr, from_mm, from_dd] = datevec(Report_date_F);
[to_yr, to_mm, to_dd] = datevec(Report_date_L);
%% Simulation dates
yr_sim=out_dates(:,1); m_sim=out_dates(:,2); d_sim=out_dates(:,3);
Sim_F = datenum(yr_sim(1), m_sim(1), d_sim(1));
Sim_L = datenum(yr_sim(end), m_sim(end), d_sim(end));

%% Read data from "obs_daily.prn"
if IPRINT==1
    % Observed
    if exist([out_data_path '\obs_daily' num2str(outlet) '.prn'])
        obs=textread([out_data_path '\obs_daily' num2str(outlet) '.prn'],'','headerlines',1);
        yr_obs= obs(:,1); m_obs= obs(:,2); d_obs= obs(:,3);
        Obs_F = datenum(yr_obs(1), m_obs(1), d_obs(1));
        Obs_L = datenum(yr_obs(end), m_obs(end), d_obs(end));
        observed=obs(:,4:end); obs_plot_start=1; obs_first = 1; obs_last = length(observed);
        if Report_date_F > Obs_F, obs_first = Report_date_F - Obs_F + 1;
        else obs_plot_start = Obs_F - Report_date_F +1;
        end
        if Report_date_L < Obs_L, obs_last  = length(observed)-(Obs_L - Report_date_L); end
        observed = observed(obs_first:obs_last,:);
    else
        observed = [];
        obs_plot_start = [];
    end
    % Simulated and Precipitation
    simulated = swat_out;
    sim_plot_start = 1; sim_start = 1; sim_last = length(simulated);
    if Report_date_F > Sim_F, sim_start = Report_date_F - Sim_F + 1;
    else sim_plot_start = Sim_F - Report_date_F + 1;
    end
    if Report_date_L < Sim_L, sim_last = length(simulated)-(Sim_L - Report_date_L); end
    simulated = simulated(sim_start:sim_last,:);
    
% %     %% Precipitation
% %     if exist([path '\' strtok(pcp_filename)])
% %         [yyyy, ddd, pcp_data] = load_pcp(path, pcp_filename);
% % %         [yyyy, ddd, pcp_data] = textread([path '\' strtok(pcp_filename)],'%4n%3n%5n%*s','headerlines',4);
% %         pcp_start = datenum(yyyy(1),1,1)+ddd(1)-1;
% %         pcp_end = datenum(yyyy(end),1,1)+ddd(end)-1;
% %         pcp_data = pcp_data((Report_date_F-pcp_start+1):(Report_date_L-pcp_start+1));
% %     else
% %         pcp_data = [];
% %     end

elseif IPRINT==0
    % Observed
    [from_yr, from_mm, from_dd] = datevec(Report_date_F);
    [to_yr, to_mm, to_dd] = datevec(Report_date_L);
    L=0;
    for yy=from_yr:to_yr
        if yy==from_yr
            for mm=from_mm:12; L=L+1; yr_vec(L)=yy; m_vec(L)=mm; end
        elseif yy==to_yr
            for mm=1:to_mm; L=L+1; yr_vec(L)=yy; m_vec(L)=mm; end
        else
            for mm=1:12; L=L+1; yr_vec(L)=yy; m_vec(L)=mm; end
        end
    end
    if exist([out_data_path '\obs_monthly' num2str(outlet) '.prn'])
        obs=textread([out_data_path '\obs_monthly' num2str(outlet) '.prn'],'','headerlines',1);
        yr_obs=obs(:,1); m_obs=obs(:,2);
        observed=obs(:,3:end); obs_plot_start=1; obs_first = 1; obs_last = length(observed);
        Report_date_F = datenum(from_yr, from_mm,1);Report_date_L = datenum(to_yr, to_mm,28);
        Obs_F = datenum(yr_obs(1), m_obs(1), 1); Obs_L = datenum(yr_obs(end), m_obs(end), 28);
        if Report_date_F > Obs_F, obs_first = find(yr_obs==from_yr & m_obs==from_mm, 1, 'first' );
        else obs_plot_start = find(yr_vec==yr_obs(1) & m_vec==m_obs(1));
        end
        if Report_date_L < Obs_L, obs_last = find(yr_obs==to_yr & m_obs==to_mm, 1, 'last' ); end
        observed = observed(obs_first:obs_last,:);
    else
        observed = [];
        obs_plot_start = [];
    end
    % Simulated
    L=0;
    for yy=yr_sim(1):yr_sim(end)
        if yy==yr_sim(1)
            for mm=m_sim(1):12; L=L+1; yr_vec(L)=yy; m_vec(L)=mm; end
        elseif yy==yr_sim(end)
            for mm=1:m_sim(end); L=L+1; yr_vec(L)=yy; m_vec(L)=mm; end
        else
            for mm=1:12; L=L+1; yr_vec(L)=yy; m_vec(L)=mm; end
        end
    end
    simulated = swat_out;
    sim_plot_start = 1; sim_start = 1; sim_last = length(simulated);
    Report_date_F = datenum(from_yr, from_mm,1);Report_date_L = datenum(to_yr, to_mm,28);
    Sim_F = datenum(yr_sim(1), m_sim(1), 1); Sim_L = datenum(yr_sim(end), m_sim(end), 28);
    
    if Report_date_F > Sim_F, sim_start = find(yr_vec==from_yr & m_vec==from_mm, 1, 'first' );
    else sim_plot_start = find(yr_vec==yr_sim(1) & m_vec==m_sim(1));
    end
    if Report_date_L < Sim_L, sim_last = find(yr_vec==to_yr & m_vec==to_mm, 1, 'last' ); end
    simulated = simulated(sim_start:sim_last,:);
    
% %     %% Precipitation
% %     if exist([path '\' strtok(pcp_filename)])
% %         [yyyy, ddd, pcp_data] = load_pcp(path, pcp_filename);
% % %         [yyyy, ddd, pcp_data] = textread([path '\' strtok(pcp_filename)],'%4n%3n%5n%*s','headerlines',4);
% %         pcp_start = datenum(yyyy(1),1,1)+ddd(1)-1;
% %         pcp_end = datenum(yyyy(end),1,1)+ddd(end)-1;
% %         pcp_data = pcp_data((Sim_F-pcp_start+1):(Sim_L-pcp_start+1));
% %         pcp_data = pcp_rcalc(pcp_data, Sim_F, Report_date_F, Report_date_L, 'month');
% %     else
% %         pcp_data = [];
% %     end
    
elseif IPRINT==2
    yr_vec = from_yr:to_yr;
    % Observed
    if exist([out_data_path '\obs_yearly' num2str(outlet) '.prn'])
        obs=textread([out_data_path '\obs_yearly' num2str(outlet) '.prn'],'','headerlines',1);
        yr_obs=obs(:,1);
        observed=obs(:,2:end); obs_plot_start=1; obs_first = 1; obs_last = length(observed);
        if from_yr > yr_obs(1), obs_first = find(yr_obs == from_yr);
        else obs_plot_start = find(yr_vec==yr_obs(1));
        end
        if Report_date_L < yr_obs(end), obs_last = find(yr_obs==to_yr); end
        observed = observed(obs_first:obs_last,:);
    else
        observed = [];
        obs_plot_start = [];
    end
    % Simulated
    yr_vec = yr_sim(1):yr_sim(end);
    simulated = swat_out;
% %     pcp_data = textread([out_data_path '\' strtok(pcp_filename)],'%*7s%5n%*s','headerlines',4);
    sim_plot_start = 1; sim_start = 1; sim_last = length(simulated);
    if from_yr > yr_sim(1), sim_start = find(yr_sim == from_yr);
    else sim_plot_start = find(yr_vec==yr_sim(1));
    end
    if Report_date_L < yr_sim(end), sim_last = find(yr_vec==to_yr); end
    simulated = simulated(sim_start:sim_last,:);
    
% %     %% Precipitation
% %     if exist([path '\' strtok(pcp_filename)])
% %         [yyyy, ddd, pcp_data] = load_pcp(path, pcp_filename);
% % %         [yyyy, ddd, pcp_data] = textread([path '\' strtok(pcp_filename)],'%4n%3n%5n%*s','headerlines',4);
% %         pcp_start = datenum(yyyy(1),1,1)+ddd(1)-1;
% %         pcp_end = datenum(yyyy(end),1,1)+ddd(end)-1;
% %         pcp_data = pcp_data((Sim_F-pcp_start+1):(Sim_L-pcp_start+1));
% %         pcp_data = pcp_rcalc(pcp_data, Sim_F, Report_date_F, Report_date_L, 'year');
% %     else
% %         pcp_data = [];
% %     end
end


% % function new_data = pcp_rcalc(daily_data, Sim_F, Report_date_F, Report_date_L, duration)
% % % this m-file can be used to convert daily data to monthly and yearly
% % % data
% % 
% % % Report_date_F = datenum(from_yr, from_mm, from_dd); Report_date_F is the
% % % start date of the reported data
% % 
% % % Report_date_L = datenum(to_yr, to_mm, to_dd); Report_date_L is the end
% % % date of the reported data
% % 
% % % Sim_F = datenum(yr_sim(1), m_sim(1), d_sim(1)); Sim_F is the start date
% % % of original data
% % 
% % % duration can be 'month' or 'year'
% % 
% % count = 1;
% % F(1) = Report_date_F - Sim_F+1;
% % switch duration
% %     case {'month'}
% %         for jd=Report_date_F:Report_date_L
% %             [y,m,dd] = datevec(jd);
% %             if dd == 1
% %                 L(count)= (jd - Sim_F);
% %                 count = count+1;
% %                 F(count) = (jd - Sim_F)+1;
% %             end
% %         end
% %     case {'year'}
% %         [prev_y, m, dd] = datevec(Report_date_F);
% %         prev_y = prev_y;
% %         for jd=Report_date_F:Report_date_L
% %             [y,m,dd] = datevec(jd);
% % %             L(count)= (jd - Sim_F)+1;
% %             if  y ~= prev_y;
% %                 prev_y = prev_y+1;
% %                 L(count)= (jd - Sim_F)+1;
% %                 count = count+1;
% %                 F(count) = (jd - Sim_F)+1;
% %             end
% %         end
% % end
% % L(count) = (Report_date_L - Sim_F)+1;
% % if length(L)>1
% %     for i=1:length(L)-1
% %         new_data(i)=sum(daily_data(F(i+1):L(i+1)));
% %     end
% % else
% %     for i=1:length(L)
% %         new_data(i)=sum(daily_data(F(i):L(i)));
% %     end
% % end
% % return


% % function [yyyy, ddd, pcp_data] = load_pcp(path, pcp_filename)
% % [yyyy, ddd, data] = textread([path '\' strtok(pcp_filename)],'%4n%3n%s','headerlines',4);
% % data = char(data);
% % [r,c] = size(data);
% % n_stsn = round(c/5);
% % all_pcp = zeros(r, n_stsn);
% % L = 0;
% % strt = 1;
% % for i=1:n_stsn
% %     L = L+1;
% %     all_pcp(:, L) = str2num(data(:, strt:strt+4));
% %     strt = strt + 5;
% % end
% % for i=1:r
% %     data = all_pcp(i,:);
% %     pcp_data(i) = mean(data(data ~= -99));
% % end

