% rng(31);

predictedX = linspace(-5, 5, 400);

% observedX = [0.3745, 0.9507, 0.7320, 0.32, 0.6703];
% observedX = -2 * rand(1, 5) + 1;
observedX = rand(1, 5);
observedY = Obj1D(observedX);


hold on;

theta = 0.01;
kernel = 1;
isNormalized = 0;
isRegularized = 0;
interpolateMode = 2;

for k = 1:500
    [predictedY, sigma, type, alpha] = GP(predictedX, observedX, observedY, ...
        theta, kernel, isNormalized, isRegularized, interpolateMode);
    scatter(theta, alpha, 'blue');
    theta = theta + 0.01;
end

% red: x^2 - 1
% green: x^2 - 10
% blue: x^2 + 1
% yello: x^2 + 10




