function [] = ploter(ax, predictedX, predictedY, observedX, observedY, type, theta)
    hold(ax, 'on');

    % predicted fucntion
    for iplot = 1:length(predictedX)-1
        if predictedY(iplot) < min(observedY)
            plot(ax, predictedX(iplot:iplot+1), predictedY(iplot:iplot+1), "k", 'LineWidth', 3, 'Color', 'blue');
        end
    end

    for iplot = 1:length(predictedX)-1
        if predictedY(iplot) >= min(observedY)
            plot(ax, predictedX(iplot:iplot+1), predictedY(iplot:iplot+1), "k", 'LineWidth', 3, 'Color', 'red');
        end
    end
 

    % objective function
    plot(ax, predictedX, Obj1D(predictedX), "k", 'LineWidth', 0.5, 'Color', 'g');  
    % training data
    scatter(ax, observedX, observedY, 'filled', 'black');
    
    title(ax, type);
    ylabel(ax, theta);

    hold(ax,'off');

end