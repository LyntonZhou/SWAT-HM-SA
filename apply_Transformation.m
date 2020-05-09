function out = apply_Transformation(obs_select, sim_select, method, parameters, TransType)
switch TransType
    case 1 % Transform SIM and OBS separateley
        x = trans(obs_select, method, parameters);
        y = trans(sim_select, method, parameters);
        
        infLoc = find(x == inf | x == -inf);
        x(infLoc)=[];
        y(infLoc)=[];

        infLoc = find(y == inf | y== -inf);
        x(infLoc)=[];
        y(infLoc)=[];
        
        out(:,1) = x;
        out(:,2) = y;
    case 2 % Transform OBS - SIM
        residuals   = obs_select - sim_select;
        out         = trans(residuals, method, parameters);
end

return


function transformed = trans(Input, method, parameters)
switch method
    case 2  % Natural Log of data
        transformed = log(Input);
    case 3  % Box-Cox
        if isempty(parameters)
            if any(Input <= 0)
                transformed = boxcox(Input - min(Input) + .01);
            else
                transformed = boxcox(Input);
            end
        else
            if any(Input <= 0)
                transformed = boxcox(parameters(1), Input - min(Input) + .01);
            else
                transformed = boxcox(parameters(1), Input);
            end
        end
    case 4  % Manly
        if isempty(parameters)
            transformed = manly(Input);
        else
            transformed = manly(parameters(1), Input);
        end
    case 5  % Mudulus
        if isempty(parameters)
            transformed = modulus(Input);
        else
            transformed = modulus(parameters(1), Input);
        end
    case 6  % AR( . )
        %% AR-1
%         mx = arx(Input,1);
%         transformed(:,1) = Input - mx.A(1,2) * [Input(2:end) ;Input(1)];
    case 7  % ARMA( . , . )
%         if isempty(parameters)
%             Input = Input - mean(Input);
%             model = armax(Input, parameters);
%             estimated = predict(model, Input);
%             transformed = Input - estimated{1};
%         else
%             
%         end
end

return
