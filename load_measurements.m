function measurements = load_measurements(settings, rho, Sigma)
user_inputs_path    = settings.user_inputs_path;
outlets             = settings.outlets;
timesteps           = settings.timesteps;
for i=1:length(outlets)
    switch timesteps(i)
        case 1 % Daily
            obs = textread([user_inputs_path '\obs_daily' num2str(outlets(i)) '.prn'],'','headerlines',1);
            Obs_F = datenum(obs(1,1)  , obs(1,2)  , obs(1,3));
            Obs_L = datenum(obs(end,1), obs(end,2), obs(end,3));
            observed = obs(:,4:end);
        case 0 % monthly
            obs = textread([user_inputs_path '\obs_monthly' num2str(outlets(i)) '.prn'],'','headerlines',1);
            Obs_F = datenum(obs(1,1)  , obs(1,2)  , 1);
            Obs_L = datenum(obs(end,1), obs(end,2), eomday(obs(end,1), obs(end,2)));
            observed = obs(:,3:end);
        case 2 % Annual
            obs = textread([user_inputs_path '\obs_yearly' num2str(outlets(i)) '.prn'],'','headerlines',1);
            Obs_F = datenum(obs(1,1)  , 1 , 1);
            Obs_L = datenum(obs(end,1), 12, eomday(obs(end,1), 12));
            observed = obs(:,2:end);
    end
    nanObs = observed;
    nanObs(nanObs==-99)=NaN;
    if ~isempty(nanObs)
       tkn = sum([nanObs(:,3), nanObs(:,6)]')';
       no2no3 = sum([nanObs(:,5), nanObs(:,7)]')';
    else
       tkn = zeros(size(simulated,1),1);
       no2no3 = zeros(size(simulated,1),1);
    end
    tkn(isnan(tkn))=-99;
    no2no3(isnan(no2no3))=-99;
    observed(:,14)=tkn;
    observed(:,15)=no2no3;
    
    measurements{i}.Obs_F       = Obs_F;
    measurements{i}.Obs_L       = Obs_L;
    measurements{i}.MeasData    = observed;
    measurements{i}.N           = size(observed,1);
    measurements{i}.Sigma       = Sigma(i);
    if ~isempty(rho)
        measurements{i}.rho         = rho(i);
    else
        measurements{i}.rho         = [];
    end
end

return