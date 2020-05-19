function chm(hruid, hru_lnd, sol_depth, sol_cbn, par_n, par_f, symbol, x, sensin_path, out_data_path)
% chm is soil chemical input files

hruid = char(hruid);
hru_str  = [hruid '.chm'];
n_layers = length(sol_depth);

avg_depth = mean([sol_depth; [0 sol_depth(1:end-1)]]);
str_SolN = [ones(1,n_layers).*exp(-avg_depth/1000) zeros(1,10-length(sol_depth))];
SOLN     = x(strcmp(symbol, 'SOLN'))*str_SolN;

if sol_cbn(1) == 0
    str_OrgN = [ones(1,n_layers).*(0) zeros(1,10-length(sol_depth))];
else
    str_OrgN = [ones(1,n_layers).*(sol_cbn./sol_cbn(1)) zeros(1,10-length(sol_depth))];
end
ORGN     = x(strcmp(symbol, 'ORGN'))*str_OrgN;

str_labP = [ones(1,n_layers) zeros(1,10-length(sol_depth))];
LABP     = x(strcmp(symbol, 'LABP'))*str_labP;

str_orgP = str_OrgN;
ORGP     = x(strcmp(symbol, 'ORGP'))*str_orgP;

if isequal(hru_lnd, upper('Row Crops'))
    file_read = [sensin_path '\' hru_str];
    file_write = [out_data_path '\' hru_str];
    delete(file_write);
    fid1=fopen(file_read,'r');
    fid2=fopen(file_write,'w');
    L=0;
    while feof(fid1)==0;
        L=L+1;
        line=fgets(fid1);
        if L==4 && par_f(strcmp(symbol, 'SOLN'))==1;
            fprintf(fid2,'%s%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f\r\n', ...
                ' Soil NO3 [mg/kg]         :',SOLN);
            
        elseif L==5 && par_f(strcmp(symbol, 'ORGN'))==1;
            fprintf(fid2,'%s%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f\r\n', ...
                ' Soil organic N [mg/kg]   :',ORGN);
            
        elseif L==6 && par_f(strcmp(symbol, 'LABP'))==1;
            fprintf(fid2,'%s%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f\r\n', ...
                ' Soil labile P [mg/kg]    :',LABP);
            
        elseif L==7 && par_f(strcmp(symbol, 'ORGP'))==1;
            fprintf(fid2,'%s%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f\r\n', ...
                ' Soil organic P [mg/kg]   :',ORGP);
        else
            fprintf(fid2,'%s',line);
        end
    end
    fclose(fid1);
    fclose(fid2);
end

if isequal(hru_lnd, upper('Pasture/Hay'))
    file_read = [sensin_path '\' hru_str];
    file_write = [out_data_path '\' hru_str];
    delete(file_write);
    fid1=fopen(file_read,'r');
    fid2=fopen(file_write,'w');
    L=0;
    while feof(fid1)==0;
        L=L+1;
        line=fgets(fid1);
        if L==6 && par_f(cellfun(@(x) isequal(x, 'LABP'), symbol))==1;
            fprintf(fid2,'%s%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f\n', ...
                ' Soil labile P [mg/kg]    :',LABP*2);
            
        elseif L==7 && par_f(cellfun(@(x) isequal(x, 'ORGP'), symbol))==1;
            fprintf(fid2,'%s%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f\n', ...
                ' Soil organic P [mg/kg]   :',ORGP*0.25);
            
        elseif L==5 && par_f(cellfun(@(x) isequal(x, 'ORGN'), symbol))==1;
            fprintf(fid2,'%s%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f\n', ...
                ' Soil organic N [mg/kg]   :',ORGN*0.25);
            
        elseif L==4 && par_f(cellfun(@(x) isequal(x, 'SOLN'), symbol))==1;
            fprintf(fid2,'%s%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f%12.3f\n', ...
                ' Soil NO3 [mg/kg]         :',SOLN*0.25);
            
        else
            fprintf(fid2,'%s',line);
            
        end
    end
    fclose(fid1);
    fclose(fid2);
end
return;