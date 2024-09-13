function [numOfFuncUsed] = mainWOSurr(functionType, n)
    
    funcIndex = functionType;      % choose the function 
    D = sqrt(1 + n);

    x = randn(n, 1);
    fx = ObjFunction(x, funcIndex);

    sigma = 1;
    numOfFuncUsed = 1;
    
    
    % (1+1)-ES
    for i = 1:100000
        y = x + sigma * randn(n, 1);
        fy = ObjFunction(y, funcIndex);
        numOfFuncUsed = numOfFuncUsed + 1;
        if fy >= fx
            sigma = sigma * exp(-0.2 / D);
        else
            x = y;
            fx = fy;
            sigma = sigma * exp(0.8 / D);
        end
    
        % Check for convergence
        if fx < 10^(-8)
            % disp('Optimization converged to the minimizer');
            break;
        end
    end
end