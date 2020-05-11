function swq(subid,par_n,par_f,symbol,x, sensin_path, out_data_path, lb, ub, strOrder)
% swq is stream water quality input files

subid=char(subid);
subid=[subid '.swq'];

RS2 = x(cellfun(@(x) isequal(x, 'RS2'), symbol));
RS3 = x(cellfun(@(x) isequal(x, 'RS3'), symbol));
RS4 = x(cellfun(@(x) isequal(x, 'RS4'), symbol));
RS5 = x(cellfun(@(x) isequal(x, 'RS5'), symbol));
BC1 = x(cellfun(@(x) isequal(x, 'BC1'), symbol));
BC2 = x(cellfun(@(x) isequal(x, 'BC2'), symbol));
BC3 = x(cellfun(@(x) isequal(x, 'BC3'), symbol));
BC4 = x(cellfun(@(x) isequal(x, 'BC4'), symbol));
RS1 = x(cellfun(@(x) isequal(x, 'RS1'), symbol));

pos        = cellfun(@(x) isequal(x, 'CHPST_REA'), symbol);
CHPST_REA  = x(pos); lower_bound(1) = lb(pos); upper_bound(1) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'CHPST_VOL'), symbol);
CHPST_VOL  = x(pos); lower_bound(2) = lb(pos); upper_bound(2) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'CHPST_KOC'), symbol);
CHPST_KOC  = x(pos); lower_bound(3) = lb(pos); upper_bound(3) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'CHPST_STL'), symbol);
CHPST_STL  = x(pos); lower_bound(4) = lb(pos); upper_bound(4) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'CHPST_RSP'), symbol);
CHPST_RSP  = x(pos); lower_bound(5) = lb(pos); upper_bound(5) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'CHPST_MIX'), symbol);
CHPST_MIX  = x(pos); lower_bound(6) = lb(pos); upper_bound(6) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'SEDPST_CONC'), symbol);
SEDPST_CONC= x(pos); lower_bound(7) = lb(pos); upper_bound(7) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'SEDPST_REA'), symbol);
SEDPST_REA = x(pos); lower_bound(8) = lb(pos); upper_bound(8) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'SEDPST_BRY'), symbol);
SEDPST_BRY = x(pos); lower_bound(9) = lb(pos); upper_bound(9) = ub(pos);
pos        = cellfun(@(x) isequal(x, 'SEDPST_ACT'), symbol);
SEDPST_ACT = x(pos); lower_bound(10) = lb(pos); upper_bound(10) = ub(pos);
PST_DCY_K  = x(cellfun(@(x) isequal(x, 'PST_DCY_K'), symbol));

if par_f(cellfun(@(x) isequal(x, 'PST_DCY_K'), symbol))==1
    apply_PST_DCY_K = 1;
    Coef       = exp(-PST_DCY_K*(strOrder-1));
    inv_Coef   = exp(PST_DCY_K*(strOrder-1));
    
    CHPST_REA  = CHPST_REA  * Coef; if CHPST_REA > upper_bound(1), CHPST_REA = upper_bound(1); elseif CHPST_REA < lower_bound(1), CHPST_REA = lower_bound(1); end
    CHPST_VOL  = CHPST_VOL  * Coef; if CHPST_VOL > upper_bound(2), CHPST_VOL = upper_bound(2); elseif CHPST_VOL < lower_bound(2), CHPST_VOL = lower_bound(2); end
    CHPST_KOC  = CHPST_KOC  * Coef; if CHPST_KOC > upper_bound(3), CHPST_KOC = upper_bound(3); elseif CHPST_KOC < lower_bound(3), CHPST_KOC = lower_bound(3); end
    CHPST_STL  = CHPST_STL  * Coef; if CHPST_STL > upper_bound(4), CHPST_STL = upper_bound(3); elseif CHPST_STL < lower_bound(4), CHPST_STL = lower_bound(4); end
    CHPST_RSP  = CHPST_RSP  * inv_Coef; if CHPST_RSP > upper_bound(5), CHPST_RSP = upper_bound(5); elseif CHPST_RSP < lower_bound(5), CHPST_RSP = lower_bound(5); end
    CHPST_MIX  = CHPST_MIX  * inv_Coef; if CHPST_MIX > upper_bound(6), CHPST_MIX = upper_bound(6); elseif CHPST_MIX < lower_bound(6), CHPST_MIX = lower_bound(6); end
    SEDPST_CONC= SEDPST_CONC* inv_Coef; if SEDPST_CONC > upper_bound(7), SEDPST_CONC = upper_bound(7); elseif SEDPST_CONC < lower_bound(7), SEDPST_CONC = lower_bound(7); end
    SEDPST_REA = SEDPST_REA * Coef; if SEDPST_REA > upper_bound(8), SEDPST_REA = upper_bound(8); elseif SEDPST_REA < lower_bound(8), SEDPST_REA = lower_bound(8); end
    SEDPST_BRY = SEDPST_BRY * Coef; if SEDPST_BRY > upper_bound(9), SEDPST_BRY = upper_bound(9); elseif SEDPST_BRY < lower_bound(9), SEDPST_BRY = lower_bound(9); end
    SEDPST_ACT = SEDPST_ACT * inv_Coef; if SEDPST_ACT > upper_bound(10), SEDPST_ACT = upper_bound(10); elseif SEDPST_ACT < lower_bound(10), SEDPST_ACT = lower_bound(10); end
else
    apply_PST_DCY_K = 0;
end

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==3 && par_f(cellfun(@(x) isequal(x, 'RS1'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RS1,'| RS1:   Local algal settling rate in the reach at 20ºC [m/day]');
    elseif L==4 && par_f(cellfun(@(x) isequal(x, 'RS2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RS2,'| RS2:	Benthic (sediment) source rate for dissolved phosphorus in the reach at 20ºC [mg dissolved P/[m2·day]]');
    elseif L==5 && par_f(cellfun(@(x) isequal(x, 'RS3'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RS3,'| RS3:	Benthic source rate for NH4-N in the reach at 20ºC [mg NH4-N/[m2·day]]');       
    elseif L==6 && par_f(cellfun(@(x) isequal(x, 'RS4'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RS4,'| RS4:	Rate coefficient for organic N settling in the reach at 20ºC [day-1]');
    elseif L==7 && par_f(cellfun(@(x) isequal(x, 'RS5'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',RS5,'| RS5:	Organic phosphorus settling rate in the reach at 20ºC [day-1]');
    elseif L==16 && par_f(cellfun(@(x) isequal(x, 'BC1'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',BC1,'| BC1:	Rate constant for biological oxidation of NH4 to NO2 in the reach at 20?C [day-1]');       
    elseif L==17 && par_f(cellfun(@(x) isequal(x, 'BC2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',BC2,'| BC2:	Rate constant for biological oxidation of NO2 to NO3 in the reach at 20?C [day-1]');
    elseif L==18 && par_f(cellfun(@(x) isequal(x, 'BC3'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',BC3,'| BC3:	Rate constant for hydrolysis of organic N to NH4 in the reach at 20?C [day-1]');
    elseif L==19 && par_f(cellfun(@(x) isequal(x, 'BC4'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n',BC4,'| BC4:	Rate constant for mineralization of organic P to dissolved P in the reach at 20?C [day-1]');
    
    elseif L==21 && par_f(cellfun(@(x) isequal(x, 'CHPST_REA'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',CHPST_REA,'| CHPST_REA: Pesticide reaction coefficient in reach [day-1]');
    elseif L==22 && par_f(cellfun(@(x) isequal(x, 'CHPST_VOL'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',CHPST_VOL,'| CHPST_VOL: Pesticide volatilization coefficient in reach [m/day]');
    elseif L==23 && par_f(cellfun(@(x) isequal(x, 'CHPST_KOC'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',CHPST_KOC,'| CHPST_KOC: Pesticide partition coefficient between water and air in reach [m3/day]');
    elseif L==24 && par_f(cellfun(@(x) isequal(x, 'CHPST_STL'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',CHPST_STL,'| CHPST_STL: Settling velocity for pesticide sorbed to sediment [m/day]');
    elseif L==25 && par_f(cellfun(@(x) isequal(x, 'CHPST_RSP'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',CHPST_RSP,'| CHPST_RSP: Resuspension velocity for pesticide sorbed to sediment [m/day]');
    elseif L==26 && par_f(cellfun(@(x) isequal(x, 'CHPST_MIX'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',CHPST_MIX,'| CHPST_MIX: Mixing velocity (diffusion/dispersion) for pesticide in reach [m/day]');
    elseif L==27 && par_f(cellfun(@(x) isequal(x, 'SEDPST_CONC'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',SEDPST_CONC,'| SEDPST_CONC: Initial pesticide concentration in reach bed sediment [mg/m3 sediment]');
    elseif L==28 && par_f(cellfun(@(x) isequal(x, 'SEDPST_REA'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',SEDPST_REA,'| SEDPST_REA: Pesticide reaction coefficient in reach bed sediment [day-1]');
    elseif L==29 && par_f(cellfun(@(x) isequal(x, 'SEDPST_BRY'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',SEDPST_BRY,'| SEDPST_BRY: Pesticide burial velocity in reach bed sediment [m/day]');
    elseif L==30 && par_f(cellfun(@(x) isequal(x, 'SEDPST_ACT'), symbol))==1 || apply_PST_DCY_K
        fprintf(fid2,'%16.3f\t  %s\n',SEDPST_ACT,'| SEDPST_ACT: Depth of active sediment layer for pesticide [m]');
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;