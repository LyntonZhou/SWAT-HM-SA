function crop(symbol,x, sensin_path, out_data_path)

USLEC_f=x(strcmp(symbol, 'USLE_C'));

file_read = [sensin_path '\plant.dat'];
file_write = [out_data_path '\plant.dat'];
delete(file_write);
fid1=fopen(file_read, 'r');
fid2=fopen(file_write, 'w');

% only for crop land use
L=0;
while feof(fid1)==0;
      L=L+1;
      line=fgets(fid1);
      if L==4;
         [str,rem]=strtok(line);
         str=strtok(rem);
         C_AGRL=str2double(str);
         C_AGRL=(1+USLEC_f)*C_AGRL;
         fprintf(fid2,'%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\r\n',0.25,C_AGRL,0.007,4,0.75,8.5,660,36,0.05,0.0);
         
      elseif L==9;
         [str,rem]=strtok(line);
         str=strtok(rem);
         C_AGRR=str2double(str);
         C_AGRR=(1+USLEC_f)*C_AGRR;
         fprintf(fid2,'%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\r\n',0.2,C_AGRR,0.007,4,0.75,6,660,39,0.05,0.00);
         
      elseif L==14;
         [str,rem]=strtok(line);
         str=strtok(rem);
         C_AGRC=str2double(str);
         C_AGRC=(1+USLEC_f)*C_AGRC;
         fprintf(fid2,'%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\r\n',0.2,C_AGRC,0.006,4,0.75,7.2,660,45,0.05,0.00);
         
      elseif L==94;
         [str,rem]=strtok(line);
         str=strtok(rem);
         C_CORN=str2double(str);
         C_CORN=(1+USLEC_f)*C_CORN;
         fprintf(fid2,'%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\r\n',0.3,C_CORN,0.007,4,0.75,7.2,660,45,0.05,0.00);
         
      elseif L==59;
         [str,rem]=strtok(line);
         str=strtok(rem);
         C_PAST=str2double(str);
         C_PAST=(1+USLEC_f)*C_PAST;
         fprintf(fid2,'%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\r\n',0.9,C_PAST,0.005,4,0.75,10,660,36,0.05,0.00);
        
      elseif L==279;
         [str,rem]=strtok(line);
         str=strtok(rem);
         C_SOYB=str2double(str);
         C_SOYB=(1+USLEC_f)*C_SOYB;
         fprintf(fid2,'%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\r\n',0.01,C_SOYB,0.007,4,0.75,8,660,34,0.05,0.00);
        
      elseif L==139;
         [str,rem]=strtok(line);
         str=strtok(rem);
         C_WWHT=str2double(str);
         C_WWHT=(1+USLEC_f)*C_WWHT;
         fprintf(fid2,'%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f%8.3f\r\n',0.3,C_WWHT,0.007,4,0.75,7.2,660,45,0.05,0.00);
        
      else
         fprintf(fid2,'%s',line);
      end
end
fclose(fid1);
fclose(fid2);
return;