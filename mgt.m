function mgt(hruid, hru_lnd, Soil_type, par_n, par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path) %#ok<INUSL,INUSL>
hruid=char(hruid);
hru_str=[hruid '.mgt'];

if or(isequal(lower(hru_lnd), 'row crops'), isequal(lower(hru_lnd), 'pasture/hay')), is_Agri = 'YES';
else is_Agri = 'NO'; end
if or(Soil_type=='B',or (Soil_type=='C',Soil_type=='D')), is_B_C_or_D_soil_group = 'YES';
else is_B_C_or_D_soil_group = 'NO';end

file_read  = [sensin_path '\' hru_str];
file_write = [out_data_path '\' hru_str];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'wb');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    
    if L==10 && par_f(strcmp(symbol, 'BIOMIX'))==1
%         BIOMIX  = x(strcmp(symbol, 'BIOMIX'));
        BIOMIX=par_value(x, line, alter_m, lba, uba, symbol, 'BIOMIX');
        fprintf(fid2,'%16.3f    %s\r\n',BIOMIX,'| BIOMIX: Biological mixing efficiency');
        
    elseif L==11 && par_f(strcmp(symbol, 'CN2'))==1
%         CN2_f   = x(strcmp(symbol, 'CN_F'));
%         CN2=str2double(strtok(line))*(1+CN2_f);
        CN2=par_value(x, line, alter_m, lba, uba, symbol, 'CN2');
        fprintf(fid2,'%16.3f    %s\r\n',CN2,'| CN2: Initial SCS CN II value');
        
    elseif L==12 && isequal(hru_lnd, 'Row Crops') && par_f(strcmp(symbol, 'USLE_P'))==1
%         USLE_P  = x(strcmp(symbol, 'USLE_P'));
        USLE_P=par_value(x, line, alter_m, lba, uba, symbol, 'USLE_P');
        fprintf(fid2,'%16.3f    %s\r\n',USLE_P,'|  USLE_P: USLE support practice factor');
        
    elseif L==13 && par_f(strcmp(symbol, 'BIOMIN'))==1
%         BIOMIN  = x(strcmp(symbol, 'BIOMIN'));
        BIOMIN=par_value(x, line, alter_m, lba, uba, symbol, 'BIOMIN');
        fprintf(fid2,'%16.3f    %s\r\n',BIOMIN,'| BIO_MIN: Minimum biomass for grazing (kg/ha)');
        
    elseif L==14 && par_f(strcmp(symbol, 'FILTERW'))==1
%         FILTERW = x(strcmp(symbol, 'FILTERW'));
        FILTERW=par_value(x, line, alter_m, lba, uba, symbol, 'FILTERW');
        fprintf(fid2,'%16.3f    %s\r\n',FILTERW,'| FILTERW: width of edge of field filter strip (m)');
        
    elseif L==25 && (isequal(is_Agri,'YES') && isequal(is_B_C_or_D_soil_group,'YES')) && ...
            par_f(strcmp(symbol, 'DDRAIN'))==1
%         DDRAIN  = x(strcmp(symbol, 'DDRAIN'));
        DDRAIN=par_value(x, line, alter_m, lba, uba, symbol, 'DDRAIN');
        fprintf(fid2,'%16.3f    %s\r\n',DDRAIN,'| DDRAIN: depth to subsurface tile drain (mm)');
        
    elseif L==26 && (isequal(is_Agri,'YES') && isequal(is_B_C_or_D_soil_group,'YES')) && ...
            par_f(strcmp(symbol, 'TDRAIN'))==1
%         TDRAIN  = x(strcmp(symbol, 'TDRAIN'));
        TDRAIN=par_value(x, line, alter_m, lba, uba, symbol, 'TDRAIN');
        fprintf(fid2,'%16.3f    %s\r\n',TDRAIN,'| TDRAIN: time to drain soil to field capacity (hr)');
        
    elseif L==27 && (isequal(is_Agri,'YES') && isequal(is_B_C_or_D_soil_group,'YES')) && ...
            par_f(strcmp(symbol, 'GDRAIN'))==1
%         GDRAIN  = x(strcmp(symbol, 'GDRAIN'));
        GDRAIN=par_value(x, line, alter_m, lba, uba, symbol, 'GDRAIN');
        fprintf(fid2,'%16.3f    %s\r\n',GDRAIN,'| GDRAIN: drain tile lag time (hr)');
        
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);
return;