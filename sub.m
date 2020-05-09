function sub(subid,par_n,par_f,symbol,x, sensin_path, out_data_path)
subid=char(subid);
subid=[subid '.sub'];

CH_KI = x(cellfun(@(x) isequal(x, 'CH_KI'), symbol));
CH_NI = x(cellfun(@(x) isequal(x, 'CH_NI'), symbol));
CH_SI = x(cellfun(@(x) isequal(x, 'CH_SI'), symbol));

file_read  = [sensin_path '\' subid];
file_write = [out_data_path '\' subid];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
      L=L+1;
      line=fgets(fid1);
      if L==29 && par_f(cellfun(@(x) isequal(x, 'CH_NI'), symbol))==1;
         fprintf(fid2,'%16.3f\t  %s\n',CH_NI,'| CH_N1 : Manning"s "n" value for the tributary channels');
      elseif L==26 && par_f(cellfun(@(x) isequal(x, 'CH_SI'), symbol))==1;
         CH_S=str2double(strtok(line))*(1+CH_SI);
         fprintf(fid2,'%16.3f\t  %s\n',CH_S,'| CH_S1 : Average slope of tributary channel [m/m]');        
      elseif L==28 && par_f(cellfun(@(x) isequal(x, 'CH_KI'), symbol))==1;
         fprintf(fid2,'%16.3f\t  %s\n',CH_KI,'| CH_K1 : Effective hydraulic conductivity in tributary channel [mm/hr]'); 
      else
         fprintf(fid2,'%s',line);
      end
end
fclose(fid1);
fclose(fid2);

return;