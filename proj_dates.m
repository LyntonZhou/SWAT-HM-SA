%This function determines the dates for output printing/summerization
function [out_dates, n_DayinMonth, n_DayinYear]=proj_dates(out_data_path)
% Determine the dates for output printing/summerization
fid=fopen([out_data_path '\file.cio'],'r');
L=0; % Counting variable
while feof(fid)==0;
    L=L+1;
    line=fgets(fid);
    if L==8
        NBYR = str2double(strtok(line));  % NBYR : Number of years simulated.
    elseif L==9
        IYR = str2double(strtok(line));   % IYR : Beginning year of simulation.
    elseif L==10
        IDAF = str2double(strtok(line));  % IDAF : Beginning julian day of simulation.
    elseif L==11
        IDAL = str2double(strtok(line));  % IDAL : Ending julian day of simulation.
    elseif L==60
        NYSKIP = str2double(strtok(line));% NYSKIP: number of years to skip output printing/summarization 
    end
end
fclose(fid);

if NYSKIP>0
    IDAL = 1;
end

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
    end
    n_DayinYear(n_year) = n_DayinYear(n_year)+1;
end
return