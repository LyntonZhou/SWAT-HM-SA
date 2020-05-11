function rte(subid,par_n,par_f,symbol,x, sensin_path, out_data_path)
subid=char(subid);
subid=[subid '.rte'];

CH_COV1 = x(cellfun(@(x) isequal(x, 'CH_COV1'), symbol));
CH_COV2 = x(cellfun(@(x) isequal(x, 'CH_COV2'), symbol));
CH_KII = x(cellfun(@(x) isequal(x, 'CH_KII'), symbol));
CH_NII = x(cellfun(@(x) isequal(x, 'CH_NII'), symbol));
CH_SII = x(cellfun(@(x) isequal(x, 'CH_SII'), symbol));

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==6 && par_f(cellfun(@(x) isequal(x, 'CH_NII'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\r\n',CH_NII,'| CH_N2 : Manning"s nvalue for main channel');
    elseif L==4 && par_f(cellfun(@(x) isequal(x, 'CH_SII'), symbol))==1;
        CH_S2=str2double(strtok(line))*(1+CH_SII);
        fprintf(fid2,'%16.3f\t  %s\r\n', CH_S2,'| CH_S2 : Main channel slope [m/m]');        
    elseif L==7 && par_f(cellfun(@(x) isequal(x, 'CH_KII'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\r\n',CH_KII,'| CH_K2 : Effective hydraulic conductivity [mm/hr]');   
    elseif L==8 && par_f(cellfun(@(x) isequal(x, 'CH_COV1'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\r\n',CH_COV1,'| CH_COV1 : Channel erodibility factor');         
    elseif L==9 && par_f(cellfun(@(x) isequal(x, 'CH_COV2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\r\n',CH_COV2,'| CH_COV2 : Channel cover factor');         
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;