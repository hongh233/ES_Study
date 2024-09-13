function [numOfFuncUsed] = mainWithSimplexGradiant(functionType, n)
    global funcCallCount;
    funcCallCount = 0;

    funcIndex = functionType;  % 选择目标函数
    D = sqrt(1 + n);

    x = randn(n, 1);
    fx = ObjFunction(x, funcIndex);
    sigma = 1;


    xTrain = x;  
    yTrain = fx;


    m = n+1;

    for j = 1:(m-1)
        y = x + sigma * randn(n, 1);
        fy = ObjFunction(y, funcIndex);
        xTrain = [xTrain, y];    % n * n+1
        yTrain = [yTrain, fy];   % 1 * n+1
    end


    for i = 1:100000
        y = x + sigma * randn(n, 1);    % n * 1
        fy = ObjFunction(y, funcIndex); % 1 * 1

        A = xTrain' - repmat(y', m, 1);   % n+1 * n
        b = yTrain - repmat(fy, 1, m);    % 1 * n+1 
        g = inv(A' * A) * (A' * b');        % n * 1
        cos_theta = dot(g, y-x) / (norm(g) * norm(y-x));

        if cos_theta < 0  % theta > 90, nice!
            x = y;
            fx = fy;
            sigma = sigma * exp(0.8 / D);

            [~, maxIdx] = max(yTrain);
            xTrain(:, maxIdx) = [];
            yTrain(maxIdx) = [];
            xTrain = [xTrain, x];  % remove first, add last
            yTrain = [yTrain, fx];    % remove first, add last
        else
            sigma = sigma * exp(-0.2 / D);
        end


        if fx < 10^(-8)
            break;
        end
    end
    numOfFuncUsed = funcCallCount;
end