function [output, n_DayinMonth, n_DayinYear] = read_rch(out_data_path, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   OUTPUT = IMPORTFILE(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   OUTPUT = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   output = read_rch('output.rch', 7, 24843);
%
%    See also TEXTSCAN.

[out_dates, n_DayinMonth, n_DayinYear]=proj_dates(out_data_path);

%% Initialize variables.
filename = fullfile(out_data_path, 'output.rch');

delimiter = ' ';
if nargin<=2
    startRow = 6;
    endRow = inf;
end

%% Format string for each line of text:
%   column2: double (%f)
%	column3: double (%f)
%   column4: double (%f)
%	column5: double (%f)
%   column6: double (%f)
%	column7: double (%f)
%   column8: double (%f)
%	column9: double (%f)
%   column10: double (%f)
%	column11: double (%f)
%   column12: double (%f)
%	column13: double (%f)
%   column14: double (%f)
%	column15: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
textscan(fileID, '%[^\n\r]', startRow(1)-1, 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    textscan(fileID, '%[^\n\r]', startRow(block)-1, 'ReturnOnError', false);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
output = [dataArray{1:end-1}];
