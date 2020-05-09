function simulated = measurement_error(out_n,observed,simulated,Extra)
                               
Data_length1 =length(observed);
Data_length2 =length(simulated);
if Data_length1 ~= Data_length2
    disp('Length of selected observed data is different than simulated data')
    keyboard
end

for i = 1:Data_length1
    obs_UB = observed(i)+ 1.96*Extra.settings.COV(out_n)*observed(i);
    obs_LB = observed(i)- 1.96*Extra.settings.COV(out_n)*observed(i);
    if obs_LB < 0
        obs_LB = 0;
    end
    
    if simulated(i) <= obs_UB && simulated(i) >= obs_LB
        simulated(i) = observed(i);
    end
end