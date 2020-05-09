% This script selects hrus whith ag land use
function [hru_s,hru_s_id]=hru_select(file_id,n_hru)
       
% Select HRUs with agricultural land use
L=0;
for i=1:n_hru
    if  file_id{i,7}==1
        L=L+1;
        hru_s(L,1)=file_id{i,1};
        hru_s(L,2)=file_id{i,4};
        hru_s_id{L,1}=file_id{i,6};
    end
end
% ...