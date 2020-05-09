function res(par_f,symbol,x, sensin_path, out_data_path,ReservoirSubNumber)
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
subid=[subid '.res'];

RES_K       = x(cellfun(@(x) isequal(x, 'RES_K'), symbol));
RES_RR      = x(cellfun(@(x) isequal(x, 'RES_RR'), symbol));
WURTNF      = x(cellfun(@(x) isequal(x, 'WURTNF'), symbol));
EVRSV       = x(cellfun(@(x) isequal(x, 'EVRSV'), symbol));
OFLOWMN_FPS = x(cellfun(@(x) isequal(x, 'OFLOWMN_FPS'), symbol));
STARG_FPS   = x(cellfun(@(x) isequal(x, 'STARG_FPS'), symbol));

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==13 && par_f(cellfun(@(x) isequal(x, 'IRES1'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n', RES_K, '| RES_K : Hydraulic conductivity of the reservoir bottom [mm/hr]');
    elseif L==23 && par_f(cellfun(@(x) isequal(x, 'IRES2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n', RES_RR, '| RES_RR : Average daily principal spillway release rate [m3/s]');
    elseif L==37 && par_f(cellfun(@(x) isequal(x, 'IRES2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n', WURTNF, '| WURTNF : Fraction of water removed from the reservoir via WURESN that is returned and becomes flow out of reservoir [m3/m3]');
    elseif L==38 && par_f(cellfun(@(x) isequal(x, 'IRES2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n', EVRSV, '| EVRSV : Lake evaporation coefficient');
    elseif L==39 && par_f(cellfun(@(x) isequal(x, 'IRES2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n', OFLOWMN_FPS, '| OFLOWMN_FPS : Minimum reservoir outflow as a fraction of the principal spillway volume');
    elseif L==40 && par_f(cellfun(@(x) isequal(x, 'IRES2'), symbol))==1;
        fprintf(fid2,'%16.3f\t  %s\n', STARG_FPS, '| STARG_FPS : Target volume as a fraction of the principal spillway volume');
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;