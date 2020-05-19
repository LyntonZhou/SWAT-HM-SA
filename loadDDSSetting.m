function [DDSPar, Extra, Restart] = loadDDSSetting %#ok<STOUT>

fname           = '../02ControlFiles/IPEAT.set';

%% list of Parameters
loc     = [2:3,6:7]; % Line numbers in "Dream.set"
varname = {'DDSPar.PertSize', 'DDSPar.ndraw',...
           'Extra.UseInitial', 'Restart'};                  % Name of Variables
str     = zeros(size(loc));             % location (Line #) of String Variables in "Dream.set"
str([6,7]) = 1;

%% Read data from Dream.set
fid = fopen(fname, 'r');
L = 0;
while feof(fid)==0
    L = L + 1;
    line=fgets(fid);
    if length(line)>=24
        line2 = strtrim(line(1:24));
    end
    if ismember(L, loc) && ~isempty(line2)
        [~,index] = ismember(L, loc);
        if str(L) == 1
            eval([varname{index} '= line2;']);
        else
            if isa(line2, 'numeric') && ~isempty(line2)
                eval([varname{index} '= str2num(line2);']);
            else
                eval([varname{index} '= eval(line2);']);
            end
        end
    end
end
fclose(fid);

return