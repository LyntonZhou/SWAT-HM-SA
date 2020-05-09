function out = mytomonthly(in, Sim_F, Sim_L, ICALIB)
dates = datevec(Sim_F : Sim_L);
days  = dates(:,3);
firstday = find(days==1);
lastday  = [firstday(2:end)-1; size(dates, 1)];
out = zeros(size(firstday,1),size(in,2));
for i=1:size(lastday,1)
    out(i,:) = main(in(firstday(i) : lastday(i),:), ICALIB);
end
out(isnan(out)) = -99;
return
% 'Stream Flow'; 'sediment'; 'org-N'; 'org-P'; 'NO_3-N'
% 'NH_4-N'; 'NO_2-N'; 'Mineral-P'; 'Soluble Pesticide'; 'Sorbed Pesticide'
% 'Total Phosphorus'; 'Total Nitrogen'; 'Total Pesticide'; 'TKN'; 'NO2+NO3-N'

function out = main(in, ICALIB)
% replace -999.99 and -99 with NaN
in(in==-999.99)= NaN;
in(in==-99)= NaN;

% streamflow
sf      = in(:,1);
out(1)  = mean(sf);

% sediment
switch ICALIB(1)
    case 0
        out(2) = sum(in(:,2));
    case 1
        out(2) = (in(:,2)' * sf)/sum(sf);
end

% nutrient
coln = [3:8,11:12,14:15];
switch ICALIB(2)
    case 0
        out(coln) = sum(in(:,coln));
    case 1
        out(coln) = (in(:,coln)' * sf) / sum(sf);
end

% pesticide
coln = [9:10,13];
switch ICALIB(3)
    case 0
        out(coln) = sum(in(:,coln));
    case 1
        out(coln) = (in(:,coln)' * sf) / sum(sf);
end