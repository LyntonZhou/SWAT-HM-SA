function wwq(par_n,par_f,symbol,x, sensin_path, out_data_path)
AI0  = x(cellfun(@(x) isequal(x, 'AI0'), symbol));
AI1  = x(cellfun(@(x) isequal(x, 'AI1'), symbol));
AI2  = x(cellfun(@(x) isequal(x, 'AI2'), symbol));
RHOQ = x(cellfun(@(x) isequal(x, 'RHOQ'), symbol));
K_N  = x(cellfun(@(x) isequal(x, 'K_N'), symbol));
P_N  = x(cellfun(@(x) isequal(x, 'P_N'), symbol));
MUMAX  = x(cellfun(@(x) isequal(x, 'MUMAX'), symbol));

file_read  = [sensin_path '\basins.wwq'];
file_write = [out_data_path '\basins.wwq'];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==4 && par_f(cellfun(@(x) isequal(x, 'AI0'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',AI0,'| AI0 : Ratio of chlorophyll-a to algal biomass [µg-chla/mg algae]');        
    elseif L==5 && par_f(cellfun(@(x) isequal(x, 'AI1'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',AI1,'| AI1 : Fraction of algal biomass that is nitrogen [mg N/mg alg]');          
    elseif L==6 && par_f(cellfun(@(x) isequal(x, 'AI2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',AI2,'| AI2 : Fraction of algal biomass that is phosphorus [mg P/mg alg]');     
    elseif L==11 && par_f(cellfun(@(x) isequal(x, 'MUMAX'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',MUMAX,'| MUMAX : Maximum specific algal growth rate at 20º C [day-1]');
    elseif L==12 && par_f(cellfun(@(x) isequal(x, 'RHOQ'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RHOQ,'| RHOQ : Algal respiration rate at 20º C [day-1]');
    elseif L==15 && par_f(cellfun(@(x) isequal(x, 'K_N'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',K_N,'| K_N : Michaelis-Menton half-saturation constant for nitrogen [mg N/lL]');
    elseif L==20 && par_f(cellfun(@(x) isequal(x, 'P_N'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',P_N,'| P_N : Algal preference factor for ammonia');
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;