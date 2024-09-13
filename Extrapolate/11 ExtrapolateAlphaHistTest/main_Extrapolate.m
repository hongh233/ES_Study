function [distance, distanceAlpha] = Extrapolate(distanceTemp, distanceAlphaTemp)



predictedX = linspace(-2, 1, 400);


% observedX = [0.3745, 0.9507, 0.7320, 0.32, 0.6703];
% observedX = -2 * rand(1, 5) + 1;
observedX = rand(1, 5);
% observedX = 10 .^ (-rand(1,5));
[observedY, expr] = Obj1D(observedX);



[A, B, minDist] = minDistance(observedX);
theta = 0.5;
kernel = 1;

isNormalized = 0;
isRegularized = 0;
considerLambda = 1;
[predictedY, sigma, type, K, alpha] = GP(predictedX, observedX, observedY, ...
    theta, kernel, isNormalized, isRegularized, considerLambda);
distance1 = ploter(predictedX, predictedY, observedY);
distance = [distanceTemp, distance1];



isNormalized = 0;
isRegularized = 0;
considerLambda = 2;
[predictedY, sigma, type, K, alpha] = GP(predictedX, observedX, observedY, ...
    theta, kernel, isNormalized, isRegularized, considerLambda);
distance2 = ploter(predictedX, predictedY, observedY);
distanceAlpha = [distanceAlphaTemp, distance2];



end
