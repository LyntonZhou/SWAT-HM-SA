function [CF,CF_RE] = Correction_Factor(out_n,SelectDataLength,obs_select,sim_select,Extra)

CF = zeros();
for i = 1:SelectDataLength
    if obs_select(i) == 0
        obs_select(i) = 0.00001;
    end
    sigma_MU = Extra.settings.COV(out_n)*obs_select(i)/(3.9*100);
           
    if sim_select(i) >= obs_select(i)
        CF(i) = normcdf(sim_select(i),obs_select(i),sigma_MU) - 0.5;
    elseif sim_select(i) < obs_select(i)
        CF(i) = 0.5 - normcdf(sim_select(i),obs_select(i),sigma_MU);
    end
end
CF = CF'/0.5;

sigma_MU = Extra.settings.COV(out_n)*mean(obs_select)/(3.9*100);

if mean(sim_select) >= mean(obs_select)
    CF_RE = normcdf(mean(sim_select),mean(obs_select),sigma_MU) - 0.5;    
elseif mean(sim_select) < mean(obs_select)
    CF_RE = 0.5 - normcdf(mean(sim_select),mean(obs_select),sigma_MU);
end

CF_RE = CF_RE/0.5;
