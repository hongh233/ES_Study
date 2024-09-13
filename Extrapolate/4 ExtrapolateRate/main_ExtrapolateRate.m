%% Seed
% rng(31);

%% predicted data
predictedX = linspace(-2, 1, 400);

%% training data
% observedX = [0.01, 0.08];
% observedX = -2 * rand(1, 5) + 1;
observedX = rand(1, 5);
observedY = Obj1D(observedX);
[A, B, minDist] = minDistance(observedX);
y_min = min(observedY);

hold on;

theta = 0.01;

for k = 1:500
    disp(k);
    theta = 0.01;
    for j = 1:1000
        % disp(theta);
        [predictedY, sigma, type, K] = GP(predictedX, observedX, observedY, theta, 1, y_min);
        if rcond(K) < 1.0 * exp(-14)
            scatter(minDist, theta, 'MarkerFaceColor', 'yellow', 'SizeData', 20);
            break;
        end
        theta = theta + 0.001;  % theta: 0.01 + 0.001 * iteration
    end
    observedX = rand(1, 20);
    observedY = Obj1D(observedX);
    [A, B, minDist] = minDistance(observedX);
    y_min = min(observedY);
end

% disp(observedX);


% >> set(gca,'xscale','log')
% >> set(gca,'yscale','log')
% >> hold on
% >> X = linspace(1e-4, 1, 21);
% >> plot(X, X)
% >> plot(X, 10*sqrt(X))
% >> plot(X, 8*X)



