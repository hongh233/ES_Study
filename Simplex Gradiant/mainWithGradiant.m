function [numOfFuncUsed] = mainWithGradiant(functionType, n)
    global funcCallCount;
    funcCallCount = 0;

    funcIndex = functionType;
    D = sqrt(1 + n);

    x = randn(n, 1);
    fx = ObjFunction(x, funcIndex);
    sigma = 1;


    xTrain = x;  
    yTrain = fx;

    for i = 1:100000
        y = x + sigma * randn(n, 1);         % n * 1
        g = TrueGradient(x, funcIndex);      % n * 1
        funcCallCount = funcCallCount + 1;
        cos_theta = dot(g, y-x) / (norm(g) * norm(y-x));

        if cos_theta < 0  % theta > 90, nice!
            x = y;
            fx = ObjFunction(y, funcIndex);
            sigma = sigma * exp(0.6 / D);
        else
            sigma = sigma * exp(-0.2 / D);
        end


        if fx < 10^(-8)
            break;
        end
    end
    numOfFuncUsed = funcCallCount;
end