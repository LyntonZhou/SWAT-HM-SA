function rte(subid, par_n, par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path)
% rte is main channel input files

subid=char(subid);
subid=[subid '.rte'];

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==6 && par_f(strcmp(symbol, 'CH_N2'))==1;
        %         CH_N2 = x(strcmp(symbol, 'CH_N2'));
        CH_N2=par_value(x, line, alter_m, lba, uba, symbol, 'CH_N2');
        fprintf(fid2,'%14.3f    %s\r\n',CH_N2,'| CH_N2 : Manning"s nvalue for main channel');
        
    elseif L==4 && par_f(strcmp(symbol, 'CH_S2'))==1;
        %         CH_S2 = x(strcmp(symbol, 'CH_S2'));
        %         CH_S2=str2double(strtok(line))*(1+CH_S2);
        CH_S2=par_value(x, line, alter_m, lba, uba, symbol, 'CH_S2');
        fprintf(fid2,'%14.3f    %s\r\n', CH_S2,'| CH_S2 : Main channel slope [m/m]');
        
    elseif L==7 && par_f(strcmp(symbol, 'CH_K2'))==1;
        %         CH_K2 = x(strcmp(symbol, 'CH_K2'));
        CH_K2=par_value(x, line, alter_m, lba, uba, symbol, 'CH_K2');
        fprintf(fid2,'%14.3f    %s\r\n',CH_K2,'| CH_K2 : Effective hydraulic conductivity [mm/hr]');
        
    elseif L==8 && par_f(strcmp(symbol, 'CH_COV1'))==1;
        %         CH_COV1 = x(strcmp(symbol, 'CH_COV1'));
        CH_COV1=par_value(x, line, alter_m, lba, uba, symbol, 'CH_COV1');
        fprintf(fid2,'%14.3f    %s\r\n',CH_COV1,'| CH_COV1 : Channel erodibility factor');
        
    elseif L==9 && par_f(strcmp(symbol, 'CH_COV2'))==1;
        %         CH_COV2 = x(strcmp(symbol, 'CH_COV1'));
        CH_COV2=par_value(x, line, alter_m, lba, uba, symbol, 'CH_COV2');
        fprintf(fid2,'%14.3f    %s\r\n',CH_COV2,'| CH_COV2 : Channel cover factor');
        
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;