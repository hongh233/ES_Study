rng(95);

%100000000000000
%1000

precision = 120;
xrange1 = -2;  xrange2 = 2;
yrange1 = -2;  yrange2 = 2;
numOfTrainingPoints = 5;
objFuncPlotOn = 0;

figure;


preTempX1 = linspace(xrange1, xrange2, precision);
preTempX2 = linspace(yrange1, yrange2, precision);
[px1, px2] = meshgrid(preTempX1, preTempX2);
predictedX1 = reshape(px1, 1, []);      
predictedX2 = reshape(px2, 1, []);       
predictedX = [predictedX1; predictedX2]; 
observedX1 = 3 * rand(1, numOfTrainingPoints) - 1.5;  % range: (0,1)
observedX2 = 3 * rand(1, numOfTrainingPoints) - 1.5;  % range: (0,1)
observedX = [observedX1; observedX2];
observedY = Obj2D(observedX1, observedX2);
[predictedY, type, K] = GP(predictedX, observedX, observedY, 1000000000000, 2);
Y = reshape(predictedY, precision, precision);

hold on;
plot3(observedX1(1, [1,2]), observedX2(1, [1,2]), observedY(1, [1,2]), 'LineWidth', 2);
plot3(observedX1(1, [1,3]), observedX2(1, [1,3]), observedY(1, [1,3]), 'LineWidth', 2);
plot3(observedX1(1, [1,4]), observedX2(1, [1,4]), observedY(1, [1,4]), 'LineWidth', 2);
plot3(observedX1(1, [1,5]), observedX2(1, [1,5]), observedY(1, [1,5]), 'LineWidth', 2);
plot3(observedX1(1, [2,3]), observedX2(1, [2,3]), observedY(1, [2,3]), 'LineWidth', 2);
plot3(observedX1(1, [2,4]), observedX2(1, [2,4]), observedY(1, [2,4]), 'LineWidth', 2);
plot3(observedX1(1, [2,5]), observedX2(1, [2,5]), observedY(1, [2,5]), 'LineWidth', 2);
plot3(observedX1(1, [3,4]), observedX2(1, [3,4]), observedY(1, [3,4]), 'LineWidth', 2);
plot3(observedX1(1, [3,5]), observedX2(1, [3,5]), observedY(1, [3,5]), 'LineWidth', 2);
plot3(observedX1(1, [4,5]), observedX2(1, [4,5]), observedY(1, [4,5]), 'LineWidth', 2);


if objFuncPlotOn == 1
    mesh(px1, px2, Obj2D(px1,px2), 'EdgeColor', 'flat', 'FaceAlpha', 0);
end
surf(px1, px2, Y, 'FaceColor', 'yellow', 'FaceAlpha', 0.2, 'EdgeColor', 'black');
scatter3(observedX1, observedX2, observedY, 'black', 'filled', 'o');
title([type, ' theta: ', 1]);


