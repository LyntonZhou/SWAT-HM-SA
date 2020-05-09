function out_id = cio(out_id,IPRINT,ICALIB, NBYR,IYR,IDAF,IDAL,NYSKIP, sensin_path, out_data_path)

%% This cell should be coordinated with the read_output m-file
if out_id(1) ==1; out_id(2) =1; end
if out_id(12)==1; out_id(5) =1; out_id(9) =1; end
if out_id(13)==1; out_id(4) =1; out_id(6) =1; out_id(7)=1; out_id(8)=1; end
if out_id(14)==1; out_id(10)=1; out_id(11)=1; end
if out_id(15)==1; out_id(4) =1; out_id(7) =1; end
if out_id(16)==1; out_id(6) =1; out_id(8) =1; end

% if calibration of sediements,nutrient, or pesticides is based on
% concentrations, out_id will be 1 since SF will be needed to compute conc.
if ICALIB(1)==1 && out_id(3)~=0; out_id(2)=1; end % Sediment conc. est.
if ICALIB(2)==1 && any(out_id(4:9))~=0; out_id(2)=1; end % N and P conc. est.
if ICALIB(3)==1 && any(out_id(10:11))~=0; out_id(2)=1; end % PST conc. est.
%%
ipdvar_a=[2 6 9 11 13 15 17 19 27 29];
% ipdvar: output variables printed to .rch file from SWAT manual, respectively
% 2:flow_out, 6:sed_out; 9:orgn_n; 11=orgp_out; 13:no3n_out
% 15:nh4n_out, 17:no2n_out, 19:minp_out, 27:solpst_out, 29:sorpst_out 
ipdvar=ipdvar_a(find(out_id(2:11)>0)); %#ok<FNDSB>
ipdvar(length(ipdvar)+1:20)=0;

line_65=sprintf('%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i',ipdvar);

file_read = [sensin_path '\file.cio'];
file_write = [out_data_path '\file.cio'];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L == 8
        fprintf(fid2,'%19i %s\n',NBYR, '| NBYR : Number of years simulated'); 
    elseif L == 9
        fprintf(fid2,'%19i %s\n',IYR, '| IYR : Beginning year of simulation'); 
    elseif L == 10
        fprintf(fid2,'%19i %s\n',IDAF, '| IDAF : Beginning julian day of simulation'); 
    elseif L == 11
        fprintf(fid2,'%19i %s\n',IDAL, '| IDAL : Ending julian day of simulation');
    elseif L==59
        fprintf(fid2,'%16i    %s\n',IPRINT,'| IPRINT: print code (month, day, year)');          
    elseif L==60
        fprintf(fid2,'%16i    %s\n',NYSKIP,'| NYSKIP: number of years to skip output printing/summarization');
    elseif L==65
        fprintf(fid2,'%s\n',line_65);
    elseif L==67
        fprintf(fid2,'%s\n','   2   0   0   0   0   0   0   0   0   0   0   0   0   0   0');
    elseif L==69
        fprintf(fid2,'%s\n','   2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0');      
    elseif L==71
        fprintf(fid2,'%s\n','   2   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0');  
    elseif L==79
        fprintf(fid2,'%i\n',1);  
%         fprintf(fid2,'%s\n','               2    | binary =1 ascii = 0 both = ');  
    else
        fprintf(fid2,'%s',line);
    end
end
fclose(fid1);
fclose(fid2);
return;