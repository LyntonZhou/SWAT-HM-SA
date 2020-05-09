function pest(symbol,x, sensin_path, out_data_path)

PEST_EFF=x(cellfun(@(x) isequal(x, 'PEST_EFF'), symbol));

file_read = [sensin_path '\pest.dat'];
file_write = [out_data_path '\pest.dat'];
delete(file_write);
fid1=fopen(file_read, 'r');
fid2=fopen(file_write, 'w');

L=0;
while feof(fid1)==0;
      L=L+1;
      line=fgets(fid1);
      left_part=line(1:52);right_part=line(57:end);
      new_line=[left_part sprintf('%4.2g',PEST_EFF) right_part];
      fprintf(fid2,new_line);
end
fclose(fid1);
fclose(fid2);
return;