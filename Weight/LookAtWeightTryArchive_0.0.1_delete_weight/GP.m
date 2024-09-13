% Gaussian Process
%                dimension: n
% number of training point: m
% number of testing point : 1 (This GP only fits for 1 test point)
% xTrain: n * m, fTrain: 1 * m 
% xTest : n * 1, fTest : 1 * 1 (return)
% d1: m * m, d2: m * 1, d3:  1 * 1
% K:  m * m, Ks: m * 1, Kss: 1 * 1
% function [fTest, K] = GP(xTest, xTrain, fTrain, mu, theta, kernelIndex)

function [fTest, K, theta, Ks] = GP(xTest, xTrain, fTrain, mu, theta, kernelIndex)
    global data;
    [n, m] = size(xTrain);

    if n==1
        d1 = repmat(xTrain, 1, m)-repelem(xTrain, 1, m);
    else
        d1 = vecnorm(repmat(xTrain, 1, m)-repelem(xTrain, 1, m));
    end


    if n==1
        d2 = xTrain-repelem(xTest, 1, m);
    else
        d2 = vecnorm(xTrain-repelem(xTest, 1, m));
    end


    switch kernelIndex
        case 1
            % Squared Exponential Kernel
            K = reshape(exp(-(d1/theta).^2/2), m, m);
            Ks = exp(-(d2/theta).^2/2)';
        case 2
            % Regular Exponential Kernel
            K = reshape(exp(-(d1/theta)), m, m);
            Ks = exp(-(d2/theta))';
        case 3
        otherwise
            disp("error index");
            K = [];
            Ks = [];
    end


    % fTest = (Ks.' * inv(K) * (fTrain).').';
    fTest = mu+(Ks'*(K\(fTrain'-mu)));
end

