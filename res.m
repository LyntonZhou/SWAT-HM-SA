function res(par_f, symbol, x, alter_m, lba, uba, sensin_path, out_data_path,ReservoirSubNumber)
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

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==13 && par_f(strcmp(symbol,'RES_K'))==1;
%         RES_K       = x(strcmp(symbol,'RES_K'));
        RES_K=par_value(x, line, alter_m, lba, uba, symbol, 'RES_K');
        fprintf(fid2,'%16.3f\t  %s\r\n', RES_K, '| RES_K : Hydraulic conductivity of the reservoir bottom [mm/hr]');
        
    elseif L==23 && par_f(strcmp(symbol,'RES_RR'))==1;
%         RES_RR      = x(strcmp(symbol,'RES_RR'));
        RES_RR=par_value(x, line, alter_m, lba, uba, symbol, 'RES_RR');
        fprintf(fid2,'%16.3f\t  %s\r\n', RES_RR, '| RES_RR : Average daily principal spillway release rate [m3/s]');
        
    elseif L==37 && par_f(strcmp(symbol,'WURTNF'))==1;
%         WURTNF      = x(strcmp(symbol,'WURTNF'));
        WURTNF=par_value(x, line, alter_m, lba, uba, symbol, 'WURTNF');
        fprintf(fid2,'%16.3f\t  %s\r\n', WURTNF, '| WURTNF : Fraction of water removed from the reservoir via WURESN that is returned and becomes flow out of reservoir [m3/m3]');
        
    elseif L==38 && par_f(strcmp(symbol,'EVRSV'))==1;
%         EVRSV       = x(strcmp(symbol,'EVRSV'));
        EVRSV=par_value(x, line, alter_m, lba, uba, symbol, 'EVRSV');
        fprintf(fid2,'%16.3f\t  %s\r\n', EVRSV, '| EVRSV : Lake evaporation coefficient');
        
    elseif L==39 && par_f(strcmp(symbol,'OFLOWMN_FPS'))==1;
%         OFLOWMN_FPS = x(strcmp(symbol,'OFLOWMN_FPS'));
        OFLOWMN_FPS=par_value(x, line, alter_m, lba, uba, symbol, 'OFLOWMN_FPS');
        fprintf(fid2,'%16.3f\t  %s\r\n', OFLOWMN_FPS, '| OFLOWMN_FPS : Minimum reservoir outflow as a fraction of the principal spillway volume');
        
    elseif L==40 && par_f(strcmp(symbol,'STARG_FPS'))==1;
%         STARG_FPS   = x(strcmp(symbol,'STARG_FPS'));
        STARG_FPS=par_value(x, line, alter_m, lba, uba, symbol, 'STARG_FPS');
        fprintf(fid2,'%16.3f\t  %s\r\n', STARG_FPS, '| STARG_FPS : Target volume as a fraction of the principal spillway volume');
        
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);

return;