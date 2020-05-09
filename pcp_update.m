function pcp_update(stest,Extra)

labindex = 1;
Project_directory = [Extra.settings.out_path '\pool' num2str(labindex)];
current_TxtInOut  = [Extra.settings.out_path '\temp' num2str(labindex)];

filename_pcp1 = [current_TxtInOut '\pcp1.pcp'];
filename_pcp2 = [Project_directory '\pcp1_2.pcp'];
filename_pcp3 = [Project_directory '\pcp1.pcp'];

Laten_nu = stest(end-1);
Laten_sigma = 0.01*stest(end);

fid_read =  fopen(filename_pcp1, 'r');
fid_write = fopen(filename_pcp2, 'wt');

L= 0;
while feof(fid_read)==0
    L = L + 1;
    line = fgets(fid_read);
    if L <=4
        fprintf(fid_write,'%s',line);    
    elseif L > 4    
        line2 = strtrim(line(1:4));
        line3 = strtrim(line(5:7));
        line4 = strtrim(line(8:12));
        line5 = strtrim(line(13:17));
        line6 = strtrim(line(18:22));
        pcp_temp1 = str2double(line4);
        pcp_temp2 = str2double(line5);
        pcp_temp3 = str2double(line6);
        pcp_new1 = random('Normal',Laten_nu,Laten_sigma)*pcp_temp1;
        pcp_new2 = random('Normal',Laten_nu,Laten_sigma)*pcp_temp2;
        pcp_new3 = random('Normal',Laten_nu,Laten_sigma)*pcp_temp3;
        string1 = sprintf('%05.1f',pcp_new1);
        string2 = sprintf('%05.1f',pcp_new2);
        string3 = sprintf('%05.1f',pcp_new3);
        fprintf(fid_write,'%s%s%s%s%s\n',line2,line3,string1,string2,string3);
    end 
end
fclose (fid_read);
fclose (fid_write);

fid_read =  fopen(filename_pcp2, 'r');
fid_write = fopen(filename_pcp3, 'w');

L = 0;
while feof(fid_read)==0
    L=L+1;
    line=fgets(fid_read);
    fprintf(fid_write,'%s',line);
end
fclose (fid_read);
fclose (fid_write);
delete(filename_pcp2);        
        
        
        
        
        
        