function lwq(par_f , symbol, x, alter_m, lba, uba, sensin_path, out_data_path,ReservoirSubNumber)
% lwq is laker water quality input files

if ReservoirSubNumber < 10
    sub_zeros = '0000';
elseif ReservoirSubNumber >= 10 && ReservoirSubNumber < 100
    sub_zeros = '000';
elseif ReservoirSubNumber >= 100 && ReservoirSubNumber < 1000
    sub_zeros = '00';
elseif ReservoirSubNumber >= 1000 && ReservoirSubNumber < 10000
    sub_zeros = '0';
elseif ReservoirSubNumber >= 10000
    sub_zeros = '';
end
subid = [sub_zeros int2str(ReservoirSubNumber) '0000'];
subid=[subid '.lwq'];

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==3 && par_f(strcmp(symbol,'IRES1'))==1;
%         IRES1       = x(strcmp(symbol,'IRES1'));
        IRES1=par_value(x, line, alter_m, lba, uba, symbol, 'IRES1');
        fprintf(fid2,'%16i    %s\r\n',IRES1,'| IRES1 : Beginning month of mid-year nutrient settling period');
        
    elseif L==4 && par_f(strcmp(symbol,'IRES2'))==1;
%         IRES2       = x(strcmp(symbol,'IRES2'));
        IRES2=par_value(x, line, alter_m, lba, uba, symbol, 'IRES2');
        fprintf(fid2,'%16i    %s\r\n',IRES2,'| IRES2 : Ending month of mid-year nutrient settling period');
        
    elseif L==5 && par_f(strcmp(symbol,'PSETLR1'))==1;
%         PSETLR1     = x(strcmp(symbol,'PSETLR1'));
        PSETLR1=par_value(x, line, alter_m, lba, uba, symbol, 'PSETLR1');
        fprintf(fid2,'%16.3f    %s\r\n',PSETLR1,'| PSETLR1 : Phosphorus settling rate in reservoir for months IRES1 through IRES2 [m/year]');
        
    elseif L==6 && par_f(strcmp(symbol,'PSETLR2'))==1;
%         PSETLR2     = x(strcmp(symbol,'PSETLR2'));
        PSETLR2=par_value(x, line, alter_m, lba, uba, symbol, 'PSETLR2');
        fprintf(fid2,'%16.3f    %s\r\n',PSETLR2,'| PSETLR2 : Phosphorus settling rate in reservoir for months other than IRES1-IRES2 [m/year]');
        
    elseif L==7 && par_f(strcmp(symbol,'NSETLR1'))==1;
%         NSETLR1     = x(strcmp(symbol,'NSETLR1'));
        NSETLR1=par_value(x, line, alter_m, lba, uba, symbol, 'NSETLR1');
        fprintf(fid2,'%16.3f    %s\r\n',NSETLR1 ,'| NSETLR1 : Nitrogen settling rate in reservoir for months IRES1 through IRES2 [m/year]');
        
    elseif L==8 && par_f(strcmp(symbol,'NSETLR2'))==1;
%         NSETLR2     = x(strcmp(symbol,'NSETLR2'));
        NSETLR2=par_value(x, line, alter_m, lba, uba, symbol, 'NSETLR2');
        fprintf(fid2,'%16.3f    %s\r\n',NSETLR2,'| NSETLR2 : Nitrogen settling rate in reservoir for months other than IRES1-IRES2 [m/year]');
        
    elseif L==9 && par_f(strcmp(symbol,'CHLAR'))==1;
%         CHLAR       = x(strcmp(symbol,'CHLAR'));
        CHLAR=par_value(x, line, alter_m, lba, uba, symbol, 'CHLAR');
        fprintf(fid2,'%16.3f    %s\r\n',CHLAR,'| CHLAR : Chlorophyll a production coefficient for reservoir');
        
    elseif L==10 && par_f(strcmp(symbol,'SECCIR'))==1;
%         SECCIR      = x(strcmp(symbol,'SECCIR'));
        SECCIR=par_value(x, line, alter_m, lba, uba, symbol, 'SECCIR');
        fprintf(fid2,'%16.3f    %s\r\n',SECCIR,'| SECCIR : Water clarity coefficient for the reservoir');
        
    elseif L==11 && par_f(strcmp(symbol,'RES_ORGP'))==1;
%         RES_ORGP    = x(strcmp(symbol,'RES_ORGP'));
        RES_ORGP=par_value(x, line, alter_m, lba, uba, symbol, 'RES_ORGP');
        fprintf(fid2,'%16.3f    %s\r\n',RES_ORGP,'| RES_ORGP : Initial concentration of organic P in reservoir [mg P/l]');
        
    elseif L==12 && par_f(strcmp(symbol,'RES_SOLP'))==1;
%         RES_SOLP    = x(strcmp(symbol,'RES_SOLP'));
        RES_SOLP=par_value(x, line, alter_m, lba, uba, symbol, 'RES_SOLP');
        fprintf(fid2,'%16.3f    %s\r\n',RES_SOLP,'| RES_SOLP : Initial concentration of soluble P in reservoir [mg P/l]');
        
    elseif L==13 && par_f(strcmp(symbol,'RES_ORGN'))==1;
%         RES_ORGN    = x(strcmp(symbol,'RES_ORGN'));
        RES_ORGN=par_value(x, line, alter_m, lba, uba, symbol, 'RES_ORGN');
        fprintf(fid2,'%16.3f    %s\r\n',RES_ORGN,'| RES_ORGN : Initial concentration of organic N in reservoir [mg N/l]');
        
    elseif L==14 && par_f(strcmp(symbol,'RES_NO3'))==1;
%         RES_NO3     = x(strcmp(symbol,'RES_NO3'));
        RES_NO3=par_value(x, line, alter_m, lba, uba, symbol, 'RES_NO3');
        fprintf(fid2,'%16.3f    %s\r\n',RES_NO3,'| RES_NO3 : Initial concentration of NO3-N in reservoir [mg N/L]');
        
    elseif L==15 && par_f(strcmp(symbol,'RES_NH3'))==1;
%         RES_NH3     = x(strcmp(symbol,'RES_NH3'));
        RES_NH3=par_value(x, line, alter_m, lba, uba, symbol, 'RES_NH3');
        fprintf(fid2,'%16.3f    %s\r\n',RES_NH3,'| RES_NH3 : Initial concentration of NH3-N in reservoir [mg N/l]');
        
    elseif L==16 && par_f(strcmp(symbol,'RES_NO2'))==1;
%         RES_NO2     = x(strcmp(symbol,'RES_NO2'));
        RES_NO2=par_value(x, line, alter_m, lba, uba, symbol, 'RES_NO2');
        fprintf(fid2,'%16.3f    %s\r\n',RES_NO2,'| RES_NO2 : Initial concentration of NO2-N in reservoir [mg N/l]');
        
    elseif L==18 && par_f(strcmp(symbol,'LKPST_CONC'))==1;
%         LKPST_CONC  = x(strcmp(symbol,'LKPST_CONC'));
        LKPST_CONC=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_CONC');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_CONC,'| LKPST_CONC : Initial pesticide concentration in the lake water for the first pesticide listed in file.cio. While up to ten pesticides may be applied in a SWAT simulation, only one pesticide (the first one listed in the file.cio) is routed through the reach. (mg/m3)');
        
    elseif L==19 && par_f(strcmp(symbol,'LKPST_REA'))==1;
%         LKPST_REA   = x(strcmp(symbol,'LKPST_REA'));
        LKPST_REA=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_REA');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_REA,'| LKPST_REA : Reaction coefficient of the pesticide in lake water [day-1]');
        
    elseif L==20 && par_f(strcmp(symbol,'LKPST_VOL'))==1;
%         LKPST_VOL   = x(strcmp(symbol,'LKPST_VOL'));
        LKPST_VOL=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_VOL');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_VOL,'| LKPST_VOL : Volatilization coefficient of the pesticide from the lake water [m/day]');
        
    elseif L==21 && par_f(strcmp(symbol,'LKPST_KOC'))==1;
%         LKPST_KOC   = x(strcmp(symbol,'LKPST_KOC'));
        LKPST_KOC=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_KOC');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_KOC,'| LKPST_KOC : Partition coefficient [m3/day]');
        
    elseif L==22 && par_f(strcmp(symbol,'LKPST_STL'))==1;
%         LKPST_STL   = x(strcmp(symbol,'LKPST_STL'));
        LKPST_STL=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_STL');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_STL,'| LKPST_STL : Settling velocity of pesticide sorbed to sediment [m/day]');
        
    elseif L==23 && par_f(strcmp(symbol,'LKPST_RSP'))==1;
%         LKPST_RSP   = x(strcmp(symbol,'LKPST_RSP'));
        LKPST_RSP=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_RSP');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_RSP,'| LKPST_RSP : Resuspension velocity of pesticide sorbed to sediment [m/day]');
        
    elseif L==24 && par_f(strcmp(symbol,'LKPST_MIX'))==1;
%         LKPST_MIX   = x(strcmp(symbol,'LKPST_MIX'));
        LKPST_MIX=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_MIX');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_MIX,'| LKPST_MIX : Mixing velocity [m/day]');
        
    elseif L==25 && par_f(strcmp(symbol,'PST_CONC'))==1;
%         PST_CONC    = x(strcmp(symbol,'PST_CONC'));
        PST_CONC=par_value(x, line, alter_m, lba, uba, symbol, 'PST_CONC');
        fprintf(fid2,'%16.3f    %s\r\n',PST_CONC,'| LKPST_CONC : Initial pesticide concentration in the lake bottom sediments [mg/m3]');
        
    elseif L==26 && par_f(strcmp(symbol,'PST_REA'))==1;
%         PST_REA     = x(strcmp(symbol,'PST_REA'));
        PST_REA=par_value(x, line, alter_m, lba, uba, symbol, 'PST_REA');
        fprintf(fid2,'%16.3f    %s\r\n',PST_REA,'| LKPST_REA : Reaction coefficient of pesticide in lake bottom sediment [day-1]');
        
    elseif L==27 && par_f(strcmp(symbol,'LKPST_BRY'))==1;
%         LKPST_BRY   = x(strcmp(symbol,'LKPST_BRY'));
        LKPST_BRY=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_BRY');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_BRY,'| LKPST_BRY : Burial velocity of pesticide in lake bottom sediment [m/day]');
        
    elseif L==28 && par_f(strcmp(symbol,'LKPST_ACT'))==1;
%         LKPST_ACT   = x(strcmp(symbol,'LKPST_ACT'));
        LKPST_ACT=par_value(x, line, alter_m, lba, uba, symbol, 'LKPST_ACT');
        fprintf(fid2,'%16.3f    %s\r\n',LKPST_ACT,'| LKPST_ACT : Depth of active sediment layer in lake [m]');
        
    else
        fprintf(fid2,'%s',line);
        
    end
end
fclose(fid1);
fclose(fid2);

return;