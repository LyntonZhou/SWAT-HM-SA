function [penalize, Constr_val] = ReadStdConstraints(filename, Apply_Constraints, stdConstraints)
penalize = 0;
paramName = {};
ParList   = {'DENITRIFICATION', 'NO3 LEACHED', 'P LEACHED', 'SSQ/(SQ+SSQ) NO3 Yield'};

L = 0;
for i=1:size(stdConstraints, 1)
    include        = Apply_Constraints(i);
    if include
        L = L+1;
        paramName{L,1} = ParList{i};
        lb(L,1)        = stdConstraints(i,1);
        ub(L,1)        = stdConstraints(i,2);
    end
end

fid = fopen(filename, 'r');
while feof(fid)==0
    line=fgets(fid);
    len = size(line,2);
    if length(line)>36 && isequal(line(1:36),'                   DENITRIFICATION =')
        DENITRIFICATION = (str2double(line(37:len-9)));
    elseif length(line)>32 && isequal(line(1:32),'                   NO3 LEACHED =')
        NO3_LEACHED = (str2double(line(33:len-9)));
    elseif length(line)>30 && isequal(line(1:30),'                   P LEACHED =')
        P_LEACHED = (str2double(line(31:len-9)));
    elseif length(line)>35 && isequal(line(1:35),'                   NO3 YIELD (SQ) =')
        SQ_NO3 = (str2double(line(36:len-9)));
%     elseif length(line)>36 && isequal(strtrim(line(1:36)),'                   NO3 YIELD (LAT) =')
    elseif length(line)>36 && isequal(strtrim(line(1:36)),'NO3 YIELD (LAT) =')        
        LAT_NO3 = (str2double(line(37:len-9)));
    elseif length(line)>37 && isequal(strtrim(line(1:37)),'NO3 YIELD (TILE) =')
%     elseif length(line)>37 && isequal(strtrim(line(1:37)),'                   NO3 YIELD (TILE) =')        
        TILE_NO3 = (str2double(line(38:len-9)));
    end        
end
fclose(fid);

SSQ_NO3 = LAT_NO3 + TILE_NO3;
SSQ_SQ_NO3_YIELD = SSQ_NO3/(SSQ_NO3+SQ_NO3);

if length(paramName) >= 1
    for i=1:size(paramName,1)
        switch paramName{i,1}
            case 'DENITRIFICATION'
                if DENITRIFICATION < lb(i,1) || DENITRIFICATION > ub(i,1)
                    penalize = 1;
                    break
                end
            case 'NO3 LEACHED'
                if NO3_LEACHED < lb(i,1) || NO3_LEACHED > ub(i,1)
                    penalize = 1;
                    break
                end
            case 'NO3 YIELD (SQ)'
                if SQ_NO3 < lb(i,1) || SQ_NO3 > ub(i,1)
                    penalize = 1;
                    break
                end
            case 'NO3 YIELD (SSQ)'
                if SSQ_NO3 < lb(i,1) || SSQ_NO3 > ub(i,1)
                    penalize = 1;
                    break
                end
            case 'SSQ/(SQ+SSQ) NO3 Yield'
                if SSQ_SQ_NO3_YIELD < lb(i,1) || SSQ_SQ_NO3_YIELD > ub(i,1)
                    penalize = 1;
                    break
                end
            case 'P LEACHED'
                if P_LEACHED < lb(i,1) || P_LEACHED > ub(i,1)
                    penalize = 1;
                    break
                end
        end
    end
end
Constr_val = [DENITRIFICATION, NO3_LEACHED, P_LEACHED, SSQ_SQ_NO3_YIELD, SSQ_NO3, SQ_NO3];

return