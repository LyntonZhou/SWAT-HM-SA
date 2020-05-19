function swq(subid, par_n, par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path)
% swq is stream water quality input files

subid=char(subid);
subid=[subid '.swq'];

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==3 && par_f(strcmp(symbol,'RS1'))==1;
        %         RS1 = x(strcmp(symbol,'RS1'));
        RS1=par_value(x, line, alter_m, lba, uba, symbol, 'RS1');
        fprintf(fid2,'%16.3f    %s\r\n',RS1,'| RS1:   Local algal settling rate in the reach at 20ºC [m/day]');
        
    elseif L==4 && par_f(strcmp(symbol,'RS2'))==1;
        %         RS2 = x(strcmp(symbol,'RS2'));
        RS2=par_value(x, line, alter_m, lba, uba, symbol, 'RS2');
        fprintf(fid2,'%16.3f    %s\r\n',RS2,'| RS2:   Benthic (sediment) source rate for dissolved phosphorus in the reach at 20ºC [mg dissolved P/[m2·day]]');
        
    elseif L==5 && par_f(strcmp(symbol,'RS3'))==1;
        %         RS3 = x(strcmp(symbol,'RS3'));
        RS3=par_value(x, line, alter_m, lba, uba, symbol, 'RS3');
        fprintf(fid2,'%16.3f    %s\r\n',RS3,'| RS3:   Benthic source rate for NH4-N in the reach at 20ºC [mg NH4-N/[m2·day]]');
        
    elseif L==6 && par_f(strcmp(symbol,'RS4'))==1;
        %         RS4 = x(strcmp(symbol,'RS4'));
        RS4=par_value(x, line, alter_m, lba, uba, symbol, 'RS4');
        fprintf(fid2,'%16.3f    %s\r\n',RS4,'| RS4:   Rate coefficient for organic N settling in the reach at 20ºC [day-1]');
        
    elseif L==7 && par_f(strcmp(symbol,'RS5'))==1;
        %         RS5 = x(strcmp(symbol,'RS5'));
        RS5=par_value(x, line, alter_m, lba, uba, symbol, 'RS5');
        fprintf(fid2,'%16.3f    %s\r\n',RS5,'| RS5:   Organic phosphorus settling rate in the reach at 20ºC [day-1]');
        
    elseif L==16 && par_f(strcmp(symbol,'BC1'))==1;
        %         BC1 = x(strcmp(symbol,'BC1'));
        BC1=par_value(x, line, alter_m, lba, uba, symbol, 'BC1');
        fprintf(fid2,'%16.3f    %s\r\n',BC1,'| BC1:   Rate constant for biological oxidation of NH4 to NO2 in the reach at 20?C [day-1]');
        
    elseif L==17 && par_f(strcmp(symbol,'BC2'))==1;
        %         BC2 = x(strcmp(symbol,'BC2'));
        BC2=par_value(x, line, alter_m, lba, uba, symbol, 'BC2');
        fprintf(fid2,'%16.3f    %s\r\n',BC2,'| BC2:   Rate constant for biological oxidation of NO2 to NO3 in the reach at 20?C [day-1]');
        
    elseif L==18 && par_f(strcmp(symbol,'BC3'))==1;
        %         BC3 = x(strcmp(symbol,'BC3'));
        BC3=par_value(x, line, alter_m, lba, uba, symbol, 'BC3');
        fprintf(fid2,'%16.3f    %s\r\n',BC3,'| BC3:   Rate constant for hydrolysis of organic N to NH4 in the reach at 20?C [day-1]');
        
    elseif L==19 && par_f(strcmp(symbol,'BC4'))==1;
        %         BC4 = x(strcmp(symbol,'BC4'));
        BC4=par_value(x, line, alter_m, lba, uba, symbol, 'BC4');
        fprintf(fid2,'%16.3f    %s\r\n',BC4,'| BC4:   Rate constant for mineralization of organic P to dissolved P in the reach at 20?C [day-1]');
        
    elseif L==21 && par_f(strcmp(symbol,'CHPST_REA'))==1;
        %         CHPST_REA = x(strcmp(symbol,'CHPST_REA'));
        CHPST_REA=par_value(x, line, alter_m, lba, uba, symbol, 'CHPST_REA');
        fprintf(fid2,'%16.8f    %s\r\n',CHPST_REA,'| CHPST_REA: Pesticide reaction coefficient in reach [day-1]');
        
    elseif L==22 && par_f(strcmp(symbol,'CHPST_VOL'))==1;
        %         CHPST_VOL = x(strcmp(symbol,'CHPST_VOL'));
        CHPST_VOL=par_value(x, line, alter_m, lba, uba, symbol, 'CHPST_VOL');
        fprintf(fid2,'%16.8f    %s\r\n',CHPST_VOL,'| CHPST_VOL: Pesticide volatilization coefficient in reach [m/day]');
        
    elseif L==23 && par_f(strcmp(symbol,'CHPST_KOC'))==1;
        %         CHPST_KOC = x(strcmp(symbol,'CHPST_KOC'));
        CHPST_KOC=par_value(x, line, alter_m, lba, uba, symbol, 'CHPST_KOC');
        fprintf(fid2,'%16.8f    %s\r\n',CHPST_KOC,'| CHPST_KOC: Pesticide partition coefficient between water and air in reach [m3/day]');
        
    elseif L==24 && par_f(strcmp(symbol,'CHPST_STL'))==1;
        %         CHPST_STL = x(strcmp(symbol,'CHPST_STL'));
        CHPST_STL=par_value(x, line, alter_m, lba, uba, symbol, 'CHPST_STL');
        fprintf(fid2,'%16.8f    %s\r\n',CHPST_STL,'| CHPST_STL: Settling velocity for pesticide sorbed to sediment [m/day]');
        
    elseif L==25 && par_f(strcmp(symbol,'CHPST_RSP'))==1;
        %         CHPST_RSP = x(strcmp(symbol,'CHPST_RSP'));
        CHPST_RSP=par_value(x, line, alter_m, lba, uba, symbol, 'CHPST_RSP');
        fprintf(fid2,'%16.3f    %s\r\n',CHPST_RSP,'| CHPST_RSP: Resuspension velocity for pesticide sorbed to sediment [m/day]');
        
    elseif L==26 && par_f(strcmp(symbol,'CHPST_MIX'))==1;
        %         CHPST_MIX = x(strcmp(symbol,'CHPST_MIX'));
        CHPST_MIX=par_value(x, line, alter_m, lba, uba, symbol, 'CHPST_MIX');
        fprintf(fid2,'%16.8f    %s\r\n',CHPST_MIX,'| CHPST_MIX: Mixing velocity (diffusion/dispersion) for pesticide in reach [m/day]');
        
    elseif L==27 && par_f(strcmp(symbol,'SEDPST_CONC'))==1;
        %         SEDPST_CONC = x(strcmp(symbol,'SEDPST_CONC'));
        SEDPST_CONC=par_value(x, line, alter_m, lba, uba, symbol, 'SEDPST_CONC');
        fprintf(fid2,'%16.8f    %s\r\n',SEDPST_CONC,'| SEDPST_CONC: Initial pesticide concentration in reach bed sediment [mg/m3 sediment]');
        
    elseif L==28 && par_f(strcmp(symbol,'SEDPST_REA'))==1;
        %         SEDPST_REA = x(strcmp(symbol,'SEDPST_REA'));
        SEDPST_REA=par_value(x, line, alter_m, lba, uba, symbol, 'SEDPST_REA');
        fprintf(fid2,'%16.8f    %s\r\n',SEDPST_REA,'| SEDPST_REA: Pesticide reaction coefficient in reach bed sediment [day-1]');
        
    elseif L==29 && par_f(strcmp(symbol,'SEDPST_BRY'))==1;
        %         SEDPST_BRY = x(strcmp(symbol,'SEDPST_BRY'));
        SEDPST_BRY=par_value(x, line, alter_m, lba, uba, symbol, 'SEDPST_BRY');
        fprintf(fid2,'%16.8f    %s\r\n',SEDPST_BRY,'| SEDPST_BRY: Pesticide burial velocity in reach bed sediment [m/day]');
        
    elseif L==30 && par_f(strcmp(symbol,'SEDPST_ACT'))==1;
        %         SEDPST_ACT = x(strcmp(symbol,'SEDPST_ACT'));
        SEDPST_ACT=par_value(x, line, alter_m, lba, uba, symbol, 'SEDPST_ACT');
        fprintf(fid2,'%16.8f    %s\r\n',SEDPST_ACT,'| SEDPST_ACT: Depth of active sediment layer for pesticide [m]');
    
    % below are for SWAT-HM parameters    
    elseif L==32 && par_f(strcmp(symbol,'CH_HM_STL'))==1;
        CH_HM_STL=par_value(x, line, alter_m, lba, uba, symbol, 'CH_HM_STL');
        fprintf(fid2,'%16.6f    %s\r\n',CH_HM_STL,'| CH_HM_STL : Settling velocity for Heavy Metal in reach [m/d]');
        
    elseif L==33 && par_f(strcmp(symbol,'CH_HM_RSP'))==1;
        CH_HM_RSP=par_value(x, line, alter_m, lba, uba, symbol, 'CH_HM_RSP');
        fprintf(fid2,'%16.6f    %s\r\n',CH_HM_RSP,'| CH_HM_RSP : Resuspension velocity for Heavy Metal in reach [m/d]');
        
    elseif L==34 && par_f(strcmp(symbol,'CH_HM_MIX'))==1;
        CH_HM_MIX=par_value(x, line, alter_m, lba, uba, symbol, 'CH_HM_MIX');
        fprintf(fid2,'%16.6f    %s\r\n',CH_HM_MIX,'| CH_HM_MIX : Mixing velocity for Heavy Metal in reach [m/d]');
        
    elseif L==35 && par_f(strcmp(symbol,'CH_HM_BRY'))==1;
        CH_HM_BRY=par_value(x, line, alter_m, lba, uba, symbol, 'CH_HM_BRY');
        fprintf(fid2,'%16.6f    %s\r\n',CH_HM_BRY,'| CH_HM_BRY : Burial velocity for Heavy Metal in reach [m/d]');
        
    elseif L==36 && par_f(strcmp(symbol,'CH_HM_LABCONC'))==1;
        CH_HM_LabCONC=par_value(x, line, alter_m, lba, uba, symbol, 'CH_HM_LABCONC');
        fprintf(fid2,'%16.6f    %s\r\n',CH_HM_LabCONC,'| CH_HM_LabCONC : Initial HM concentration in reach bed sediment [kg/m3]');
        
    elseif L==37 && par_f(strcmp(symbol,'CH_HM_NONLABCONC'))==1;
        CH_HM_NonlabCONC=par_value(x, line, alter_m, lba, uba, symbol, 'CH_HM_NONLABCONC');
        fprintf(fid2,'%16.6f    %s\r\n',CH_HM_NonlabCONC,'| CH_HM_NonlabCONC : Initial HM concentration in reach bed sediment [kg/m3]');
        
    elseif L==38 && par_f(strcmp(symbol,'CH_HM_ACT'))==1;
        CH_HM_ACT=par_value(x, line, alter_m, lba, uba, symbol, 'CH_HM_ACT');
        fprintf(fid2,'%16.6f    %s\r\n',CH_HM_ACT,'| CH_HM_ACT : Depth of active sediment layer for heavy metal [m]');
        
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;