function wwq(par_n, par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path)

file_read  = [sensin_path '\basins.wwq'];
file_write = [out_data_path '\basins.wwq'];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==4 && par_f(strcmp(symbol, 'AI0'))==1;
%         AI0  = x(strcmp(symbol, 'AI0'));
        AI0=par_value(x, line, alter_m, lba, uba, symbol, 'AI0');
        fprintf(fid2,'%16.3f    %s\r\n',AI0,'| AI0 : Ratio of chlorophyll-a to algal biomass [ug-chla/mg algae]'); 
        
    elseif L==5 && par_f(strcmp(symbol, 'AI1'))==1;
%         AI1  = x(strcmp(symbol, 'AI1'));
        AI1=par_value(x, line, alter_m, lba, uba, symbol, 'AI1');
        fprintf(fid2,'%16.3f    %s\r\n',AI1,'| AI1 : Fraction of algal biomass that is nitrogen [mg N/mg alg]');
        
    elseif L==6 && par_f(strcmp(symbol, 'AI2'))==1;
%         AI2  = x(strcmp(symbol, 'AI2'));
        AI2=par_value(x, line, alter_m, lba, uba, symbol, 'AI2');
        fprintf(fid2,'%16.3f    %s\r\n',AI2,'| AI2 : Fraction of algal biomass that is phosphorus [mg P/mg alg]'); 
        
    elseif L==11 && par_f(strcmp(symbol, 'MUMAX'))==1;
%         MUMAX  = x(strcmp(symbol, 'MUMAX'));
        MUMAX=par_value(x, line, alter_m, lba, uba, symbol, 'MUMAX');
        fprintf(fid2,'%16.3f    %s\r\n',MUMAX,'| MUMAX : Maximum specific algal growth rate at 20oC [day-1]');
        
    elseif L==12 && par_f(strcmp(symbol, 'RHOQ'))==1;
%         RHOQ = x(strcmp(symbol, 'RHOQ'));
        RHOQ=par_value(x, line, alter_m, lba, uba, symbol, 'RHOQ');
        fprintf(fid2,'%16.3f    %s\r\n',RHOQ,'| RHOQ : Algal respiration rate at 20?C [day-1]');
        
    elseif L==15 && par_f(strcmp(symbol, 'K_N'))==1;
%         K_N  = x(strcmp(symbol, 'K_N'));
        K_N=par_value(x, line, alter_m, lba, uba, symbol, 'K_N');
        fprintf(fid2,'%16.3f    %s\r\n',K_N,'| K_N : Michaelis-Menton half-saturation constant for nitrogen [mg N/lL]');
        
    elseif L==20 && par_f(strcmp(symbol, 'P_N'))==1;
%         P_N  = x(strcmp(symbol, 'P_N'));
        P_N=par_value(x, line, alter_m, lba, uba, symbol, 'P_N');
        fprintf(fid2,'%16.3f    %s\r\n',P_N,'| P_N : Algal preference factor for ammonia');
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;