function [settings, rho, sigma] = sim_settings(settings)
fid = fopen('..\02ControlFiles\optimization.set', 'r');
L   = 0;
while feof(fid) == 0
    L = L+1;
    line = fgets(fid);
    if L == 2
        settings.TxtInOut_path = strtrim(line);
    elseif L == 5
        settings.user_inputs_path = strtrim(line);
    elseif L == 8
        settings.out_path = strtrim(line);
    elseif L == 11
        settings.outlets = str2num(line);
    elseif L == 14
        settings.timesteps = str2num(line);
    elseif L == 17
        settings.ICALIB = str2num(line);
    elseif L == 20
        settings.OutVars = str2num(line);
    elseif L == 23
        settings.OFs = str2num(line);
    elseif L == 26
        settings.weights = str2num(line);        
    elseif L == 29
        sigma = str2num(line);
    elseif L == 32
        rho = str2num(line);
    elseif L == 35
        settings.Transformation = str2num(line);
    elseif L == 36
        settings.TransParameters = str2num(line);
    elseif L == 37
        settings.TransType = str2num(line);
    elseif L == 40
        settings.ApplyConstraints = str2num(line)';
    elseif L == 43
        settings.stdConstraints(:,1) = str2num(line)';
    elseif L == 44
        settings.stdConstraints(:,2) = str2num(line)';
    elseif L == 47
        settings.n_warmup = str2num(line);
    elseif L == 50
        settings.simdate(1,1:3) = str2num(line);
    elseif L == 51
        settings.simdate(2,1:3) = str2num(line);
    elseif L == 54
        settings.IndexIU = str2num(line);        
    elseif L == 57
        settings.IndexMU = str2num(line);
    elseif L == 60
        settings.COV = str2num(line);        
    end
end
fclose(fid);

if size(settings.timesteps,2) == 1 && ...
        any(size(settings.timesteps) ~= size(settings.outlets))
    settings.timesteps = ones(size(settings.outlets)) * ...
        settings.timesteps;
end

if size(settings.OutVars,2) == 1 && ...
        any(size(settings.OutVars) ~= size(settings.outlets))
    settings.OutVars = ones(size(settings.outlets)) * ...
        settings.OutVars;
end

if size(sigma,2) == 1 && ...
        any(size(sigma) ~= size(settings.outlets))
    sigma = ones(size(settings.outlets)) * ...
        sigma;
end

if size(rho,2) == 1 && ...
        any(size(rho) ~= size(settings.outlets))
    rho = ones(size(settings.outlets)) * ...
        rho;
end

if size(settings.weights,2) == 1 && ...
        any(size(settings.weights) ~= size(settings.outlets))
    settings.weights = ones(size(settings.outlets)) * ...
        settings.weights;
end

if size(settings.OFs,2) == 1 && ...
        any(size(settings.OFs) ~= size(settings.outlets))
    settings.OFs = ones(size(settings.outlets)) * ...
        settings.OFs;
end

if size(settings.Transformation,2) == 1 && ...
        any(size(settings.Transformation) ~= size(settings.outlets))
    settings.Transformation = ones(size(settings.outlets)) * ...
        settings.Transformation;
end

if size(settings.TransType,2) == 1 && ...
        any(size(settings.TransType) ~= size(settings.outlets))
    settings.TransType = ones(size(settings.outlets)) * ...
        settings.TransType;
end

if size(settings.TransParameters,2) == 1 && ...
        any(size(settings.TransParameters) ~= size(settings.outlets))
    settings.TransParameters = ones(size(settings.outlets)) * ...
        settings.TransParameters;
end

settings.Sim_F	= datenum(settings.simdate(1,1)+settings.n_warmup, settings.simdate(1,2), settings.simdate(1,3));
settings.Sim_L  = datenum(settings.simdate(2,:));

return