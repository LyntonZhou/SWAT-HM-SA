function [SimOut, n_DayinMonth, n_DayinYear, Constr_val, penalize] = swatmodel(Pars, Extra)
%% write into IPEAT_Para.set
labindex = 1;
Project_directory = [Extra.settings.out_path '\pool' num2str(labindex)];
current_TxtInOut  = [Extra.settings.out_path '\temp' num2str(labindex)];

write_into_par_file(Extra, Pars, Project_directory);
par_alter(Extra.settings.file_id, Extra.settings.n_sub, current_TxtInOut, Project_directory);

%% Run SWAT.exe
s= what; Prim_directory = s.path;
cd(Project_directory);
dos('swat2012rev664.exe');
cd(Prim_directory);
[SimOut, n_DayinMonth, n_DayinYear] = read_binary_rch(Project_directory,...
                                    sum(Extra.settings.out_id(2:11)), Extra.settings.IPRINT, Extra.settings.n_sub);
[penalize, Constr_val] = ReadStdConstraints([Project_directory '\output.std'], Extra.settings.ApplyConstraints, Extra.settings.stdConstraints);

% Save all Constraints
constraints_matfile = [Project_directory '\constraints.mat'];
if ~exist(constraints_matfile, 'file')
    new_Constraints = Constr_val; %#ok<*NASGU>
    save(constraints_matfile, 'new_Constraints');
else
    load(constraints_matfile);
    new_Constraints = [new_Constraints; Constr_val]; %#ok<NODEF>
    save(constraints_matfile, 'new_Constraints');
end
return


function write_into_par_file (Extra, new_value, Project_directory)
parameter_location  = Extra.Parlist.parameter_location;
filename            = [Project_directory '\IPEAT_Para.set'];

par_n       = Extra.Parlist.par_n;
Symbol      = Extra.Parlist.Symbol;
Input_File  = Extra.Parlist.Input_File;
units       = Extra.Parlist.units;
x0          = Extra.Parlist.x0;
par_f       = Extra.Parlist.par_f;
lb          = Extra.Parlist.lb;
ub          = Extra.Parlist.ub;

fid = fopen(filename, 'wt');
fprintf(fid, '%s\n', 'Parameter file:');
fprintf(fid, '%s\n', '    par_n      Symbol Input_File    units         x0     par_f        bl        bu');

x0(parameter_location) = new_value;
for k=1:length(par_n)    
    sym = Symbol{k};
    Inpf = Input_File{k};
    unt = units{k};
    fprintf(fid, '%10d %10s %9s %9s %10.4g %9d %9.4g %9.5g\n', ...
        par_n(k), sym, Inpf, unt,x0(k), par_f(k), lb(k), ub(k));
end
fclose(fid);

return