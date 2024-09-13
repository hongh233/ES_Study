function [numOfFuncUsed, ...
    truePositiveRate_surr, ...
    falsePositiveRate_surr, ...
    truePositiveRate_gradient, ...
    falsePositiveRate_gradient] = experimentOnSimplex(functionType, n)
    
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


    truePositive_surr = 0;
    falsePositive_surr = 0;
  
    truePositive_gradient = 0;
    falsePositive_gradient = 0;

    totalPositive = 0;
    totalNegative = 0;
    

    for i = 1:100000
        y = x + sigma * randn(n, 1);
        predictedY = GPBetter(y, observedX, observedY, fx, 8 * sigma * sqrt(n));
        g = TrueGradient(x, funcIndex);
        cos_theta = dot(g, y-x) / (norm(g) * norm(y-x));

        if ObjFunction(y, funcIndex) < fx
            totalPositive = totalPositive + 1;
        else
            totalNegative = totalNegative + 1;
        end

        if cos_theta < 0
            if ObjFunction(y, funcIndex) < fx
                truePositive_gradient = truePositive_gradient + 1;
            else
                falsePositive_gradient = falsePositive_gradient + 1;
            end
        end

        if predictedY >= fx
            sigma = sigma * exp(-c1 / D);
        else

            fy = ObjFunction(y, funcIndex);
            numOfFuncUsed = numOfFuncUsed + 1;
            if fy > fx
                falsePositive_surr = falsePositive_surr + 1;
                sigma = sigma * exp(-c2 / D);
            else
                truePositive_surr = truePositive_surr + 1;
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
    end

    disp(["total iteration: " , i]);
    disp(["true positive surr: ", truePositive_surr]);
    disp(["false positive surr: ", falsePositive_surr]);
    disp(["true positive gradient: ", truePositive_gradient]);
    disp(["false positive gradient: ", falsePositive_gradient]);
    disp(["total positive ", totalPositive]);

    truePositiveRate_surr = truePositive_surr / totalPositive;
    falsePositiveRate_surr = falsePositive_surr / totalNegative;
    truePositiveRate_gradient = truePositive_gradient / totalPositive;
    falsePositiveRate_gradient = falsePositive_gradient / totalNegative;

    disp(["surrogate true positive ratio: ", truePositiveRate_surr]);
    disp(["surrogate false positive ratio: ", falsePositiveRate_surr]);
    disp(["gradient true positive ratio: ", truePositiveRate_gradient]);
    disp(["gratient false positive ratio: ", falsePositiveRate_gradient]);

end

