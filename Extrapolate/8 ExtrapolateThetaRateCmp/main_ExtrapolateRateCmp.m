% rng(31);
hold on;

predictedX = linspace(-2, 1, 400);

% observedX = [0.01, 0.08];
% observedX = -2 * rand(1, 5) + 1;


% red is original, blue is using alpha and lambda
observedX = 10 .^ (-1 * rand(1, 20));
observedY = Obj1D(observedX);
[A, B, minDist] = minDistance(observedX);
for k = 1:100
    disp(k);
    theta = 0.01;
    for j = 1:1000
        [predictedY, sigma, type, K, alpha] = GP(predictedX, observedX, observedY, theta, 1, 0, 0, 0);
        if rcond(K) < 1.0 * exp(-14)
            scatter(minDist, theta, 'MarkerFaceColor', 'red', 'SizeData', 20);
            break;
        end
        theta = theta + 0.001;  % theta: 0.01 + 0.001 * iteration
    end
    observedX = 10 .^ (-1 * rand(1, 20));
    observedY = Obj1D(observedX);
    [A, B, minDist] = minDistance(observedX);
end



observedX = 10 .^ (-1 * rand(1, 20));
observedY = Obj1D(observedX);
[A, B, minDist] = minDistance(observedX);
for k = 1:100
    disp(k);
    theta = 0.01;
    for j = 1:1000
        [predictedY, sigma, type, K, alpha] = GP(predictedX, observedX, observedY, theta, 1, 0, 0, 2);
        if rcond(K) < 1.0 * exp(-14)
            scatter(minDist, theta, 'MarkerFaceColor', 'blue', 'SizeData', 20);
            break;
        end
        theta = theta + 0.001;  % theta: 0.01 + 0.001 * iteration
    end
    observedX = 10 .^ (-1 * rand(1, 20));
    observedY = Obj1D(observedX);
    [A, B, minDist] = minDistance(observedX);
end


% >> set(gca,'xscale','log')
% >> set(gca,'yscale','log')
% >> hold on
% >> X = linspace(1e-4, 1, 21);
% >> plot(X, X)
% >> plot(X, 10*sqrt(X))
% >> plot(X, 8*X)



