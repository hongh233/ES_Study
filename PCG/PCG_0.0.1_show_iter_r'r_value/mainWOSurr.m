function [numOfFuncUsed] = mainWOSurr(functionType, dimension, archive)
    global sample;
    funcIndex = functionType;      % choose the function 
    D = sqrt(1 + dimension);
    x = randn(dimension, 1);
    sigma = 1;
    
    
    % (1+1)-ES
    for numOfFuncUsed = 1:100000
        sample(numOfFuncUsed, 1) = x;
        sample(numOfFuncUsed, 2) = sigma;
        y = x + sigma * randn(dimension, 1);
    
        if ObjFunction(y, funcIndex) >= ObjFunction(x, funcIndex)
            sigma = sigma * exp(-0.2 / D);
        else
            x = y;
            sigma = sigma * exp(0.8 / D);
        end
    
        % Check for convergence
        if ObjFunction(x, funcIndex) < 10^(-8)
            % disp('Optimization converged to the minimizer');
            break;
        end
    end



end