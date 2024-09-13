rng(37);

predictedX = linspace(-2, 1, 400);


% observedX = [0.3745, 0.9507, 0.7320, 0.32, 0.6703];
% observedX = -2 * rand(1, 5) + 1;
observedX = rand(1, 5);
% observedX = 10 .^ (-rand(1,5));
rng(2);

[observedY, expr] = Obj1D(observedX);




figure;
ax = gca;


[A, B, minDist] = minDistance(observedX);
theta = 0.5;


isNormalized = 0;
isRegularized = 0;
considerLambda = 1;
kernel = 1;
power = 2;
[predictedY, sigma, type, K, alpha] = GP(predictedX, observedX, observedY, ...
    theta, kernel, power, isNormalized, isRegularized, considerLambda);
[hLegend, trigger] = ploter(ax, predictedX, predictedY, observedX, observedY, type, ...
    theta, 'blue', 'red', ':', 'BelowMin', 'AboveMin', [], alpha);

% print alpha
text(ax, 'Units', 'normalized', 'Position', [0.2, 0.98], ...
    'String', ['\alpha = ', num2str(alpha)], 'FontSize', 12, ...
    'Color', 'black', 'FontWeight', 'bold', ...
    'Interpreter', 'tex');

% print distance
text(ax, 'Units', 'normalized', 'Position', [0.4, 0.98], ...
'String', ['Distance: ', num2str(trigger)], 'FontSize', 12, ...
'Color', 'black', 'FontWeight', 'bold', ...
'Interpreter', 'tex');



isNormalized = 0;
isRegularized = 0;
considerLambda = 1;
kernel = 1;
power = 1.5;
[predictedY, sigma, type, K, alpha] = GP(predictedX, observedX, observedY, ...
    theta, kernel, power, isNormalized, isRegularized, considerLambda);
[hLegend, trigger] = ploter(ax, predictedX, predictedY, observedX, observedY, type, ...
    theta, '#00FFFF', '#EDB120', ':', 'BelowMinPow', 'AboveMinPow', hLegend, alpha);

% print alpha
text(ax, 'Units', 'normalized', 'Position', [0.2, 0.95], ...
    'String', ['\alpha = ', num2str(alpha)], 'FontSize', 12, ...
    'Color', 'black', 'FontWeight', 'bold', ...
    'Interpreter', 'tex');

% print distance
text(ax, 'Units', 'normalized', 'Position', [0.4, 0.95], ...
'String', ['Distance: ', num2str(trigger)], 'FontSize', 12, ...
'Color', 'black', 'FontWeight', 'bold', ...
'Interpreter', 'tex');


% print obj function formular
objectiveFunctionText = ['Objective Function: ', expr];
text(ax, 'Units', 'normalized', 'Position', [0.25, 0.92], ...
    'String', objectiveFunctionText, 'FontSize', 12, ...
    'Color', 'black', 'FontWeight', 'bold', ...
    'Interpreter', 'tex');




