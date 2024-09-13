function [] = weight2D()

    function fx = obj(x, y)
        fx = x.^2 + y.^2;
    end

    function [fTest, weight] = gp(xTest, yTest, xTrain, yTrain, fTrain, theta, kernelIndex)
        d1 = pdist2([xTrain.', yTrain.'], [xTrain.', yTrain.'], 'euclidean');
        d2 = pdist2([xTrain.', yTrain.'], [xTest(:), yTest(:)], 'euclidean');
        switch kernelIndex
            case 1
                k = exp(-(d1/theta).^2/2);
                ks = exp(-(d2/theta).^2/2);
            case 2
                k = exp(-(d1/theta));
                ks = exp(-(d2/theta));
            case 3
                k = d1;
                ks = d2;
            otherwise
                disp('incorrect kernelIdx');
        end
        weight = ks.' * inv(k);
        fTest = reshape(weight * fTrain.', size(xTest));
    end

    [xTest, yTest] = meshgrid(linspace(-1, 2, 50), linspace(-1, 2, 50));
    xTrain = rand(1, 4);
    yTrain = rand(1, 4);
    fTrain = obj(xTrain, yTrain);
    theta = [0.1, 1, 5];

    for kernelIndex = 1:2
        for thetaIndex = 1:3
            [fTest, weight] = gp(xTest, yTest, xTrain, yTrain, fTrain, theta(thetaIndex), kernelIndex);
            
            
            figure;
            surf(xTest, yTest, fTest);
            hold on;
            title(['Prediction Model: Kernel = ', num2str(kernelIndex), ', \theta = ', num2str(theta(thetaIndex))]);
            scatter3(xTrain, yTrain, fTrain, 50, 'black', 'o', 'filled');
            hold off;

            
            figure;
            hold on;
            for i = 1:length(xTrain)
                surf(xTest, yTest, reshape(weight(:,i), size(xTest)), 'FaceAlpha', 0.5);
            end
            title(['Weight Function: Kernel = ', num2str(kernelIndex), ', \theta = ', num2str(theta(thetaIndex))]);
            hold off;
        end
    end
end