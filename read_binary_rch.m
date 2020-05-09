function [out, n_DayinMonth, n_DayinYear] = read_binary_rch(out_data_path, nparam, IPRINT, n_sub)
[out_dates, n_DayinMonth, n_DayinYear]=proj_dates(out_data_path);

% Read output.rch file
NLSkip = 9;
fname = fullfile(out_data_path, 'output.rch');

fid = fopen(fname, 'r');
C = textscan(fid, '%s', 'HeaderLines', NLSkip);
fclose(fid);

nData = length(C{1});
% nCol = nparam+5+1;
nCol = nparam+5;
nRow = nData/nCol;
out = reshape(C{1}, nCol, nRow)';
out(:,1) = [];
out = str2double(out);

% remove summary outputs
switch IPRINT
    case 0
        % summary of entire simulation period
        out(end-n_sub+1:end, :) = [];
        
        % summary of each year
        out(out(:,3)>=out_dates(1,1),:) = [];
    case 2
        % complete later
end