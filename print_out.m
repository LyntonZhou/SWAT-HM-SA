function print_out(simulated,outlet,calib_id,path,Report_date_F, Report_date_L)
sim=simulated;
[yyyy,mm,dd]=datevec(Report_date_F : Report_date_L);
if calib_id==0
    fid=fopen([path '\sim_monthly' num2str(outlet) '.prn'],'w');
    headerlines={'yyyy';'mm';'SF';'SED';'ORGN';'ORGP';'NO3N';'NH4N';
                 'NO2N';'MINP';'SOLPST';'SORPST';'TP';'TN';'TPST'};
    fprintf(fid,'%-15s',headerlines{:}); fprintf(fid,'%s\n','');
    for j=1:size(sim,1)
        fprintf(fid,'%-15i%-15i%s\n',yyyy(j),mm(j),...
            sprintf('%-15.3f',sim(j,:)));
    end            
elseif calib_id==1
    fid=fopen([path '\sim_daily' num2str(outlet) '.prn'],'w');
    headerlines={'yyyy';'mm';'dd';'SF';'SED';'ORGN';'ORGP';'NO3N';'NH4N';
                 'NO2N';'MINP';'SOLPST';'SORPST';'TP';'TN';'TPST'};
             fprintf(fid,'%-15s',headerlines{:}); fprintf(fid,'%s\n','');
    for j=1:size(sim,1)
        fprintf(fid,'%-15i%-15i%-15i%s\n',yyyy(j),mm(j),dd(j),...
            sprintf('%-15.3f',sim(j,:)));
    end
elseif calib_id==2
    fid=fopen([path '\sim_yearly' num2str(outlet) '.prn'],'w');
    headerlines={'yyyy';'SF';'SED';'ORGN';'ORGP';'NO3N';'NH4N';
                 'NO2N';'MINP';'SOLPST';'SORPST';'TP';'TN';'TPST'};
     fprintf(fid,'%-15s',headerlines{:}); fprintf(fid,'%s\n','');
    for j=1:size(sim,1)
        fprintf(fid,'%-15i%s\n',yyyy(j),sprintf('%-15.3f',sim(j,:)));
    end  
end            
fclose(fid);