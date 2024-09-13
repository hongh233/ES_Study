%% Seed
% rng(31);

figure;

%% predicted data
predictedX = linspace(-2, 1, 400);

%% training data
observedX = [0.01, 0.02, 0.03];
observedY = Obj1D(observedX);


[A, B, minDist] = minDistance(observedX);
disp(A);
disp(B);
disp(minDist);


y_min = min(observedY);



    theta =5;
    
    [predictedY, type] = GPTest(predictedX, observedX, observedY, theta);


    hold on;
    % predicted fucntion
    for iplot = 1:length(predictedX)-1
        if predictedY(iplot) < y_min
            plot(predictedX(iplot:iplot+1), predictedY(iplot:iplot+1), "k", 'LineWidth', 3, 'Color', 'blue');
        end
    end

    for iplot = 1:length(predictedX)-1
        if predictedY(iplot) >= y_min
            plot(predictedX(iplot:iplot+1), predictedY(iplot:iplot+1), "k", 'LineWidth', 3, 'Color', 'red');
        end
    end
 

    % objective function
    plot(predictedX, Obj1D(predictedX), "k", 'LineWidth', 0.5, 'Color', 'g');  
    % training data
    scatter(observedX, observedY, 'filled', 'black');
    
    title(type);
    ylabel(theta);
    % legend('Obj function', 'GP mean');
    hold off;



% disp(observedX);






