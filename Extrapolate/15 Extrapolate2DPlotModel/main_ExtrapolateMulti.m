seed = 101;

precision = 120;
xrange1 = -2;  xrange2 = 2;
yrange1 = -2;  yrange2 = 2;
numOfTrainingPoints = 10;
objFuncPlotOn = 0;

t = tiledlayout(3, 5);
thetaList = [0.5, 1, 3];

for i = 1:5
    for j = 1:3
        ax = nexttile(i + 5 * (j - 1));
        rng(seed);
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
        [predictedY, type] = GP(predictedX, observedX, observedY, thetaList(j), i);
        Y = reshape(predictedY, precision, precision);
        hold on;
        if objFuncPlotOn == 1
            mesh(ax, px1,px2,Obj2D(px1,px2), 'EdgeColor', 'flat', 'FaceAlpha', 0);
        end
        surf(px1, px2, Y);
        sortedObservedY = sort(observedY);
        y_threshold = sortedObservedY(2);
        surf(ax, px1, px2, Y.*(Y<=y_threshold & Y>=min(observedY)), 'FaceColor', 'red', 'EdgeColor', 'black');
        scatter3(ax, observedX1, observedX2, observedY, 'black', 'filled', 'o');
        title(ax, [type, ' theta: 0.5', thetaList(j)]);
        hold off;
    end
end
