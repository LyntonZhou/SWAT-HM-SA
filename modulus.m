function [bct, bclambda] = modulus(varargin)
% modulus transforms non-normally distributed data to normally distributed data.
%
%   [TRANSDAT, LAMBDA] = modulus(DATA) transforms the data vector DATA using
%   the Modulus Transformation method into the vector TRANSDAT.  It also 
%   calculates the transformation parameter LAMBDA.  DATA could be negative.
%   The Modulus Transformation is the family of power transformation:
%
%      DATA(LAMBDA) = sign(data) * ((abs(DATA)+1)^LAMBDA - 1) / LAMBDA;     if LAMBDA ~= 0,
%
%   or
%
%      DATA(LAMBDA) = sign(data) * log(abs(DATA)+1);     if LAMBDA == 0.
%
% The algorithm calls for finding the LAMBDA value that maximizes the
% Log-Likelihood Function (LLF).  The search is conducted using FMINSEARCH.
%
%   TRANSDAT = modulus(LAMBDA, DATA) transforms the data vector DATA using
%   a certain specified LAMBDA for the Modulus Transformation.  This syntax
%   does not find the optimum LAMBDA that maximizes the LLF.  DATA must be 
%   positive.
%
%   Example:   load disney.mat
%              dis_CloseBC = modulus(dis_CLOSE);
%              hist(dis_CloseBC);
%
%   See also FMINSEARCH.

%   Author: Mahdi Ahmadi, 08-09-2010, John and Draper(1980) 
%   (structure used from P. N. Secakusuma, 01-08-98, for modulus transformation)
%   Copyright 1995-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $   $Date: 2005/12/12 23:17:38 $

% Input checks.
switch nargin
case 1      % Syntax:  BCT = modulus(DATA);
    flag = 0;
case 2      % Syntax:  BCT = modulus(LAMBDA, DATA);
    flag = 1;
case 3      % Syntax:  BCT = modulus(LAMBDA, DATA, FLAG);
    flag = varargin{3};
otherwise   % Error if number of input arguments is not 1, 2, or 3.
    error('Ftseries:ftseries_modulus:TooManyInputArguments', ...
       'Too many input arguments. Maximum of 3 inputs.');
end

% SWITCH yard for function calls.
switch flag
case 0  % The gateway; this is where this function starts.
    % Get the data vector.
    x = varargin{1};
    if size(x, 1) ~= 1 & size(x, 2) ~= 1
        error('Ftseries:ftseries_modulus:InputMustBeVector', ...
           'Input DATA must be a vector.');
    end
    % Find the lambda that minimizes of the Log-Likelihood function;
    % FMINSEARCH is used here so that we don't need to provide a set
    % of boundary initial conditions.  We only need a number as the 
    % starting point of search.
    options = optimset('MaxFunEvals', 2000, 'Display', 'off');
    bclambda = fminsearch('modulus', 0, options, x, 2);
    
    % Generate the transformed data using the optimal lambda.
    bct = modulus(bclambda, x, 1);
case 1   % Calculates the Modulus Transformation of data vector.
    % Get the lambda and data vectors.
    lambda = varargin{1};
    x = varargin{2};
    
    % Get the length of the data vector.
    n = length(x);
    
    % Make sure that the lambda vector is a column vector.
    lambda = lambda(:);
    
    % Pre-allocate the matrix for the transformed data vector, xhat.
    xhat = zeros(length(x), length(lambda));
    
    % Find where the non-zero and zero lambda's are.
    nzlambda = find(lambda ~= 0);
    zlambda = find(lambda == 0);
    
    % Create a matrix of the data by replicating the data vector 
    % columnwise.
    mx = x * ones(1, length(lambda));
    
    % Create a matrix of the lambda by replicating the lambda vector 
    % rowwise.
    mlambda = (lambda * ones(length(x), 1)')';
    
    % create the sign matrix of the data
    signmx = sign(x) * ones(1, length(lambda));
    
    % Calculate the transformed data vector, xhat.
    bct(:, nzlambda) = signmx(:,nzlambda) .* (((abs(mx(:, nzlambda)+1)).^mlambda(:, nzlambda))-1) ./ ...
        mlambda(:, nzlambda);
    bct(:, zlambda) = signmx(:, zlambda) .* log(abs(mx(:, zlambda))+1);
case 2   % The Log-Likelihood function (LLF) to be minimized.
    % Get the lambda and data vectors.
    lambda = varargin{1};
    x = varargin{2};
    
    % Get the length of the data vector.
    n = length(x);
    
    % Transform data using a particular lambda.
    xhat = modulus(lambda, x, 1);
    
    % The algorithm calls for maximizing the LLF; however, since we have
    % only functions that minimize, the LLF is negated so that we can 
    % minimize the function instead of maximixing it to find the optimum
    % lambda.
    bct = -(n/2).*log(std(xhat', 1, 2).^2) + (lambda-1)*(sum(log(x)));
    bct = -bct;
end

% [EOF]