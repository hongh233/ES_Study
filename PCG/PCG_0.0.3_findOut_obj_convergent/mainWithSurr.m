function [numOfFuncUsed] = mainWithSurr(functionType, dimension, archive)
    global observe_function_value;
    observe_function_value = 100;
    funcIndex = functionType;
    
    c1 = 0.05;
    c2 = 0.2;
    c3 = 0.6;

    D = sqrt(1 + dimension);
    observedX = zeros(dimension, archive);
    observedY = zeros(1, archive);
    numOfFuncUsed = 0;

    x = randn(dimension, 1);
    fx = ObjFunction(x, funcIndex);

    sigma = 1/dimension;

    for i = 1:archive
        y = x + sigma * randn(dimension, 1);
        fy = ObjFunction(y, funcIndex);
        numOfFuncUsed = numOfFuncUsed + 1;
        if fy >= fx
            sigma = sigma * exp(-0.2 / D);
        else
            x = y;
            fx = fy;
            sigma = sigma * exp(0.8 / D);

        end
        observedX = [observedX(:, 2:end), y];
        observedY = [observedY(2:end), fy];
    end
    
    
    % (1+1)-ES
    sigma = 1/dimension;
    fx = ObjFunction(x, funcIndex);


    for i = 1:10000000000000
        y = x + sigma * randn(dimension, 1);
        observe_function_value = ObjFunction(y, funcIndex);
        predictedY = GP(y, observedX, observedY, fx, 8 * sigma * dimension, 1);
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
            observedX(:, 1) = [];
            observedY(1) = [];
            observedX = [observedX, y];
            observedY = [observedY, fy];

            if fx < 1.0e-08
                break;
            end
        end

    end
end

