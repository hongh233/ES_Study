precision = 120;    % now it fixed, do not modify!
numOfTrainingPoints = 20;


preTempX1 = linspace(0, 1, precision);
preTempX2 = linspace(0, 1, precision);
[px1, px2] = meshgrid(preTempX1, preTempX2);
% px1: 10 * 10
% px2: 10 * 10

predictedX1 = reshape(px1, 1, []);       % 1 * 1600
predictedX2 = reshape(px2, 1, []);       % 1 * 1600
predictedX = [predictedX1; predictedX2]; % 2 * 1600


% observedX1 = [0.3745, 0.9507, 0.7320, 0.5987];
% observedX2 = [0.3643, 0.8504, 0.6320, 0.2981];


observedX1 = rand(1, numOfTrainingPoints);  % range: (0,1)
observedX2 = rand(1, numOfTrainingPoints);  % range: (0,1)
observedX = [observedX1; observedX2];
observedY = Obj2D(observedX1, observedX2);


thetaSet = [0.01, 0.1, 0.5, 1];

[predictedY, sigma, type] = GP(predictedX, observedX, observedY, 0.1, 1);


% predictedX1
% predictedX2
% predictedY

Y = reshape(predictedY, precision, precision);

% obj function
mesh(px1,px2,Obj2D(px1,px2), 'EdgeColor', 'flat', 'FaceAlpha', 0);



hold on;
% surf(px1, px2, Y);
% y_threshold = min(observedY);
% surf(px1, px2, Y.*(Y<=y_threshold), 'FaceColor', 'red', 'EdgeColor', 'none');
% surf(px1, px2, Y.*(Y>y_threshold), 'EdgeColor', 'none');
surf(px1, px2, Y); 


for i = 1:precision
    for j = 1:precision
        if Obj2D(px1(i, j),px2(i, j)) < Y(i,j)
            Y(i,j) = NaN;
        end
    end
end
surf(px1, px2, Y, 'FaceColor','red');


scatter3(observedX1, observedX2, observedY, 'black', 'filled', 'o');




% disp(observedX);

