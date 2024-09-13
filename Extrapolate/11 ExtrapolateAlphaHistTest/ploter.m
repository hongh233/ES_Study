function [distance] = ploter(predictedX, predictedY, observedY)
    
    distance = 0;

    % predicted fucntion
    for iplot = 1:length(predictedX)-1
        if predictedY(iplot) < min(observedY)
            distance = distance + 1;
        end
    end


end