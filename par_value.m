function  par_x  = par_value(x, line, alter_method, lba, uba, symbol, par_name)
% change parameter values with alter method

par_idx = strcmp(symbol,par_name);
par_x = x(par_idx);
par_alter_method = alter_method{par_idx};
par_lba = lba(par_idx);
par_uba = uba(par_idx);

if ischar(line)
    
    if upper(par_alter_method) == 'V';
        
    elseif upper(par_alter_method) == 'R';
        par_x = (1+par_x) * str2double(strtok(line));
        if par_x > par_uba, par_x = par_uba; elseif par_x < par_lba, par_x = par_lba; end
    elseif upper(par_alter_method) == 'A'
        par_x = par_x + str2double(strtok(line));
        if par_x > par_uba, par_x = par_uba; elseif par_x < par_lba, par_x = par_lba; end
    else
        disp('use wrong alter method')
    end
    
elseif isnumeric(line) % for metal.dat
    
    if upper(par_alter_method) == 'V';
        
    elseif upper(par_alter_method) == 'R';
        par_x = (1+par_x) * line;
        if par_x > par_uba, par_x = par_uba; elseif par_x < par_lba, par_x = par_lba; end
    elseif upper(par_alter_method) == 'A'
        par_x = par_x + line;
        if par_x > par_uba, par_x = par_uba; elseif par_x < par_lba, par_x = par_lba; end
    else
        disp('use wrong alter method')
    end
    
end

end

