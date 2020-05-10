function gw(hruid,hru_lnd,par_n,par_f,symbol,x, sensin_path, out_data_path)
hruid=char(hruid);
hru_str=[hruid '.gw'];

% ALPHA_BF    = x(cellfun(@(x) isequal(x, 'ALPHA_BF'), symbol));
% GW_DELAY    = x(cellfun(@(x) isequal(x, 'GW_DELAY'), symbol));
% GW_REVAP    = x(cellfun(@(x) isequal(x, 'GW_REVAP'), symbol));
% GW_SPYLD    = x(cellfun(@(x) isequal(x, 'GW_SPYLD'), symbol));
% GWHT        = x(cellfun(@(x) isequal(x, 'GWHT'), symbol));
% GWQMN       = x(cellfun(@(x) isequal(x, 'GWQMN'), symbol));
% RCHRG_DP    = x(cellfun(@(x) isequal(x, 'RCHRG_DP'), symbol));
% REVEP_MN    = x(cellfun(@(x) isequal(x, 'REVEP_MN'), symbol));
% SHALLST_N    = x(cellfun(@(x) isequal(x, 'SHALLST_N'), symbol));
% HLIFE_NGW    = x(cellfun(@(x) isequal(x, 'HLIFE_NGW'), symbol));

file_read  = [sensin_path '\' hru_str];
file_write = [out_data_path '\' hru_str];
% delete(file_write);
fid1=fopen(file_read, 'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==4 && par_f(strcmp(symbol, 'GW_DELAY'))==1
        GW_DELAY    = x(strcmp(symbol, 'GW_DELAY'));
        fprintf(fid2,'%16.3f\t  %s\r\n', GW_DELAY ,'| GW_DELAY : Groundwater delay [days]');
    elseif L==5 && par_f(strcmp(symbol, 'ALPHA_BF'))==1
        ALPHA_BF    = x(strcmp(symbol, 'ALPHA_BF'));
        fprintf(fid2,'%16.3f\t  %s\r\n', ALPHA_BF ,'| ALPHA_BF : BAseflow alpha factor [days]');
    elseif L==6 && par_f(strcmp(symbol, 'GWQMN'))==1
        GWQMN       = x(strcmp(symbol, 'GWQMN'));
        fprintf(fid2,'%16.3f\t  %s\r\n', GWQMN ,'|  GWQMN : Threshold depth of water in the shallow aquifer required for return flow to occur [mm]');
    elseif L==7 && par_f(strcmp(symbol, 'GW_REVAP'))==1
        GW_REVAP    = x(strcmp(symbol, 'GW_REVAP'));
        fprintf(fid2,'%16.3f\t  %s\r\n', GW_REVAP ,'| GW_REVAP : Groundwater "revap" coefficient');
    elseif L==8 && par_f(strcmp(symbol, 'REVEP_MN'))==1
        REVEP_MN    = x(strcmp(symbol, 'REVEP_MN'));
        fprintf(fid2,'%16.3f\t  %s\r\n', REVEP_MN,'| REVAPMN: Threshold depth of water in the shallow aquifer for "revap" to occur [mm]');
    elseif L==9 && par_f(strcmp(symbol, 'RCHRG_DP'))==1
        RCHRG_DP    = x(strcmp(symbol, 'RCHRG_DP'));
        fprintf(fid2,'%16.3f\t  %s\r\n', RCHRG_DP ,'| RCHRG_DP : Deep aquifer percolation fraction');
    elseif L==10 && par_f(strcmp(symbol, 'GWHT'))==1
        GWHT        = x(strcmp(symbol, 'GWHT'));
        fprintf(fid2,'%16.3f\t  %s\r\n', GWHT ,'| GWHT : Initial groundwater height [m]');
    elseif L==11 && par_f(strcmp(symbol, 'GW_SPYLD'))==1
        GW_SPYLD    = x(strcmp(symbol, 'GW_SPYLD'));
        GW_SPYLD=str2double(strtok(line))*(1+GW_SPYLD);
        fprintf(fid2,'%16.3f\t  %s\r\n', GW_SPYLD ,'| GW_SPYLD : Specific yield of the shallow aquifer [m3/m3]');
    elseif L==12 && par_f(strcmp(symbol, 'SHALLST_N'))==1
        SHALLST_N    = x(strcmp(symbol, 'SHALLST_N'));
        fprintf(fid2,'%16.3f\t  %s\r\n', SHALLST_N ,'| SHALLST_N : Initial concentration of nitrate in shallow aq');
    elseif L==14 && par_f(strcmp(symbol, 'HLIFE_NGW'))==1
        HLIFE_NGW    = x(strcmp(symbol, 'HLIFE_NGW'));
        HLIFE_NGW=str2double(strtok(line))*(1+HLIFE_NGW);
        fprintf(fid2,'%16.3f\t  %s\r\n', HLIFE_NGW ,'| HLIFE_NGW : Ha;f-life of nitrate in the shallow aquifer [d');
    else
        fprintf(fid2,'%s',line); 
    end
end
fclose(fid1);
fclose(fid2);
return;