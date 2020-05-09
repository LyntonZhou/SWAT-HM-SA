%This script constructs the filename id.
function [file_id] = id_func(n_sub, out_data_path)
% file_id(1): hru_number
% file_id(2): sub_number
% file_id(3): hru_filename
% file_id(4): hru_area
% file_id(5): hru land use
% file_id(6): hru land use flag
% file_id(7): hru soil name
% file_id(8): hru soil hydrologic group
% file_id(9): sub_filename
% file_id(10): sub_area
% file_id(11): depth of soil layers
% file_id(12): Organic Carbon [weight %] of each soil layer
L = 0;
LL = 0;
for sub_no = 1:n_sub;
    L = L+1;
    if sub_no < 10
        sub_zeros = '0000';
    elseif sub_no >= 10 && sub_no < 100
        sub_zeros = '000';
    elseif sub_no >= 100 && sub_no < 1000
        sub_zeros = '00';
    elseif sub_no >= 1000 && sub_no < 10000
        sub_zeros = '0';
    elseif sub_no >= 10000
        sub_zeros = '';
    end

    sub_path = [sub_zeros int2str(sub_no) '0000'];
    file_id{L,9} = sub_path;

    % Determine the total number of hrus in subwatershed from .sub file
    fid1 = fopen([out_data_path '\' sub_path '.sub'],'r');
    L1 = 0;
    while feof(fid1) == 0;
        L1 = L1+1;
        line = fgets(fid1);
        if L1 == 2; sub_area = str2double(strtok(line))*100; %area of subbasin in ha
        elseif L1 == 53; n_hru=str2double(strtok(line)); end
    end
    fclose(fid1);
    file_id{L,10} = sub_area;
    for hru_no = 1:n_hru;
        LL = LL+1;
        if hru_no < 10;
            hru_zeros = '000';
        elseif hru_no >= 10 && hru_no < 100
            hru_zeros = '00';
        elseif hru_no >= 100 && hru_no < 1000
            hru_zeros = '0';
        elseif hru_no >= 1000
            hru_zeros = '';
        end
        hru_path = [sub_zeros int2str(sub_no) hru_zeros num2str(hru_no)];
        file_id{LL,1} = num2str(LL);
        file_id{LL,2} = num2str(sub_no);
        file_id{LL,3} = [sub_zeros int2str(sub_no) hru_zeros num2str(hru_no)];
        % Determine land use
        fid2 = fopen([out_data_path '\' hru_path '.hru'],'r');
        L2 = 0;
        while L2 < 2
            L2 = L2+1;
            if L2 == 1
                str = fgets(fid2);
                Luse = str(findstr('Luse:',str)+5:findstr('Luse',str)+8);
                file_id{LL,5} = Luse;
                flag_ag(1) = length(findstr('CORN',str));
                flag_ag(2) = length(findstr('SOYB',str));
                flag_ag(3) = length(findstr('WWHT',str));
                flag_ag(4) = length(findstr('AGRL',str));
                flag_ag(5) = length(findstr('AGRR',str));
                flag_ag(6) = length(findstr('AGRC',str));
                
                flag_ag(7) = length(findstr('CCRN',str));
                flag_ag(8) = length(findstr('CSOY',str));
                flag_ag(9) = length(findstr('CWHT',str));
                flag_ag(10) = length(findstr('CYCN',str));
                flag_ag(11) = length(findstr('SYCN',str));
                flag_ag(12) = length(findstr('SYWH',str));
                flag_ag(13) = length(findstr('WHCN',str));
                
                flag_past(1) = length(findstr('PAST',str));
                flag_past(2) = length(findstr('HAY',str));
                flag_past(3) = length(findstr('ALFA',str));
                flag_frst(1) = length(findstr('FRST',str));
                flag_frst(2) = length(findstr('FRSD',str));
                flag_frst(3) = length(findstr('FRSE',str));
                flag_urban(1) = length(findstr('URHD',str));
                flag_urban(2) = length(findstr('URMD',str));
                flag_urban(3) = length(findstr('URML',str));
                flag_urban(4) = length(findstr('URLD',str));
                flag_urban(5) = length(findstr('UCOM',str));
                flag_urban(6) = length(findstr('UIDU',str));
                flag_urban(7) = length(findstr('UTRN',str));
                flag_urban(8) = length(findstr('UINS',str));
            elseif L2 == 2
                str = fgets(fid2);
                hru_area = str2double(strtok(str))*sub_area;
                file_id{LL,4} = num2str(hru_area);
            end
        end
        fclose(fid2);
        if any(flag_ag) >= 1
            file_id{LL,6} = 'Row Crops'; % ID for crop lands.
        elseif any(flag_past) >= 1
            file_id{LL,6} = 'Pasture/Hay'; % ID for pasture and hay lands.
        elseif any(flag_frst) >= 1
            file_id{LL,6} = 'Forests'; % ID for forests.
        elseif any(flag_urban) >= 1
            file_id{LL,6} = 'Urban'; % ID for Urban.
        else
            file_id{LL,6} = 'Others'; % ID for other land use.
        end
        % Determine soil properties
        fid3 = fopen([out_data_path '\' hru_path '.sol'],'r');
        L3 = 0;
        while L3 <= 12
            L3 = L3+1;
            str = fgets(fid3);
            if L3 == 1                
                STMID = str(findstr('Soil:',str)+5:findstr('Soil',str)+9);
            elseif L3 == 2
                Soil_Name = str(findstr('Name:',str)+6:end-2);
                file_id{LL,7} = Soil_Name;
            elseif L3 == 3
                Hydro_Group = str(findstr('Group:',str)+7:findstr('Group:',str)+7);
                file_id{LL,8} = Hydro_Group;
            elseif L3 == 8
                depth = strread(str(28:end));
                file_id{LL,11} = depth;
            elseif L3 == 12
                SOL_CBN = strread(str(28:end));
                file_id{LL,12} = SOL_CBN;
            end           
        end
        fclose(fid3);
    end
end
fid = fopen([out_data_path '\file_id.prn'],'w');
format_line1 = [repmat('%-12s',1,9),'%-10s\n'];
fprintf(fid,format_line1,'hru_n','sub_n','hru_name','area (ha)',...
    'land use','landu flag','soil_name','hydro_g','sub_name',...
    'sub_a (ha)');
for i = 1:size(file_id,1)
    fprintf(fid,'%-12c',file_id{i,:}); fprintf(fid,'%c\v','');
end
fclose(fid);
return;