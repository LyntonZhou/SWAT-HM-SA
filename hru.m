function hru(hruid, hru_lnd, par_n, par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path)

hruid=char(hruid);
hru_str=[hruid '.hru'];

file_read = [sensin_path '\' hru_str];
file_write = [out_data_path '\' hru_str];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==3 && par_f(strcmp(symbol, 'SLSUBBSN'))==1;
%         SLSUBBSN = x(strcmp(symbol, 'SLSUBBSN'));
        SLSUBBSN=par_value(x, line, alter_m, lba, uba, symbol, 'SLSUBBSN');
        fprintf(fid2,'%16.3f    %s\r\n',SLSUBBSN,'| SLSUBBSN : Average slope length [m]');
        
    elseif L==4 && par_f(strcmp(symbol, 'SLOPE'))==1;
%         SLOPE    = x(strcmp(symbol, 'SLOPE'));
%         str1=strtok(line);
%         SLOPE=str2double(str1)*(1+SLOPE);
        SLOPE=par_value(x, line, alter_m, lba, uba, symbol, 'SLOPE');
        fprintf(fid2,'%16.3f    %s\r\n',SLOPE,'| HRU_SLP : Average slope stepness [m/m]');
        
    elseif L==5 && par_f(strcmp(symbol, 'OV_N'))==1;
%         OV_N     = x(strcmp(symbol, 'OV_N'));
        OV_N=par_value(x, line, alter_m, lba, uba, symbol, 'OV_N');
        fprintf(fid2,'%16.3f    %s\r\n',OV_N,'| OV_N : Manning"s "n" value for overland flow'); 
        
    elseif L==9 && par_f(strcmp(symbol, 'CANMX'))==1;
%         CANMX    = x(strcmp(symbol, 'CANMX'));
        CANMX=par_value(x, line, alter_m, lba, uba, symbol, 'CANMX');
        fprintf(fid2,'%16.3f    %s\r\n',CANMX,'| CANMX : Maximum canopy storage [mm]');
        
    elseif L==10 && par_f(strcmp(symbol, 'ESCO'))==1;
%         ESCO     = x(strcmp(symbol, 'ESCO'));
        ESCO=par_value(x, line, alter_m, lba, uba, symbol, 'ESCO');
        fprintf(fid2,'%16.3f    %s\r\n',ESCO,'| ESCO : Soil evaporation compensation factor'); 
        
    elseif L==12 && par_f(strcmp(symbol, 'RSDIN'))==1;
%         RSDIN    = x(strcmp(symbol, 'RSDIN'));
        RSDIN=par_value(x, line, alter_m, lba, uba, symbol, 'RSDIN');
        fprintf(fid2,'%16.3f    %s\r\n',RSDIN,'| RSDIN : Initial residue cover [kg/ha]'); 
        
    elseif L==24 && par_f(strcmp(symbol, 'DEP_IMP'))==1;
%         DEP_IMP  = x(strcmp(symbol, 'DEP_IMP'));
        DEP_IMP=par_value(x, line, alter_m, lba, uba, symbol, 'DEP_IMP');
        fprintf(fid2,'%16.3f    %s\r\n',DEP_IMP,'| DEP_IMP : Depth to impervious layer in soil profile [mm]'); 
%     elseif L==15 && par_f(cellfun(@(x) isequal(x, 'POT_FR'), symbol))==1;
%         fprintf(fid2,'%16.3f    %s\n',POT_FR,'| POT_FR : Fraction of HRU are that drains into pothole'); 
%     elseif L==19 && par_f(cellfun(@(x) isequal(x, 'POT_TILE'), symbol))==1;
%         fprintf(fid2,'%16.3f    %s\n',POT_TILE,'| POT_TILE : Average daily outflow to main channel from tile flow (depth [mm] over entire HRU)'); 
%     elseif L==20 && par_f(cellfun(@(x) isequal(x, 'POT_VOLX'), symbol))==1;
%         fprintf(fid2,'%16.3f    %s\n',POT_VOLX,'| POT_VOLX : Maximum volume of water stored in the pothole (depth [mm] over entire HRU)'); 
%     elseif L==21 && par_f(cellfun(@(x) isequal(x, 'POT_VOL'), symbol))==1;
%         fprintf(fid2,'%16.3f    %s\n',POT_VOL,'| POT_VOL : Initial volume of water stored in the pothole (depth [mm] over entire HRU)'); 
%     elseif L==23 && par_f(cellfun(@(x) isequal(x, 'POT_NO3L'), symbol))==1;
%         fprintf(fid2,'%16.3f    %s\n',POT_NO3L,'| POT_NO3L : Nitrate decay rate in pothole [1/day]'); 
%     elseif L==28 && par_f(cellfun(@(x) isequal(x, 'EVPOT'), symbol))==1;
%         fprintf(fid2,'%16.3f    %s\n',EVPOT,'| EVPOT: Pothole evaporation coefficient');
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);
return;