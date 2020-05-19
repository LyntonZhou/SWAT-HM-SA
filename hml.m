function hml(hruid, hru_lnd, par_n, par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path)
hruid=char(hruid);
hru_str=[hruid '.hml'];

file_read  = [sensin_path '\' hru_str];
file_write = [out_data_path '\' hru_str];
delete(file_write);
fid1=fopen(file_read, 'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==4 && par_f(strcmp(symbol, 'HML_AREA_FRA'))==1
        HML_Area_fra=par_value(x, line, alter_m, lba, uba, symbol, 'HML_AREA_FRA');
        fprintf(fid2,'%14.3f    %s\r\n', HML_Area_fra ,'| HML_Area_fra : Heavy metal Nonpoint source Area Fraction [-]');
        
    elseif L==5 && par_f(strcmp(symbol, 'HML_ROCK'))==1
        HML_Rock=par_value(x, line, alter_m, lba, uba, symbol, 'HML_ROCK');
        fprintf(fid2,'%14.3f    %s\r\n', HML_Rock ,'| HML_Rock : Heavy metal in Rock [kg/ha]');
        
    elseif L==6 && par_f(strcmp(symbol, 'SOL_HM_LABCONC'))==1
        SOL_HM_LabConc=par_value(x, line, alter_m, lba, uba, symbol, 'SOL_HM_LABCONC');
        fprintf(fid2,'%14.3f    %s\r\n', SOL_HM_LabConc ,'| SOL_HM_LabConc : Labile metal in 1st layer soil [mg/kg]');
        
    elseif L==7 && par_f(strcmp(symbol, 'SOL_HM_NONLABCONC'))==1
        SOL_HM_NonlabConc=par_value(x, line, alter_m, lba, uba, symbol, 'SOL_HM_NONLABCONC');
        fprintf(fid2,'%14.3f    %s\r\n', SOL_HM_NonlabConc,'| SOL_HM_NonlabConc : Non-labile metal in 1st layer soil [mg/kg]');
        
    elseif L==8 && par_f(strcmp(symbol, 'HM_ENR'))==1
        HM_Enr=par_value(x, line, alter_m, lba, uba, symbol, 'HM_ENR');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Enr ,'| HM_Enr : Enrichment ratio of heavy metal [-]');
        
    elseif L==9 && par_f(strcmp(symbol, 'HM_AGR'))==1
        HM_Agr=par_value(x, line, alter_m, lba, uba, symbol, 'HM_AGR');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Agr ,'| HM_Agr : Total metal input from agricultural use [g/ha/yr]');
        
    elseif L==10 && par_f(strcmp(symbol, 'HM_AGR_FRA'))==1
        HM_Agr_fra=par_value(x, line, alter_m, lba, uba, symbol, 'HM_AGR_FRA');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Agr_fra ,'| HM_Agr_fra : Fraction of labile metal in fertilizers or animal manure [-]');
        
    elseif L==11 && par_f(strcmp(symbol, 'HM_ATMO'))==1
        HM_Atmo=par_value(x, line, alter_m, lba, uba, symbol, 'HM_ATMO');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Atmo ,'| HM_Atmo : Total metal input from atmospheric deposition [g/ha/yr]');
        
    elseif L==12 && par_f(strcmp(symbol, 'HM_ATMO_FRA'))==1
        HM_Atmo_fra=par_value(x, line, alter_m, lba, uba, symbol, 'HM_ATMO_FRA');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Atmo_fra ,'| HM_Atmo_fra : Fraction of labile metal in atmospheric deposition [-]');
        
    else
        fprintf(fid2,'%s',line); 
        
    end
end
fclose(fid1);
fclose(fid2);
return;