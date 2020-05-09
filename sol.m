function sol(hruid,hru_lnd,par_n,par_f,symbol,x, sensin_path, out_data_path)
hruid=char(hruid);
hru_str=[hruid '.sol'];

SOL_AWC = x(cellfun(@(x) isequal(x, 'SOL_AWC'), symbol));
SOL_K   = x(cellfun(@(x) isequal(x, 'SOL_K'), symbol));
USLE_K  = x(cellfun(@(x) isequal(x, 'USLE_K'), symbol));
SOL_Z   = x(cellfun(@(x) isequal(x, 'SOL_Z'), symbol));
SOL_ALB = x(cellfun(@(x) isequal(x, 'SOL_ALB'), symbol));

file_read  = [sensin_path '\' hru_str];
file_write = [out_data_path '\' hru_str];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');
L=0;
while feof(fid1)==0;
      L=L+1;
      line=fgets(fid1);
      if L==8 && par_f(cellfun(@(x) isequal(x, 'SOL_Z'), symbol))==1;
         SOLZ_new = str2num(sscanf(line,'%*27c%[^\n]')) .* (1+SOL_Z);
         fprintf(fid2,' Depth                [mm]:%s\r\n',sprintf('%12.2f',SOLZ_new)); 
      elseif L==10 && par_f(cellfun(@(x) isequal(x, 'SOL_AWC'), symbol))==1;
         AWC_new = str2num(sscanf(line,'%*27c%[^\n]')) .* (1+SOL_AWC);
         fprintf(fid2,' Ave. AW Incl. Rock Frag  :%s\r\n',sprintf('%12.2f',AWC_new));
      elseif L==11 && par_f(cellfun(@(x) isequal(x, 'SOL_K'), symbol))==1;
         Ksat_new = str2num(sscanf(line,'%*27c%[^\n]')) .* (1+SOL_K);
         fprintf(fid2,' Ksat. (est.)      [mm/hr]:%s\r\n',sprintf('%12.2f',Ksat_new));
      elseif L==17 && par_f(cellfun(@(x) isequal(x, 'SOL_ALB'), symbol))==1;
         SOL_ALB_new = str2num(sscanf(line,'%*27c%[^\n]')) .* (1+SOL_ALB);
         fprintf(fid2,' Soil Albedo (Moist)      :%s\r\n',sprintf('%12.2f',SOL_ALB_new));   
      elseif L==18 && par_f(cellfun(@(x) isequal(x, 'USLE_K'), symbol))==1;
         USLEK_new = str2num(sscanf(line,'%*27c%[^\n]')) .* (1+USLE_K); 
         fprintf(fid2,' Erosion K                :%s\r\n',sprintf('%12.2f',USLEK_new));
      else
         fprintf(fid2,'%s',line);
      end
end
fclose(fid1);
fclose(fid2);
return;