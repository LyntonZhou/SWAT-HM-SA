function err_heading(fid_err)
line1={'SF';'SED';'ORGN';'ORGP';'NO3N';'NH4N';'NO2N';'MINP';'SOLPST';...
       'SORPST';'TP';'TN';'TPST';'TKN';'NO2+NO3'};
error_terms = sprintf('%-13s','RE(%)','BIAS','R2','E_NS','RMSE','SSE');
line2=repmat(error_terms,1,15);
fprintf(fid_err,'%-7s','ICALL');
fprintf(fid_err,'%-8s','Outlet');
fprintf(fid_err,'%-13s','BaseFlow');
fprintf(fid_err,'%-78s',line1{:}); 
fprintf(fid_err,'%s\n','');
fprintf(fid_err,'%-15s','');
fprintf(fid_err,'%-13s','(%)');
fprintf(fid_err,'%-10s',line2); 
fprintf(fid_err,'%s\n','');