function error_out(Stats, outlet_no,out_data_path)
fid_err=fopen([out_data_path '\error_out' num2str(outlet_no) '.txt'],'w');

line1={'';'BASEFLOW';'SF';'SED';'ORGN';'ORGP';'NO3N';'NH4N';'NO2N';'MINP';...
       'SOLPST';'SORPST';'TP';'TN';'TPST'};
%% Heading
for i=1:length(line1)
    fprintf(fid_err, '%-10s',line1{i});
end
fprintf(fid_err, '\n');
%% Main Contents
fprintf(fid_err, '%-10s%-8.4g\n','BFR(%)',Stats.BFR);

fprintf(fid_err, '%-10s%-10s','RE','-');
for i=1:13, fprintf(fid_err, '%-10.4g', Stats.RE(i)); end
fprintf(fid_err, '\n');

fprintf(fid_err, '%-10s%-10s','BIAS','-');
for i=1:13, fprintf(fid_err, '%-10.4g', Stats.BIAS(i)); end
fprintf(fid_err, '\n');

fprintf(fid_err, '%-10s%-10s','SSE','-');
for i=1:13, fprintf(fid_err, '%-10.4g', Stats.SSE(i)); end
fprintf(fid_err, '\n');

fprintf(fid_err, '%-10s%-10s','RMSE','-');
for i=1:13, fprintf(fid_err, '%-10.4g', Stats.RMSE(i)); end
fprintf(fid_err, '\n');

fprintf(fid_err, '%-10s%-10s','R2','-');
for i=1:13, fprintf(fid_err, '%-10.4g', Stats.R2(i)); end
fprintf(fid_err, '\n');

fprintf(fid_err, '%-10s%-10s','NS','-');
for i=1:13, fprintf(fid_err, '%-10.4g', Stats.NS(i)); end

fclose (fid_err);