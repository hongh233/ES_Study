function [hLegend, trigger] = ploter(ax, predictedX, predictedY, observedX, observedY, type, ...
    theta, color1, color2, lineStyle, name1, name2, hLegendTemp, alpha)
    hold(ax, 'on');


    h1 = plot(NaN, NaN, 'Color', color1, 'LineStyle', lineStyle, 'LineWidth', 3, 'DisplayName', name1);
    h2 = plot(NaN, NaN, 'Color', color2, 'LineStyle', lineStyle, 'LineWidth', 2, 'DisplayName', name2);

    trigger = 0;

    % predicted fucntion
    for iplot = 1:length(predictedX)-1
        if predictedY(iplot) < min(observedY)
            trigger = trigger + 1;
            h1 = plot(ax, predictedX(iplot:iplot+1), predictedY(iplot:iplot+1), "k", ...
                'LineWidth', 3, 'Color', color1, 'LineStyle', lineStyle);
        end
    end

    hLegendTemp = [hLegendTemp, h1];
    hLegendTemp(end).DisplayName = name1;

    for iplot = 1:length(predictedX)-1
        if predictedY(iplot) >= min(observedY)
            h2 = plot(ax, predictedX(iplot:iplot+1), predictedY(iplot:iplot+1), "k", ...
                'LineWidth', 2, 'Color', color2, 'LineStyle', lineStyle);
        end
    end

    hLegendTemp = [hLegendTemp, h2];
    hLegendTemp(end).DisplayName = name2;
 

    % objective function
    plot(ax, predictedX, Obj1D(predictedX), "k", 'LineWidth', 0.5, 'Color', 'g');  
    % training data
    scatter(ax, observedX, observedY, 'filled', 'black');

    legend(ax, hLegendTemp);
    
    title(ax, type);
    ylabel(ax, theta);

    hold(ax,'off');

    hLegend = hLegendTemp;




end