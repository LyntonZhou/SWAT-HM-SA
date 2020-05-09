function plot_out(observed,simulated,outlet,calib_id)

if calib_id==1
    x_label='Time (day)';      
    y_label1='Cumulative Daily Streamflow (m^3/s)';
    y_label2='Cumulative Daily Sediment Yield (t/ha)';
    y_label3='Cumulative Daily Total P Yield (kg/ha)';
    y_label4='Cumulative Daily Total N Yield (kg/ha)';
    y_label5='Cumulative Daily Atrazine Yield (mg/ha)';
elseif calib_id==0
    x_label='Time (month)';      
    y_label1='Cumulative Monthly Streamflow (m^3/s)';
    y_label2='Cumulative Monthly Sediment Yield (t/ha)';
    y_label3='Cumulative Monthly Total P Yield (kg/ha)';
    y_label4='Cumulative Monthly Total N Yield (kg/ha)';
    y_label5='Cumulative Monthly Atrazine Yield (mg/ha)';
else
    x_label='Time (year)';      
    y_label1='Cumulative Annual Streamflow (m^3/s)';
    y_label2='Cumulative Annual Sediment Yield (t/ha)';
    y_label3='Cumulative Annual Total P Yield (kg/ha)';
    y_label4='Cumulative Annual Total N Yield (kg/ha)';
    y_label5='Cumulative Annual Atrazine Yield (mg/ha)';
end
%% Plot The results
obs=observed; sim=simulated;
figure  

subplot(2,3,1)
obs_sf=obs(obs(:,1)~=-99,1);sim_sf=sim(obs(:,1)~=-99,1);
plot(1:length(obs_sf),cumsum(obs_sf),'k',1:length(sim_sf),cumsum(sim_sf),':r')
xlabel(x_label);
ylabel(y_label1);
title(['Outlet' num2str(outlet)]);
legend('observed','simulated')

subplot(2,3,2)
obs_sed=obs(obs(:,2)~=-99,2);sim_sed=sim(obs(:,2)~=-99,2);
plot(1:length(obs_sed),cumsum(obs_sed),'k',1:length(sim_sed),cumsum(sim_sed),':r')
xlabel(x_label);
ylabel(y_label2);

subplot(2,3,4)
obs_tp=obs(obs(:,11)~=-99,11);sim_tp=sim(obs(:,11)~=-99,11);
plot(1:length(obs_tp),cumsum(obs_tp),'k',1:length(sim_tp),cumsum(sim_tp),':r')
xlabel(x_label);
ylabel(y_label3);

subplot(2,3,5)
obs_tn=obs(obs(:,12)~=-99,12);sim_tn=sim(obs(:,12)~=-99,12);
plot(1:length(obs_tn),cumsum(obs_tn),'k',1:length(sim_tn),cumsum(sim_tn),':r')
xlabel(x_label);
ylabel(y_label4);

subplot(2,3,6)
obs_tpst=obs(obs(:,13)~=-99,13);sim_tpst=sim(obs(:,13)~=-99,13);
plot(1:length(obs_tpst),cumsum(obs_tpst),'k',1:length(sim_tpst),cumsum(sim_tpst),':r')
xlabel(x_label);
ylabel(y_label5);
return;