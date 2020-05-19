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
    if L==3 && par_f(strcmp(symbol, 'HM_Num'))==1
        HM_Num=par_value(x, line, alter_m, lba, uba, symbol, 'HM_Num');
        fprintf(fid2,'%14i    %s\r\n', HM_Num ,'| HM_Num : Metal number [#]');
        
    elseif L==4 && par_f(strcmp(symbol, 'HML_Area_fra'))==1
        HML_Area_fra=par_value(x, line, alter_m, lba, uba, symbol, 'HML_Area_fra');
        fprintf(fid2,'%14.3f    %s\r\n', HML_Area_fra ,'| HML_Area_fra : Heavy metal Nonpoint source Area Fraction [-]');
        
    elseif L==5 && par_f(strcmp(symbol, 'HML_Rock'))==1
        HML_Rock=par_value(x, line, alter_m, lba, uba, symbol, 'HML_Rock');
        fprintf(fid2,'%14.3f    %s\r\n', HML_Rock ,'| HML_Rock : Heavy metal in Rock [kg/ha]');
        
    elseif L==6 && par_f(strcmp(symbol, 'SOL_HM_LabConc'))==1
        SOL_HM_LabConc=par_value(x, line, alter_m, lba, uba, symbol, 'SOL_HM_LabConc');
        fprintf(fid2,'%14.3f    %s\r\n', SOL_HM_LabConc ,'| SOL_HM_LabConc : Labile metal in 1st layer soil [mg/kg]');
        
    elseif L==7 && par_f(strcmp(symbol, 'SOL_HM_NonlabConc'))==1
        SOL_HM_NonlabConc=par_value(x, line, alter_m, lba, uba, symbol, 'SOL_HM_NonlabConc');
        fprintf(fid2,'%14.3f    %s\r\n', SOL_HM_NonlabConc,'| SOL_HM_NonlabConc : Non-labile metal in 1st layer soil [mg/kg]');
        
    elseif L==8 && par_f(strcmp(symbol, 'HM_Enr'))==1
        HM_Enr=par_value(x, line, alter_m, lba, uba, symbol, 'HM_Enr');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Enr ,'| HM_Enr : Enrichment ratio of heavy metal [-]');
        
    elseif L==9 && par_f(strcmp(symbol, 'HM_Agr'))==1
        HM_Agr=par_value(x, line, alter_m, lba, uba, symbol, 'HM_Agr');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Agr ,'| HM_Agr : Total metal input from agricultural use [g/ha/yr]');
        
    elseif L==10 && par_f(strcmp(symbol, 'HM_Agr_fra'))==1
        HM_Agr_fra=par_value(x, line, alter_m, lba, uba, symbol, 'HM_Agr_fra');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Agr_fra ,'| HM_Agr_fra : Fraction of labile metal in fertilizers or animal manure [-]');
        
    elseif L==11 && par_f(strcmp(symbol, 'HM_Atmo'))==1
        HM_Atmo=par_value(x, line, alter_m, lba, uba, symbol, 'HM_Atmo');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Atmo ,'| HM_Atmo : Total metal input from atmospheric deposition [g/ha/yr]');
        
    elseif L==12 && par_f(strcmp(symbol, 'HM_Atmo_fra'))==1
        HM_Atmo_fra=par_value(x, line, alter_m, lba, uba, symbol, 'HM_Atmo_fra');
        fprintf(fid2,'%14.3f    %s\r\n', HM_Atmo_fra ,'| HM_Atmo_fra : Fraction of labile metal in atmospheric deposition [-]');
        
    else
        fprintf(fid2,'%s',line); 
        
    end
end
fclose(fid1);
fclose(fid2);
return;