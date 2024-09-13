% Gaussian Process
%                dimension: n
% number of training point: m
% number of testing point : 1 (This GP only fits for 1 test point)
% xTrain: n * m, fTrain: 1 * m 
% xTest : n * 1, fTest : 1 * 1 (return)
% d1: m * m, d2: m * 1, d3:  1 * 1
% K:  m * m, Ks: m * 1, Kss: 1 * 1
% function [fTest, K] = GP(xTest, xTrain, fTrain, mu, theta, kernelIndex)


xTrain = [-0.05, 0.05; 1, 1];
fTrain = ObjFunction(xTrain, 2);
xTest = [0.01];
theta = 1;
predictedY = GP123(xTest, xTrain, fTrain, theta);


function predictedY = GP123(xTest, xTrain, fTrain, theta)
    d1 = pdist2(xTrain', xTrain', 'euclidean');
    K = exp(-(d1/theta).^2/2);
    cond_K = cond(K);
    eigenvalues = eig(K);
    lambda_max = max(eigenvalues); % 最大特征值
    lambda_min = min(eigenvalues); % 最小特征值
    cond_eigen = lambda_max / lambda_min;
    
    d2 = pdist2(xTrain', xTest', 'euclidean');
    Ks = exp(-(d2/theta).^2/2);

    % predictedY = (Ks.' * inv(K) * (fTrain).').';
    predictedY = Ks.'*(K\(fTrain'));
end