function bsn(par_n, par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path)

file_read = [sensin_path '\basins.bsn'];
file_write = [out_data_path '\basins.bsn'];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==4 && par_f(strcmp(symbol, 'SFTMP'))==1;
%         SFTMP=x(strcmp(symbol, 'SFTMP'));
        SFTMP=par_value(x, line, alter_m, lba, uba, symbol, 'SFTMP');
        fprintf(fid2,'%16.3f    %s\r\n',SFTMP,'| SFTMP : Snowfall temperature [oC]');
        
    elseif L==5 && par_f(strcmp(symbol, 'SMTMP'))==1;
%         SMTMP=x(strcmp(symbol, 'SFTMP'));
        SMTMP=par_value(x, line, alter_m, lba, uba, symbol, 'SMTMP');
        fprintf(fid2,'%16.3f    %s\r\n', SMTMP ,'| SMTMP : Snow melt base temperature [oC]');
        
    elseif L==6 && par_f(strcmp(symbol, 'SMFMX'))==1;
%         SMFMX   = x(strcmp(symbol, 'SMFMX'));
        SMFMX=par_value(x, line, alter_m, lba, uba, symbol, 'SMFMX');
        fprintf(fid2,'%16.3f    %s\r\n', SMFMX ,'| SMFMX : Melt factor for snow on June 21 [mm H2O/oC-day]');
        
    elseif L==7 && par_f(strcmp(symbol, 'SMFMN'))==1;
%         SMFMN   = x(strcmp(symbol, 'SMFMN'));
        SMFMN=par_value(x, line, alter_m, lba, uba, symbol, 'SMFMN');
        if par_f(strcmp(symbol, 'SMFMX'))==1 && SMFMN > SMFMX
            SMFMN = SMFMX;
        end
        fprintf(fid2,'%16.3f    %s\r\n', SMFMN ,'| SMFMN : Melt factor for snow on December 21 [mm H2O/oC-day]');
        
    elseif L==8 && par_f(strcmp(symbol, 'TIMP'))==1;
%         TIMP   = x(strcmp(symbol, 'TIMP'));
        TIMP=par_value(x, line, alter_m, lba, uba, symbol, 'TIMP');
        fprintf(fid2,'%16.3f    %s\r\n', TIMP ,'| TIMP : Snow pack temperature lag factor');
        
    elseif L==9 && par_f(strcmp(symbol, 'SNOCOVMX'))==1;
%         SNOCOVMX   = x(strcmp(symbol, 'SNOCOVMX'));
        SNOCOVMX=par_value(x, line, alter_m, lba, uba, symbol, 'SNOCOVMX');
        fprintf(fid2,'%16.3f    %s\r\n', SNOCOVMX ,'| SNOCOVMX : Minimum snow water content that corresponds to 100% snow cover [mm]');
        
    elseif L==10 && par_f(strcmp(symbol, 'SNO50COV'))==1;
%         SNO50COV   = x(strcmp(symbol, 'SNO50COV'));
        SNO50COV=par_value(x, line, alter_m, lba, uba, symbol, 'SNO50COV');
        fprintf(fid2,'%16.3f    %s\r\n', SNO50COV ,'| SNO50COV : Fraction of snow volume represented by SNOCOVMX that corresponds to 50% snow cover');        
      
    elseif L==15 && par_f(strcmp(symbol, 'EVLAI'))==1;
%         EVLAI   = x(strcmp(symbol, 'EVLAI'));
%         EVLAI=str2double(strtok(line))*(1+EVLAI);
        EVLAI=par_value(x, line, alter_m, lba, uba, symbol, 'EVLAI');
        fprintf(fid2,'%16.3f    %s\r\n', EVLAI ,'| EVLAI : Leaf area index at which no evaporation occurs from water surface [m2/m2]');
        
    elseif L==20 && par_f(strcmp(symbol, 'SURLAG'))==1;
%         SURLAG   = x(strcmp(symbol, 'SURLAG'));
        SURLAG=par_value(x, line, alter_m, lba, uba, symbol, 'SURLAG');
        fprintf(fid2,'%16.3f    %s\r\n', SURLAG ,'| SURLAG : Surface runoff lag time [days]');
        
    elseif L==21 && par_f(strcmp(symbol, 'ADJ_PKR'))==1;
%         ADJ_PKR   = x(strcmp(symbol, 'ADJ_PKR'));
        ADJ_PKR=par_value(x, line, alter_m, lba, uba, symbol, 'ADJ_PKR');
        fprintf(fid2,'%16.3f    %s\r\n', ADJ_PKR ,'| ADJ_PKR : Peak rate adjustment factor for sediment routing in the subbasin (tributary channels)');
        
    elseif L==22 && par_f(strcmp(symbol, 'PRF_BSN'))==1;
%         PRF_BSN   = x(strcmp(symbol, 'PRF_BSN'));
        PRF_BSN=par_value(x, line, alter_m, lba, uba, symbol, 'PRF_BSN');
        fprintf(fid2,'%16.3f    %s\r\n', PRF_BSN ,'| PRF_BSN : Peak rate adjustment factor for sediment routing in the main channel');
        
    elseif L==23 && par_f(strcmp(symbol, 'SPCON'))==1;
%         SPCON   = x(strcmp(symbol, 'SPCON'));
        SPCON=par_value(x, line, alter_m, lba, uba, symbol, 'SPCON');
        fprintf(fid2,'%16.3f    %s\r\n', SPCON ,'| SPCON : Linear parameter for calculating the maximum amount of sediment that can be reentrained during channel sediment routing');
        
    elseif L==24 && par_f(strcmp(symbol, 'SPEXP'))==1;
%         SPEXP   = x(strcmp(symbol, 'SPEXP'));
        SPEXP=par_value(x, line, alter_m, lba, uba, symbol, 'SPEXP');
        fprintf(fid2,'%16.3f    %s\r\n', SPEXP ,'| SPEXP : Exponent parameter for calculating sediment reentrained in channel sediment routing');
        
    elseif L==26 && par_f(strcmp(symbol, 'RCN'))==1;
%         RCN   = x(strcmp(symbol, 'RCN'));
        RCN=par_value(x, line, alter_m, lba, uba, symbol, 'RCN');
        fprintf(fid2,'%16.3f    %s\r\n', RCN,'| RCN: Concentration of nitrogen in rainfall (ppm)');
        
    elseif L==27 && par_f(strcmp(symbol, 'CMN'))==1;
%         CMN   = x(strcmp(symbol, 'CMN'));
        CMN=par_value(x, line, alter_m, lba, uba, symbol, 'CMN');
        fprintf(fid2,'%16.3f    %s\r\n', CMN ,'| CMN : Rate factor for humus mineralization of active organic nitrogen');
        
    elseif L==28 && par_f(strcmp(symbol, 'N_UPDIS'))==1;
%         N_UPDIS   = x(strcmp(symbol, 'N_UPDIS'));
        N_UPDIS=par_value(x, line, alter_m, lba, uba, symbol, 'N_UPDIS');
        fprintf(fid2,'%16.3f    %s\r\n', N_UPDIS ,'| N_UPDIS : Nitrogen uptake distribution parameter');
        
    elseif L==30 && par_f(strcmp(symbol, 'NPERCO'))==1;
%         NPERCO   = x(strcmp(symbol, 'NPERCO'));
        NPERCO=par_value(x, line, alter_m, lba, uba, symbol, 'NPERCO');
        fprintf(fid2,'%16.3f    %s\r\n', NPERCO ,'| NPERCO : Nitrogen percolation coefficient');
        
    elseif L==31 && par_f(strcmp(symbol, 'PPERCO'))==1;
%         PPERCO   = x(strcmp(symbol, 'PPERCO'));
        PPERCO=par_value(x, line, alter_m, lba, uba, symbol, 'PPERCO');
        fprintf(fid2,'%16.3f    %s\r\n', PPERCO ,'| PPERCO : Phosphorus percolation coefficient');
        
    elseif L==32 && par_f(strcmp(symbol, 'PHOSKD'))==1;
%         PHOSKD   = x(strcmp(symbol, 'PHOSKD'));
        PHOSKD=par_value(x, line, alter_m, lba, uba, symbol, 'PHOSKD');
        fprintf(fid2,'%16.3f    %s\r\n', PHOSKD ,'| PHOSKD : Phosphorus soil partitioning coefficient');
        
    elseif L==33 && par_f(strcmp(symbol, 'PSP'))==1;
%         PSP   = x(strcmp(symbol, 'PSP'));
        PSP=par_value(x, line, alter_m, lba, uba, symbol, 'PSP');
        fprintf(fid2,'%16.3f    %s\r\n', PSP ,'| PSP : Phosphorus sorption coefficient');
        
    elseif L==34 && par_f(strcmp(symbol, 'RSDCO'))==1;
%         RSDCO   = x(strcmp(symbol, 'RSDCO'));
        RSDCO=par_value(x, line, alter_m, lba, uba, symbol, 'RSDCO');
        fprintf(fid2,'%16.3f    %s\r\n', RSDCO ,'| RSDCO : Residue decomposition coefficient');
        
    elseif L==36 && par_f(strcmp(symbol, 'PERCOP'))==1;
%         PERCOP   = x(strcmp(symbol, 'PERCOP'));
        PERCOP=par_value(x, line, alter_m, lba, uba, symbol, 'PERCOP');
        fprintf(fid2,'%16.3f    %s\r\n', PERCOP ,'| PERCOP : Pesticide percolation coefficient');
        
    elseif L==59 && par_f(strcmp(symbol, 'MSK_CO1'))==1;
%         MSK_CO1   = x(strcmp(symbol, 'MSK_CO1'));
        MSK_CO1=par_value(x, line, alter_m, lba, uba, symbol, 'MSK_CO1');
        fprintf(fid2,'%16.3f    %s\r\n', MSK_CO1 ,'| MSK_CO1 : Calibration coefficient used to control impact of the storage time constant (Km) for normal flow');
        
    elseif L==60 && par_f(strcmp(symbol, 'MSK_CO2'))==1;
%         MSK_CO2   = x(strcmp(symbol, 'MSK_CO2'));
        MSK_CO2=par_value(x, line, alter_m, lba, uba, symbol, 'MSK_CO2');
        fprintf(fid2,'%16.3f    %s\r\n', MSK_CO2 ,'| MSK_CO2 : Calibration coefficient used to control impact of the storage time constant (Km) for low flow');
        
    elseif L==61 && par_f(strcmp(symbol, 'MSK_X'))==1;
%         MSK_X   = x(strcmp(symbol, 'MSK_X'));
        MSK_X=par_value(x, line, alter_m, lba, uba, symbol, 'MSK_X');
        fprintf(fid2,'%16.3f    %s\r\n', MSK_X ,'| MSK_X : Weighting factor controlling relative importance of inflow rate and outflow rate in determining water storage in reach segment');
        
    elseif L==66 && par_f(strcmp(symbol, 'EVRCH'))==1;
%         EVRCH   = x(strcmp(symbol, 'EVRCH'));
        EVRCH=par_value(x, line, alter_m, lba, uba, symbol, 'EVRCH');
        fprintf(fid2,'%16.3f    %s\r\n', EVRCH ,'| EVRCH : Reach evaporation adjustment factor');
        
    elseif L==68 && par_f(strcmp(symbol, 'ICN'))==1;
%         ICN   = x(strcmp(symbol, 'ICN'));
        ICN=par_value(x, line, alter_m, lba, uba, symbol, 'ICN');
        fprintf(fid2,'%16.3f    %s\r\n', ICN,'| ICN : Daily curve number calculation method');
        
    elseif L==69 && par_f(strcmp(symbol, 'CNCOEF'))==1;
%         CNCOEF   = x(strcmp(symbol, 'CNCOEF'));
        CNCOEF=par_value(x, line, alter_m, lba, uba, symbol, 'CNCOEF');
        fprintf(fid2,'%16.3f    %s\r\n', CNCOEF,'| CNCOEF : Plant ET curve number coefficient');
        
    elseif L==70 && par_f(strcmp(symbol, 'CDN'))==1;
%         CDN   = x(strcmp(symbol, 'CDN'));
        CDN=par_value(x, line, alter_m, lba, uba, symbol, 'CDN');
        fprintf(fid2,'%16.3f    %s\r\n', CDN,'| CDN : Denitrification exponential rate coefficient');
        
    elseif L==71 && par_f(strcmp(symbol, 'SDNCO'))==1;
%         SDNCO   = x(strcmp(symbol, 'SDNCO'));
        SDNCO=par_value(x, line, alter_m, lba, uba, symbol, 'SDNCO');
        fprintf(fid2,'%16.3f    %s\r\n', SDNCO,'| SDNCO : Denitrification threshold water content');
        
    elseif L==81 && par_f(strcmp(symbol, 'DEPIMP_BSN'))==1;
%         DEPIMP_BSN   = x(strcmp(symbol, 'DEPIMP_BSN'));
        DEPIMP_BSN=par_value(x, line, alter_m, lba, uba, symbol, 'DEPIMP_BSN');
        fprintf(fid2,'%16.3f    %s\r\n', DEPIMP_BSN,'| DEPIMP_BSN : Depth to impervious layer for modeling perched water tables [mm]');
        
    elseif L==88 && par_f(strcmp(symbol, 'FIXCO'))==1;
%         FIXCO   = x(strcmp(symbol, 'FIXCO'));
        FIXCO=par_value(x, line, alter_m, lba, uba, symbol, 'FIXCO');
        fprintf(fid2,'%16.3f    %s\r\n', FIXCO,'| FIXCO : Nitrogen fixation coefficient');
        
    elseif L==89 && par_f(strcmp(symbol, 'NFIXMX'))==1;
%         NFIXMX   = x(strcmp(symbol, 'NFIXMX'));
        NFIXMX=par_value(x, line, alter_m, lba, uba, symbol, 'NFIXMX');
        fprintf(fid2,'%16.3f    %s\r\n', NFIXMX,'| NFIXMX : Maximum daily-n fixation [kg/ha]');
        
    elseif L==90 && par_f(strcmp(symbol, 'ANION_EXCL_BSN'))==1;
%         ANION_EXCL_BSN   = x(strcmp(symbol, 'ANION_EXCL_BSN'));
        ANION_EXCL_BSN=par_value(x, line, alter_m, lba, uba, symbol, 'ANION_EXCL_BSN');
        fprintf(fid2,'%16.3f    %s\r\n', ANION_EXCL_BSN,'| ANION_EXCL_BSN : Fraction of porosity from which anions are excluded');
    else
        fprintf(fid2,'%s',line);
        
    end
end
fclose(fid1);
fclose(fid2);
return;