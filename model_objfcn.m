function OF = model_objfcn(n_sub,outlet,out_id,IPRINT,ICALIB, ...
                           out_dates,file_id,x,sensin_path,out_data_path,...
                           Report_date_F, Report_date_L, out_n,fid_err,ICALL, ...
                           stat_txt,timestep_txt,weight)
%% Adjust input parameters
par_alter(x,file_id,n_sub,sensin_path,out_data_path);
%% Call the SWAT model
dos('swat2005.exe');
%% Read the "output.rch" file
% fid1=fopen('output.rch','r');
% fid2=fopen('rchout.prn','w');
% L=0;
% while feof(fid1)==0
%     L=L+1;
%     line=fgets(fid1);
%     if L>=10
%         [reach,rem]=strtok(line);
%         fprintf(fid2,'%s\n',rem);
%     end
% end
% fclose(fid1);
% fclose(fid2);
% out=load('rchout.prn');
[out, n_DayinMonth, n_DayinYear] = read_binary_rch(out_data_path, sum(out_id(2:11))); %%%%%
nOutlets = max(textread(fullfile(curr_path, 'fig.fig'), '%*s%*s%*s%*s%*s%n'));

save([out_data_path '\rchout.mat'], 'out');
disp(' . . . Reading outputs from output.rch completed')
%% Compute the objective function
for i=1:length(outlet)    
    %[swat_out] = read_output(n_sub,out,IPRINT,ICALIB,out_id,outlets(i));
     [swat_out] = read_rchout(out,IPRINT,ICALIB,out_id,outlet(i), n_DayinMonth, n_DayinYear, nOutlets);
    if isequal(lower(timestep_txt{i}), 'monthly')
        currentIPRINT = 0;
        swat_out = mytomonthly(swat_out, Report_date_F, Report_date_L, ICALIB);
    elseif isequal(lower(timestep_txt{i}), 'annual')
        currentIPRINT =2;
        swat_out = mytoyearly(swat_out, Report_date_F, Report_date_L, ICALIB);
    else
        currentIPRINT = IPRINT;
    end
%     [simulated,observed] = ...
%             obs_sim_data(swat_out,out_dates,IPRINT,outlet,out_data_path,...
%                          Report_date_F, Report_date_L);
    [obs_cell,sim_cell] = ...
                        read_and_plot_output(swat_out,currentIPRINT,outlet(i),...
                        out_data_path,Report_date_F, Report_date_L);
                    
    observed = obs_cell;
    simulated = sim_cell;
                     
    %[Stats] = statistics(swat_out,out_dates,IPRINT,outlets(i)); 
    [Stats] = statistics(simulated,observed,swat_out,out_dates,currentIPRINT,outlet(i),out_data_path);

    %% All Statistical outputs
    fprintf(fid_err,'%-7i%-8i',ICALL,outlet(i));
    all_stats = [Stats.RE;Stats.BIAS;Stats.R2;Stats.NS;Stats.RMSE;Stats.SSE];
    all_stats = [Stats.BFR/100;all_stats(:)];    
    %error_stats(:,i) = [Stats.BFR/100;all_stats(:)]; 
    fprintf(fid_err,'%s\n',sprintf('%-13.4E',all_stats)); 
    
    switch stat_txt{i}
        case ''    , OF_value = Stats.BFR;
        case '1-NS', OF_value = 1-Stats.NS;
        case 'R2'  , OF_value = 1-Stats.R2;
        case 'RMSE', OF_value = Stats.RMSE;
        case 'BIAS', OF_value = abs(Stats.BIAS);
        case 'RE'  , OF_value = abs(Stats.RE);
        case 'SSE' , OF_value = abs(Stats.SSE);
    end
    if isempty(stat_txt{i})
        OF(i)	= OF_value;
    else
        OF(i)  	= OF_value(out_n(i)-1);
    end
%     %error_stats(i) = Stats.RMSE(out_n); %#ok<AGROW>
%     for j=1:size(out_n,2)
%         if Stats.NS(out_n(j)) == -99
%             Stats.NS(out_n(j)) = NaN;
%         end
%     end
%     error_stats(i) = 1 - nanmean(Stats.NS(out_n));
end
% OF = mean(error_stats);
OF = nansum(weight .* OF) / (sum(weight));
return;