function mgt_f(hruid,hru_lnd,Soil_type,par_n,par_f,symbol,x, sensin_path, out_data_path) %#ok<INUSL,INUSL>
hruid=char(hruid);
hru_str=[hruid '.mgt'];

if or(isequal(lower(hru_lnd), 'row crops'), isequal(lower(hru_lnd), 'pasture/hay')), is_Agri = 'YES';
else is_Agri = 'NO'; end
if or(Soil_type=='B',or (Soil_type=='C',Soil_type=='D')), is_B_C_or_D_soil_group = 'YES';
else is_B_C_or_D_soil_group = 'NO';end

BIOMIX  = x(cellfun(@(x) isequal(x, 'BIOMIX'), symbol));
CN2_f   = x(cellfun(@(x) isequal(x, 'CN_F'), symbol));
USLE_P  = x(cellfun(@(x) isequal(x, 'USLE_P'), symbol));
BIOMIN  = x(cellfun(@(x) isequal(x, 'BIOMIN'), symbol));
FILTERW = x(cellfun(@(x) isequal(x, 'FILTERW'), symbol));
DDRAIN  = x(cellfun(@(x) isequal(x, 'DDRAIN'), symbol));
TDRAIN  = x(cellfun(@(x) isequal(x, 'TDRAIN'), symbol));
GDRAIN  = x(cellfun(@(x) isequal(x, 'GDRAIN'), symbol));

file_read  = [sensin_path '\' hru_str];
file_write = [out_data_path '\' hru_str];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'wb');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    
    if L==10 && par_f(cellfun(@(x) isequal(x, 'BIOMIX'), symbol))==1
        fprintf(fid2,'%16.3f\t  %s\n',BIOMIX,'| BIOMIX: Biological mixing efficiency');
    elseif L==11 && par_f(cellfun(@(x) isequal(x, 'CN_F'), symbol))==1
        CN2=str2double(strtok(line))*(1+CN2_f);
        fprintf(fid2,'%16.3f\t  %s\n',CN2,'| CN2: Initial SCS CN II value');
    elseif L==12 && isequal(hru_lnd, 'Row Crops') && par_f(cellfun(@(x) isequal(x, 'USLE_P'), symbol))==1
        fprintf(fid2,'%16.3f\t  %s\n',USLE_P,'|  USLE_P: USLE support practice factor');
    elseif L==13 && par_f(cellfun(@(x) isequal(x, 'BIOMIN'), symbol))==1
        fprintf(fid2,'%16.3f\t  %s\n',BIOMIN,'| BIO_MIN: Minimum biomass for grazing (kg/ha)');
    elseif L==14 && par_f(cellfun(@(x) isequal(x, 'FILTERW'), symbol))==1
        fprintf(fid2,'%16.3f\t  %s\n',FILTERW,'| FILTERW: width of edge of field filter strip (m)');
    elseif L==25 && (isequal(is_Agri,'YES') && isequal(is_B_C_or_D_soil_group,'YES')) && ...
            par_f(cellfun(@(x) isequal(x, 'DDRAIN'), symbol))==1
        fprintf(fid2,'%16.3f\t  %s\n',DDRAIN,'| DDRAIN: depth to subsurface tile drain (mm)');
    elseif L==26 && (isequal(is_Agri,'YES') && isequal(is_B_C_or_D_soil_group,'YES')) && ...
            par_f(cellfun(@(x) isequal(x, 'TDRAIN'), symbol))==1
        fprintf(fid2,'%16.3f\t  %s\n',TDRAIN,'| TDRAIN: time to drain soil to field capacity (hr)');
    elseif L==27 && (isequal(is_Agri,'YES') && isequal(is_B_C_or_D_soil_group,'YES')) && ...
            par_f(cellfun(@(x) isequal(x, 'GDRAIN'), symbol))==1
        fprintf(fid2,'%16.3f\t  %s\n',GDRAIN,'| GDRAIN: drain tile lag time (hr)');
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);
return;