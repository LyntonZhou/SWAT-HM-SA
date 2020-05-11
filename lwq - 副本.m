function lwq(par_f,symbol,x, sensin_path, out_data_path,ReservoirSubNumber)
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

IRES1       = x(cellfun(@(x) isequal(x, 'IRES1'), symbol));
IRES2       = x(cellfun(@(x) isequal(x, 'IRES2'), symbol));
PSETLR1     = x(cellfun(@(x) isequal(x, 'PSETLR1'), symbol));
PSETLR2     = x(cellfun(@(x) isequal(x, 'PSETLR2'), symbol));
NSETLR1     = x(cellfun(@(x) isequal(x, 'NSETLR1'), symbol));
NSETLR2     = x(cellfun(@(x) isequal(x, 'NSETLR2'), symbol));
CHLAR       = x(cellfun(@(x) isequal(x, 'CHLAR'), symbol));
SECCIR      = x(cellfun(@(x) isequal(x, 'SECCIR'), symbol));
RES_ORGP    = x(cellfun(@(x) isequal(x, 'RES_ORGP'), symbol));
RES_SOLP    = x(cellfun(@(x) isequal(x, 'RES_SOLP'), symbol));
RES_ORGN    = x(cellfun(@(x) isequal(x, 'RES_ORGN'), symbol));
RES_NO3     = x(cellfun(@(x) isequal(x, 'RES_NO3'), symbol));
RES_NH3     = x(cellfun(@(x) isequal(x, 'RES_NH3'), symbol));
RES_NO2     = x(cellfun(@(x) isequal(x, 'RES_NO2'), symbol));
LKPST_CONC  = x(cellfun(@(x) isequal(x, 'LKPST_CONC'), symbol));
LKPST_REA   = x(cellfun(@(x) isequal(x, 'LKPST_REA'), symbol));
LKPST_VOL   = x(cellfun(@(x) isequal(x, 'LKPST_VOL'), symbol));
LKPST_KOC   = x(cellfun(@(x) isequal(x, 'LKPST_KOC'), symbol));
LKPST_STL   = x(cellfun(@(x) isequal(x, 'LKPST_STL'), symbol));
LKPST_RSP   = x(cellfun(@(x) isequal(x, 'LKPST_RSP'), symbol));
LKPST_MIX   = x(cellfun(@(x) isequal(x, 'LKPST_MIX'), symbol));
PST_CONC    = x(cellfun(@(x) isequal(x, 'PST_CONC'), symbol));
PST_REA     = x(cellfun(@(x) isequal(x, 'PST_REA'), symbol));
LKPST_BRY   = x(cellfun(@(x) isequal(x, 'LKPST_BRY'), symbol));
LKPST_ACT   = x(cellfun(@(x) isequal(x, 'LKPST_ACT'), symbol));

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==3 && par_f(cellfun(@(x) isequal(x, 'IRES1'), symbol))==1;
        fprintf(fid2,'%i\t  %s\n',IRES1,'| IRES1 : Beginning month of mid-year nutrient settling period');
    elseif L==4 && par_f(cellfun(@(x) isequal(x, 'IRES2'), symbol))==1;
        fprintf(fid2,'%i\t  %s\n',IRES2,'| IRES2 : Ending month of mid-year nutrient settling period');
    elseif L==5 && par_f(cellfun(@(x) isequal(x, 'PSETLR1'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',PSETLR1,'| PSETLR1 : Phosphorus settling rate in reservoir for months IRES1 through IRES2 [m/year]');
    elseif L==6 && par_f(cellfun(@(x) isequal(x, 'PSETLR2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',PSETLR2,'| PSETLR2 : Phosphorus settling rate in reservoir for months other than IRES1-IRES2 [m/year]');
    elseif L==7 && par_f(cellfun(@(x) isequal(x, 'NSETLR1'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',NSETLR1 ,'| NSETLR1 : Nitrogen settling rate in reservoir for months IRES1 through IRES2 [m/year]');
    elseif L==8 && par_f(cellfun(@(x) isequal(x, 'NSETLR2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',NSETLR2,'| NSETLR2 : Nitrogen settling rate in reservoir for months other than IRES1-IRES2 [m/year]');
    elseif L==9 && par_f(cellfun(@(x) isequal(x, 'CHLAR'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',CHLAR,'| CHLAR : Chlorophyll a production coefficient for reservoir');
    elseif L==10 && par_f(cellfun(@(x) isequal(x, 'SECCIR'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',SECCIR,'| SECCIR : Water clarity coefficient for the reservoir');
    elseif L==11 && par_f(cellfun(@(x) isequal(x, 'RES_ORGP'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RES_ORGP,'| RES_ORGP : Initial concentration of organic P in reservoir [mg P/l]');
    elseif L==12 && par_f(cellfun(@(x) isequal(x, 'RES_SOLP'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RES_SOLP,'| RES_SOLP : Initial concentration of soluble P in reservoir [mg P/l]');
    elseif L==13 && par_f(cellfun(@(x) isequal(x, 'RES_ORGN'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RES_ORGN,'| RES_ORGN : Initial concentration of organic N in reservoir [mg N/l]');
    elseif L==14 && par_f(cellfun(@(x) isequal(x, 'RES_NO3'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RES_NO3,'| RES_NO3 : Initial concentration of NO3-N in reservoir [mg N/L]');
    elseif L==15 && par_f(cellfun(@(x) isequal(x, 'RES_NH3'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RES_NH3,'| RES_NH3 : Initial concentration of NH3-N in reservoir [mg N/l]');
    elseif L==16 && par_f(cellfun(@(x) isequal(x, 'RES_NO2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RES_NO2,'| RES_NO2 : Initial concentration of NO2-N in reservoir [mg N/l]');
    elseif L==18 && par_f(cellfun(@(x) isequal(x, 'LKPST_CONC'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_CONC,'| LKPST_CONC : Initial pesticide concentration in the lake water for the first pesticide listed in file.cio. While up to ten pesticides may be applied in a SWAT simulation, only one pesticide (the first one listed in the file.cio) is routed through the reach. (mg/m3)');        
    elseif L==19 && par_f(cellfun(@(x) isequal(x, 'LKPST_REA'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_REA,'| LKPST_REA : Reaction coefficient of the pesticide in lake water [day-1]');        
    elseif L==20 && par_f(cellfun(@(x) isequal(x, 'LKPST_VOL'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_VOL,'| LKPST_VOL : Volatilization coefficient of the pesticide from the lake water [m/day]');        
    elseif L==21 && par_f(cellfun(@(x) isequal(x, 'LKPST_KOC'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_KOC,'| LKPST_KOC : Partition coefficient [m3/day]');
    elseif L==22 && par_f(cellfun(@(x) isequal(x, 'LKPST_STL'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_STL,'| LKPST_STL : Settling velocity of pesticide sorbed to sediment [m/day]');        
    elseif L==23 && par_f(cellfun(@(x) isequal(x, 'LKPST_RSP'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_RSP,'| LKPST_RSP : Resuspension velocity of pesticide sorbed to sediment [m/day]');        
    elseif L==24 && par_f(cellfun(@(x) isequal(x, 'LKPST_MIX'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_MIX,'| LKPST_MIX : Mixing velocity [m/day]');        
    elseif L==25 && par_f(cellfun(@(x) isequal(x, 'PST_CONC'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',PST_CONC,'| LKPST_CONC : Initial pesticide concentration in the lake bottom sediments [mg/m3]');        
    elseif L==26 && par_f(cellfun(@(x) isequal(x, 'PST_REA'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',PST_REA,'| LKPST_REA : Reaction coefficient of pesticide in lake bottom sediment [day-1]');        
    elseif L==27 && par_f(cellfun(@(x) isequal(x, 'LKPST_BRY'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_BRY,'| LKPST_BRY : Burial velocity of pesticide in lake bottom sediment [m/day]');        
    elseif L==28 && par_f(cellfun(@(x) isequal(x, 'LKPST_ACT'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',LKPST_ACT,'| LKPST_ACT : Depth of active sediment layer in lake [m]');        
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;