function n_sub = proj_setup(simout_path, out_id, ICALIB, IPRINT, simdate, n_warmup)
%% Determine the total number of subwatersheds from file.fig file
[n_sub, subFiles, rteFiles] = getNsub(simout_path);

%% This cell should be coordinated with the read_output m-file
if out_id(1)==1; out_id(2)=1; end
if out_id(12)==1; out_id(5)=1; out_id(9)=1; end
if out_id(13)==1; out_id(4)=1; out_id(6)=1; out_id(7)=1; out_id(8)=1; end
if out_id(14)==1; out_id(10)=1; out_id(11)=1; end

% if calibration of sediements,nutrient, or pesticides is based on
% concentrations, out_id will be 1 since SF will be needed to compute conc.
if ICALIB(1)==1 && out_id(3)~=0; out_id(2)=1; end % Sediment conc. est.
if ICALIB(2)==1 && any(out_id(4:9))~=0; out_id(2)=1; end % N and P conc. est.
if ICALIB(3)==1 && any(out_id(10:11))~=0; out_id(2)=1; end % PST conc. est.
%%
%%
ipdvar_a=[2 6 9 11 13 15 17 19 27 29];
% ipdvar: output variables printed to .rch file from SWAT manual, respectively
% 2:flow_out, 6:sed_out; 9:orgn_n; 11=orgp_out; 13:no3n_out
% 15:nh4n_out, 17:no2n_out, 19:minp_out, 27:solpst_out, 29:sorpst_out 
ipdvar=ipdvar_a(find(out_id(2:11)>0)); %#ok<FNDSB>
ipdvar(length(ipdvar)+1:20)=0;

line_65 = sprintf('%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i%4i',ipdvar);

% line_69 = sprintf('%4i', [1 zeros(1,19)]);

%%
NBYR = (simdate(2,1) - simdate(1,1)) + 1;
IYR  = simdate(1,1);
IDAF = datenum(simdate(1,1), simdate(1,2), simdate(1,3)) - datenum(simdate(1,1), 1, 1) + 1;
IDAL = datenum(simdate(2,1), simdate(2,2), simdate(2,3)) - datenum(simdate(2,1), 1, 1) + 1;
NYSKIP = n_warmup;

%%
copyfile([simout_path '\file.cio'], [simout_path '\tempfile.cio']);
file_read  = [simout_path '\tempfile.cio'];
file_write = [simout_path '\file.cio'];
delete(file_write);
fid1=fopen(file_read,'r');
fid2=fopen(file_write,'w');

L=0;
while feof(fid1)==0;
    L=L+1;
    line=fgets(fid1);
    if L==8
        fprintf(fid2,'%19i %s\r\n',NBYR, '| NBYR : Number of years simulated');
    elseif L == 9
        fprintf(fid2,'%19i %s\r\n',IYR, '| IYR : Beginning year of simulation');
    elseif L == 10
        fprintf(fid2,'%19i %s\r\n',IDAF, '| IDAF : Beginning julian day of simulation');
    elseif L == 11
        fprintf(fid2,'%19i %s\r\n',IDAL, '| IDAL : Ending julian day of simulation');
    elseif L==49
        cropFname = strtok(line); fprintf(fid2,'%s', line);
    elseif L==50
        tillFname = strtok(line); fprintf(fid2,'%s', line);
    elseif L==51
        pestFname = strtok(line); fprintf(fid2,'%s', line);
    elseif L==52
        fertFname = strtok(line); fprintf(fid2,'%s', line);
    elseif L==53
        urbanFname = strtok(line); fprintf(fid2,'%s', line);
    elseif L==59
        fprintf(fid2,'%16i    %s\r\n', IPRINT,'| IPRINT: print code (month, day, year)');
    elseif L==60
        fprintf(fid2,'%16i    %s\r\n',NYSKIP,'| NYSKIP: number of years to skip output printing/summarization');
    elseif L==65
        fprintf(fid2,'%s\r\n', line_65);
    elseif L==67
        fprintf(fid2,'%s\r\n', '   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0');
    elseif L==69
        fprintf(fid2,'%s\r\n', '   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0');
    elseif L==71
        fprintf(fid2,'%s\r\n', '   1   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0');
    elseif L==79
        fprintf(fid2,'%16i\r\n', 0);
    else
        fprintf(fid2,'%s', line);
    end
end
fclose(fid1);
fclose(fid2);

if L<79
    copyfile([simout_path '\file.cio'], [simout_path '\tempfile.cio']);
    file_read  = [simout_path '\tempfile.cio'];
    file_write = [simout_path '\file.cio'];
    delete(file_write);
    fid1=fopen(file_read,'r');
    fid2=fopen(file_write,'w');
    for L=1:78
        line=fgets(fid1);
        fprintf(fid2,'%s', line);
    end
    fprintf(fid2,'%i\r\n', 2);
    fclose(fid1);
    fclose(fid2);
end

delete([simout_path '\tempfile.cio']);

dates=datevec(datenum(IYR+NYSKIP,1,IDAF):datenum(IYR+NBYR-1,1,IDAL));
yout=dates(:,1); % Vector of output printing/summarization years
mout=dates(:,2); % Vector of output printing/summarization months
dout=dates(:,3); % Vector of output printing/summarization days
out_dates=[yout,mout,dout];
n_month = 1;
for i=2:size(mout,1)
    if mout(i) ~= mout(i-1)
        n_month = n_month + 1;
        n_DayinMonth(n_month-1) = dout(i-1);
    end
end
n_DayinMonth(n_month) = dout(end);

n_year = 1; n_DayinYear(n_year) = 1;
for i=2:size(yout,1)
    if yout(i) ~= yout(i-1)
        n_year = n_year + 1;
        n_DayinYear(n_year) = 1;
    else
        n_DayinYear(n_year) = n_DayinYear(n_year)+1;
    end
end
% keyboard
% out_dates.NBYR          = NBYR;
% out_dates.IYR           = IYR;
% out_dates.IDAF          = IDAF;
% out_dates.IDAL          = IDAL;
% out_dates.NYSKIP        = NYSKIP;
% out_dates.IPRINT        = IPRINT;
% out_dates.n_DayinMonth  = n_DayinMonth;
% out_dates.n_DayinYear   = n_DayinYear;

return;


function [nSub, subFiles, rteFiles] = getNsub(simout_path)
% Find .fig file
file_write = [simout_path '\file.cio'];
fid0 = fopen(file_write, 'r');
L=0;
while feof(fid0)==0;
    L=L+1;
    line=fgets(fid0);
    if L==7
        figFilename = strtrim(line);
    end
end

fclose(fid0);

% find n_sub and subbasin files
fid = fopen([simout_path '\' figFilename], 'r');

L=0; nSub = 0;
while feof(fid)==0;
    L=L+1;
    line=fgets(fid);
    if size(line,2) >= 8 && isequal(lower(line(1:8)), 'subbasin')
        % sub_num
        sun_num = str2num(line(23:28));
        nSub    = max(nSub, sun_num);
        % subfile
        L=L+1;
        line = fgets(fid);
        subFiles{sun_num} = strtrim(line);
    elseif size(line,2) >= 5 && isequal(lower(line(1:5)), 'route')
        % sub_num
        sun_num = str2num(line(23:28));
        
        % rtefile
        L=L+1;
        line = fgets(fid);
        rteFiles{sun_num} = strtrim(line(1:23));
    end
end

fclose(fid);

% nSub = max(sun_num);
subFiles = subFiles';
rteFiles = rteFiles';

return