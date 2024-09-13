function [index1, index2, minDist] = minDistance(observedX)
    minDist = 10000;
    index1 = 0;
    index2 = 0;

    for i = 1:length(observedX)
        for j = i+1:length(observedX)
            dist = abs(observedX(i) - observedX(j));
            if dist < minDist
                minDist = dist;
                index1 = i;
                index2 = j;
            end
        end
    end