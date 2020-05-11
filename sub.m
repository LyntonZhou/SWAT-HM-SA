function sub(subid, par_n, par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path)

subid=char(subid);
subid=[subid '.sub'];

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==29 && par_f(strcmp(symbol, 'CH_NI'))==1;
%         CH_NI = x(strcmp(symbol, 'CH_NI'));
        CH_NI=par_value(x, line, alter_m, lba, uba, symbol, 'CH_NI');
        fprintf(fid2,'%16.3f    %s\r\n',CH_NI,'| CH_N1 : Manning"s "n" value for the tributary channels');
        
    elseif L==26 && par_f(strcmp(symbol, 'CH_SI'))==1;
%         CH_SI = x(strcmp(symbol, 'CH_SI'));
%         CH_S=str2double(strtok(line))*(1+CH_SI);
        CH_SI=par_value(x, line, alter_m, lba, uba, symbol, 'CH_SI');
        fprintf(fid2,'%16.3f    %s\r\n',CH_SI,'| CH_S1 : Average slope of tributary channel [m/m]');
        
    elseif L==28 && par_f(strcmp(symbol, 'CH_KI'))==1;
%         CH_KI = x(strcmp(symbol, 'CH_KI'));
        CH_KI=par_value(x, line, alter_m, lba, uba, symbol, 'CH_KI');
        fprintf(fid2,'%16.3f    %s\r\n',CH_KI,'| CH_K1 : Effective hydraulic conductivity in tributary channel [mm/hr]');
        
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;