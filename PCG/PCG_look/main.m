% Define xTest for different ranges
xTest_full = linspace(-0.2, 0.2, 400);
functionType = 3;


xTrain = [
    0.1, 0.2, 1, 2, 10, 20
];
xTrain = xTrain / 10;



dis = minDistance(xTrain);




% Generate step size sigma
% Associated new theta would be ratio of sigma

theta = zeros(1,length(xTrain));
upperbound = upperBoundFounder(xTrain);
upperbound_decrease = 10 ^ (log10(upperbound) - 2);
theta_used = upperbound - upperbound_decrease;

disp(" ");
disp(theta_used);
theta = theta + theta_used;











fTrain = objectiveFunction(xTrain, functionType);
predictedY_full = GP(xTest_full, xTrain, fTrain, theta);


% Plot the objective function and predicted values
figure;
hold on;
for i = 1:length(xTrain)
    if (xTrain(i) >= xTest_full(1)) && (xTrain(i) <= xTest_full(length(xTest_full)))
        plot(xTrain(i), fTrain(i), 'ro', 'MarkerSize', 8, 'DisplayName', 'Training Points');
    end
end
[trueY_full, ~] = objectiveFunction(xTest_full, functionType);
plot(xTest_full, trueY_full, 'b-', 'LineWidth', 2, 'DisplayName', 'Objective Function (Full Range)');
minTrainVal = min(fTrain);
for i = 1:length(xTest_full)-1
    if predictedY_full(i) < minTrainVal
        plot(xTest_full(i:i+1), predictedY_full(i:i+1), 'r--', 'LineWidth', 2, 'Color', 'r');
    else
        plot(xTest_full(i:i+1), predictedY_full(i:i+1), 'g--', 'LineWidth', 2, 'Color', 'g');
    end
end

% Create annotation for model function
hLegend = legend('Training Points', 'Objective Function (Full Range)', 'Location', 'Best');
set(hLegend, 'Location', 'Best');
line(NaN, NaN, 'LineStyle', '-', 'Color', 'r', 'LineWidth', 2, 'DisplayName', 'Predicted Function < Min Training Point');
line(NaN, NaN, 'LineStyle', '-', 'Color', 'g', 'LineWidth', 2, 'DisplayName', 'Predicted Function >= Min Training Point');

% Create annotation for xTrain points
str = sprintf('xTrain points:\n');
for i = 1:length(xTrain)
    str = sprintf('%s%0.8f\n', str, xTrain(i));
end
annotation('textbox', [0.15, 0.5, 0.1, 0.4], 'String', str, 'FitBoxToText', 'on', ...
    'BackgroundColor', 'white', 'FontSize', 6);
title('Predictions using GP with Inverse Matrix Method');
hold off;










% Compute predictions using GP with conjugate gradient method
predictedY_full_CG = GP_CG(xTest_full, xTrain, fTrain, theta);

% Plot the objective function and predicted values using GP_CG
figure;
hold on;
for i = 1:length(xTrain)
    if (xTrain(i) >= xTest_full(1)) && (xTrain(i) <= xTest_full(length(xTest_full)))
        plot(xTrain(i), fTrain(i), 'ro', 'MarkerSize', 8, 'DisplayName', 'Training Points');
    end
end
plot(xTest_full, trueY_full, 'b-', 'LineWidth', 2, 'DisplayName', 'Objective Function (Full Range)');
minTrainVal = min(fTrain);
for i = 1:length(xTest_full)-1
    if predictedY_full_CG(i) < minTrainVal
        plot(xTest_full(i:i+1), predictedY_full_CG(i:i+1), 'r--', 'LineWidth', 2, 'Color', 'r');
    else
        plot(xTest_full(i:i+1), predictedY_full_CG(i:i+1), 'g--', 'LineWidth', 2, 'Color', 'g');
    end
end

% Create annotation for model function
hLegend = legend('Training Points', 'Objective Function (Full Range)', 'Location', 'Best');
set(hLegend, 'Location', 'Best');
line(NaN, NaN, 'LineStyle', '-', 'Color', 'r', 'LineWidth', 2, 'DisplayName', 'Predicted Function < Min Training Point');
line(NaN, NaN, 'LineStyle', '-', 'Color', 'g', 'LineWidth', 2, 'DisplayName', 'Predicted Function >= Min Training Point');

% Create annotation for xTrain points
str = sprintf('xTrain points:\n');
for i = 1:length(xTrain)
    str = sprintf('%s%0.8f\n', str, xTrain(i));
end
annotation('textbox', [0.15, 0.5, 0.1, 0.4], 'String', str, 'FitBoxToText', 'on', ...
    'BackgroundColor', 'white', 'FontSize', 6);
title('Predictions using GP with Conjugate Gradient Method');
hold off;










function [predictedY] = GP(xTest, xTrain, fTrain, theta)
    theta_K = repmat(theta', 1, length(xTrain));
    d1 = pdist2(xTrain', xTrain', 'euclidean');
    K = exp(-(d1./theta_K).^2/2).';
    condK = cond(K);
    fprintf('Condition number of K: %.3e\n', condK); 
    
    [~, n] = size(xTest);
    theta_Ks = repmat(theta', 1, n);
    d2 = pdist2(xTrain', xTest', 'euclidean');
    Ks = exp(-(d2./theta_Ks).^2/2).';

    predictedY = Ks * (K \ fTrain');
end

function [val, name] = objectiveFunction(x, index)
    [n, m] = size(x);
    switch index
        case 1
            val = sum(x.^2, 1).^(1/2);
            name = 'linear sphere';
        case 2
            val = sum(x.^2, 1);
            name = 'quadratic sphere';
        case 3
            val = sum(x.^2, 1).^(3/2); 
            name = 'cubic sphere';
        case 4
            val = zeros(1, m);
            for j = 1:m
                for i = 1:n
                    val(j) = val(j) + sum(x(1:i, j))^2;
                end
            end
            name = 'Schwefel''s function';
        case 5
            beta = 1;
            val = zeros(1, m);
            for j = 1:m
                if n == 1
                    val(j) = beta * (x(1, j) - x(1, j).^2).^2 + (1 - x(1, j)).^2;
                else
                    for i = 2:n
                        val(j) = val(j) + beta * (x(i, j) - x(i-1, j).^2).^2 + (1 - x(i-1, j)).^2;
                    end
                end
            end
            name = 'quartic function';
        otherwise
            val = 'Error';
            name = 'Error';
    end
end

function minDist = minDistance(observedX)
    minDist = Inf;
    numPoints = size(observedX, 2);
    for i = 1:numPoints
        for j = i+1:numPoints
            dist = norm(observedX(:, i) - observedX(:, j));
            if dist < minDist
                minDist = dist;
            end
        end
    end
end







function predictedY = GP_CG(xTest, xTrain, fTrain, theta)
    theta_K = repmat(theta', 1, length(xTrain));
    d1 = pdist2(xTrain', xTrain', 'euclidean');
    K = exp(-(d1./theta_K).^2/2).';
    condK = cond(K);
    fprintf('Condition number of K: %.3e\n', condK); 
    
    [~, n] = size(xTest);
    theta_Ks = repmat(theta', 1, n);
    d2 = pdist2(xTrain', xTest', 'euclidean');
    Ks = exp(-(d2./theta_Ks).^2/2).';

    % 使用共轭梯度法求解线性系统
    mu = 0; % Assume a zero mean function for simplicity
    b = fTrain' - mu; % Adjust fTrain by subtracting the mean
    [alpha, residual_values] = conjugate_gradient_method(K, b, 1e-6, 1000); % 求解 alpha

    predictedY = Ks * alpha + mu; % Predicted values
    
    % Plot residual values
    figure;
    plot(1:length(residual_values), residual_values, 'o-');
    xlabel('Iteration');
    ylabel('(r - \alpha \cdot Ap)^T(r - \alpha \cdot Ap)');
    title('Convergence of Conjugate Gradient Method');
    grid on;
end

function [x, residual_values] = conjugate_gradient_method(A, b, tol, maxIter)
    x = zeros(size(b)); % 初始解
    r = b - A * x; % 初始残差
    p = r; % 初始方向
    rsold = r' * r; % 残差平方和
    residual_values = zeros(maxIter, 1);

    for i = 1:maxIter
        Ap = A * p;
        alpha = rsold / (p' * Ap); % 计算步长
        x = x + alpha * p; % 更新解
        r = r - alpha * Ap; % 更新残差
        residual_values(i) = r' * r; % 保存每次迭代的 (r - \alpha \cdot Ap)^T(r - \alpha \cdot Ap)
        rsnew = residual_values(i); % 更新残差平方和
        disp(rsnew);
        if sqrt(rsnew) < tol % 检查收敛性
            residual_values = residual_values(1:i); % Trim to actual iterations
            break;
        end

        p = r + (rsnew / rsold) * p; % 更新方向
        rsold = rsnew; % 更新残差平方和
    end
end

