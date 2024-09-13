
figure;


preTempX1 = linspace(-2, 2, 10);
preTempX2 = linspace(-2, 2, 10);
[px1, px2] = meshgrid(preTempX1, preTempX2);
predictedX1 = reshape(px1, 1, []);      
predictedX2 = reshape(px2, 1, []);       
predictedX = [predictedX1; predictedX2]; 


observedX1 = rand(1, 5);  
observedX2 = rand(1, 5); 
observedX = [observedX1; observedX2];
observedY = Obj2D(observedX1, observedX2);
minDist = minDistance(observedX);
for k = 1:100
    disp(k);
    theta = 0.01;
    for j = 1:1000
        [predictedY, type, K] = GP(predictedX, observedX, observedY, theta, 2);
        if rcond(K) < 1.0 * exp(-14)
            scatter(minDist, theta, 'MarkerFaceColor', 'red', 'SizeData', 20);
            disp("happen");
            break;
        end
        theta = theta + 100;  % theta: 0.01 + 0.001 * iteration
    end
    observedX1 = 3 * rand(1, 5) - 1.5;  
    observedX2 = 3 * rand(1, 5) - 1.5; 
    observedX = [observedX1; observedX2];
    observedY = Obj2D(observedX1, observedX2);
    minDist = minDistance(observedX);
end