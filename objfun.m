function objfun(n_sub, sensin_path)
%% Determine the id for input file
[file_id]=id_func(n_sub);

% Adjust input parameters
alter_f=par_alter(file_id, n_sub, sensin_path);
disp(alter_f)
% %% Call the SWAT model
% dos('swat2005.exe');