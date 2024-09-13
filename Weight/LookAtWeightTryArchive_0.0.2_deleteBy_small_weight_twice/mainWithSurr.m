function [numOfFuncUsed] = mainWithSurr(functionType, dimension, archive)
    archive_max = 80;
    global minWeight;
    global maxWeight;
    global navigation;
    funcIndex = functionType;      % choose the function
    
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
        [predictedY, K, ~, Ks] = GP(y, observedX, observedY, fx, 8 * sigma * dimension, 1);
        weight = ((Ks.' * inv(K)) .* observedY) / ObjFunction(y, funcIndex);
        
        for i1 = 1:archive
            if abs(weight(i1)) < 1.0e-4
                navigation(i1) = navigation(i1) + 1;
            else
                navigation(i1) = 0;
            end
        end

        decrease_hit = 0;
        for i1 = 1:archive
            if navigation(i1) == 1
                decrease_hit = decrease_hit + 1;
                weight(i1) = NaN;
                observedX(:, i1) = NaN;
                observedY(i1) = NaN;
            end
        end

        nanIndices = isnan(weight);
        weight(nanIndices) = [];
        disp(length(weight));

        observedX(:, nanIndices) = [];
        observedY(nanIndices) = [];
        archive = archive - decrease_hit;



        [predictedY, K, thetaTemp, Ks] = GP(y, observedX, observedY, fx, 8 * sigma * dimension, 1);
        weight = ((Ks.' * inv(K)) .* observedY) / ObjFunction(y, funcIndex);
        

        minWeight(i) = min(abs(weight));
        maxWeight(i) = max(abs(weight));
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

            if archive >= archive_max
                [~, deleteIdx] = max(observedY);
                observedX(:, deleteIdx) = [];
                observedY(deleteIdx) = [];
                navigation(deleteIdx) = [];
                archive = archive - 1;
            end

            observedX = [observedX, y];
            observedY = [observedY, fy];
            navigation = [navigation, 0];
            archive = archive + 1;

            % Check for convergence
            if fx < 1.0e-08
                break;
            elseif fx < 1.0e-07
                archive_max = 120;
            elseif fx < 1.0e-06
                archive_max = 110;
            elseif fx < 1.0e-05
                archive_max = 90;
            end
        end
   
    end
end

