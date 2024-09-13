% Gaussian Process for n dimension
% predictedX: n * 400, predictedY: 1 * 400
% observedX:  n * 5,   observedY:  1 * 5
% d1: 5 * 5, d2: 5 * 400, d3:  400 * 400
% K:  5 * 5, Ks: 5 * 400, Kss: 400 * 400

function predictedY = GP(predictedX, observedX, observedY, mu, theta)
    d1 = pdist2(observedX', observedX', 'euclidean');
    d2 = pdist2(observedX', predictedX', 'euclidean');

    K = exp(-(d1/theta).^2/2);
    Ks = exp(-(d2/theta).^2/2);

    % predictedY = (Ks.' * inv(K) * (observedY).').';
    predictedY = mu + (Ks.' * inv(K) * (observedY - mu).').';
end

