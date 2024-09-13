rng(33);
hold on;
predictedX = linspace(-2, 1, 400);


% observedX = [0.3745, 0.9507, 0.7320, 0.32, 0.6703];
% observedX = -2 * rand(1, 5) + 1;
% observedX = 10 .^ (-rand(1,5));
observedX = rand(1, 5);
observedX = [0.000000001, 0.00000001, 0.7325, 0.9507];  % Thin plate spline(singular)
observedX = [0.0001, 0.00001, 0.7325, 0.9507];          % Thin plate spline(not good)
observedX = [0.001, 0.0001, 0.7325, 0.9507];            % Thin plate spline(good)
observedX = [0.00000000001, 0.000000000001, 0.7325, 0.9507];  % linear(no blue)
observedX = [0.0000000001, 0.00000000001, 0.7325, 0.9507];  % linear(has blue)
observedX = [0.3, 0.99999];  % linear(try)



observedY = Obj1D(observedX);


[A, B, minDist] = minDistance(observedX);


thetaSet = [0.01,0.1,1,10];


% t = tiledlayout(2, 4);

isNormalized = 0;
isRegularized = 0;
considerLambda = 1;
kernel = 4;


for i = 1:4
    ax = nexttile;
    [predictedY, sigma, type] = GP(predictedX, observedX, observedY, thetaSet(i), kernel, isNormalized, isRegularized, considerLambda);
    ploter(ax, predictedX, predictedY, observedX, observedY, type, thetaSet(i));
end








