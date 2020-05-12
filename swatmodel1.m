function [SimOut, n_DayinMonth, n_DayinYear, Constr_val, penalize] = swatmodel1(labindex, Pars, Extra)
%% write into IPEAT_Para.set
% labindex = 1;
Project_directory = [Extra.settings.out_path '\pool' num2str(labindex)];
current_TxtInOut  = [Extra.settings.out_path '\temp' num2str(labindex)];

disp('_______________________________________')
disp('strat altering model parameters')
write_into_par_file(Extra, Pars, Project_directory);
alter_f=par_alter(Extra.settings.file_id, Extra.settings.n_sub, current_TxtInOut, Project_directory);
disp(alter_f)
disp('_______________________________________')

%% Run SWAT.exe
s= what; Prim_directory = s.path;
cd(Project_directory);
dos('swat.exe');
cd(Prim_directory);

[SimOut, n_DayinMonth, n_DayinYear] = read_rch(Project_directory);

% [SimOut, n_DayinMonth, n_DayinYear] = read_binary_rch(Project_directory,...
%                                     sum(Extra.settings.out_id(2:11)), Extra.settings.IPRINT, Extra.settings.n_sub);

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
par_location  = Extra.Parlist.par_location;
filename            = [Project_directory '\IPEAT_Para.set'];

par_n       = Extra.Parlist.par_n;
Symbol      = Extra.Parlist.Symbol;
Input_File  = Extra.Parlist.Input_File;
units       = Extra.Parlist.units;
x0          = Extra.Parlist.x0;
par_f       = Extra.Parlist.par_f;
lb          = Extra.Parlist.lb;
ub          = Extra.Parlist.ub;
alter_m     = Extra.Parlist.Alter_method;
lba         = Extra.Parlist.lb_absolute;
uba         = Extra.Parlist.ub_absolute;

fid = fopen(filename, 'wt');
fprintf(fid, '%s\n', 'Parameter file:');
fprintf(fid, '%s\n', '     par_n          Symbol  Input_File     units         x0     par_f        lb        ub    alter_M      lb_a      ub_a');

x0(par_location) = new_value;
for k=1:length(par_n)    
    sym = Symbol{k};
    Inpf = Input_File{k};
    unt = units{k};
    am = alter_m{k};
    fprintf(fid, '%10d %15s %11s %9s %10.4g %9d %9.4g %9.5g %10s %9.5g %9.5g\n', ...
        par_n(k), sym, Inpf, unt, x0(k), par_f(k), lb(k), ub(k), am, lba(k), uba(k));
end
fclose(fid);

return