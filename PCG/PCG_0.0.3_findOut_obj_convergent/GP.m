% Gaussian Process
%                dimension: n
% number of training point: m
% number of testing point : 1 (This GP only fits for 1 test point)
% xTrain: n * m, fTrain: 1 * m 
% xTest : n * 1, fTest : 1 * 1 (return)
% d1: m * m, d2: m * 1, d3:  1 * 1
% K:  m * m, Ks: m * 1, Kss: 1 * 1
% function [fTest, K] = GP(xTest, xTrain, fTrain, mu, theta, kernelIndex)

function fTest = GP(xTest, xTrain, fTrain, mu, theta, kernelIndex)
    global fTest_store;
    global observe_function_value;

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

    theta_ind = zeros(1, length(xTrain)) + theta;


    switch kernelIndex
        case 1
            % Squared Exponential Kernel
            d1 = reshape(d1, m, m);
            K = exp(-(d1./theta_ind).^2/2);
            Ks = exp(-(d2./theta_ind).^2/2)';
        case 2
            % Regular Exponential Kernel
            d1 = reshape(d1, m, m);
            K = exp(-(d1./theta_ind));
            Ks = exp(-(d2./theta_ind))';
        case 3

        otherwise
            disp("error index");
            K = [];
            Ks = [];
    end

    K = K + 1e-3 * eye(size(K));

    % method2: inverse matrix
    fTest_INV = mu+(Ks'*(K\(fTrain'-mu)));

    % method1: preconditioned conjugate gradient method            1e-8
    [x, ~, num_of_iter] = CG_nonGradient(K, fTrain', 1e-5, 5000, 1);
    fTest_PCG = Ks' * x;

    fTest = fTest_PCG;

    fTest_store = [fTest_store;[fTest_PCG, fTest_INV, (fTest_PCG/fTest_INV), cond(K), num_of_iter]];

end


