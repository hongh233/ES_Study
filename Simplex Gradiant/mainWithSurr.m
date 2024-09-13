function [numOfFuncUsed] = mainWithSurr(functionType, n)

    funcIndex = functionType;      % choose the function
    
    c1 = 0.05;
    c2 = 0.2;
    c3 = 0.6;

    D = sqrt(1 + n);
    observedX = [];
    observedY = [];

    x = randn(n, 1);
    fx = ObjFunction(x, funcIndex);
    numOfFuncUsed = 1;

    sigma = 1/n;
    
    
    for i = 1:40
        y = x + sigma * randn(n, 1);
        fy = ObjFunction(y, funcIndex);
        numOfFuncUsed = numOfFuncUsed + 1;
        % [fx, fy]
        if fy >= fx
            sigma = sigma * exp(-0.2 / D);
        else
            x = y;
            fx = fy;
            sigma = sigma * exp(0.8 / D);
        end
        observedX = [observedX, y];
        observedY = [observedY, fy];
    end
    
    % arrFunc = zeros(2000000, 2);

    for i = 1:2000000
        y = x + sigma * randn(n, 1);
        predictedY = GPBetter(y, observedX, observedY, fx, 8 * sigma * sqrt(n));
        if predictedY >= fx
            sigma = sigma * exp(-c1 / D);
        else
            fy = ObjFunction(y, funcIndex);
            numOfFuncUsed = numOfFuncUsed + 1;
            if fy >= fx
                sigma = sigma * exp(-c2 / D);
            else
                x = y;
                fx = fy;
                sigma = sigma * exp(c3 / D);
            end

            [~, maxIdx] = max(observedY);
            % maxIdx = 1;
            observedX(:, maxIdx) = [];
            observedY(maxIdx) = [];
            observedX = [observedX, y];
            observedY = [observedY, fy];

            % Check for convergence
            if fx < 1.0e-08
                break;
            end
        end

        % arrFunc(i, :) = [fy ; sigma];
    end

    % semilogy(1:2000000, arrFunc);
end

