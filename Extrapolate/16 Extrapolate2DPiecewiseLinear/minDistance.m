function minDist = minDistance(observedX)
    minDist = Inf;
    numPoints = size(observedX, 2);

    for i = 1:numPoints
        for j = i+1:numPoints
            dist = norm(observedX(:, i) - observedX(:, j));
            if dist < minDist
                minDist = dist;
            end
        end
    end
end