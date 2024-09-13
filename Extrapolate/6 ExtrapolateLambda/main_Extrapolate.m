% rng(31);

predictedX = linspace(-2, 1, 400);


% observedX = [0.3745, 0.9507, 0.7320, 0.32, 0.6703];
% observedX = -2 * rand(1, 5) + 1;
observedX = rand(1, 5);
% observedX = 10 .^ (-rand(1,5));
observedY = Obj1D(observedX);


[A, B, minDist] = minDistance(observedX);


thetaSet = [0.01, 0.1, 0.5, 1];




t = tiledlayout(4, 4);

isNormalized = 0;
isRegularized = 0;
considerLambda = 0;

for j = 1:2         % j is kernel
    for i = 1:4
        ax = nexttile;
        [predictedY, sigma, type] = GP(predictedX, observedX, observedY, thetaSet(i), j, isNormalized, isRegularized, considerLambda);
        ploter(ax, predictedX, predictedY, observedX, observedY, type, thetaSet(i));
    end
end

isNormalized = 0;
isRegularized = 0;
considerLambda = 1;

for j = 1:2         % j is kernel
    for i = 1:4
        ax = nexttile;
        [predictedY, sigma, type] = GP(predictedX, observedX, observedY, thetaSet(i), j, isNormalized, 0, considerLambda);
        ploter(ax, predictedX, predictedY, observedX, observedY, type, thetaSet(i));
    end
end
        







