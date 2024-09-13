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

     % method2: inverse matrix
    fTest = mu+(Ks'*(K\(fTrain'-mu)));
    fTest_INV = fTest;




    % method1: preconditioned conjugate gradient method
    % K = K + 1e-6 * eye(m);
    M = diag(diag(K));
    tol = 1e-10;
    maxIter = 5000;

    % x = inv(K) * fTrain'
    [x, objValues_plot, num_of_iter] = myPCG(K, fTrain', M, tol, maxIter);
    fTest = Ks' * x;
    fTest_PCG = fTest;





    fTest_store = [fTest_store;[fTest_PCG, fTest_INV, (fTest_PCG/fTest_INV), cond(K), num_of_iter]];


    % Plotting the objective function values
    if 1
        figure;
        plot(1:length(objValues_plot), objValues_plot, 'b-o');
        xlabel('Iterations');
        ylabel('Objective Function Value');
        title('Objective Function Value vs. Iterations');
        grid on;
        set(gca, 'yscale', 'log');
    end
    
end


% PCG: Kx=y, x=inv(K)y, r=y-Kx, (y-Kx)'(y-Kx), 
% M: precondition, speed up the convergence rate
function [x, objValues_plot, num_of_iter] = myPCG(K, fTrain, M, tol, maxIter)
    x = zeros(size(fTrain));
    r = fTrain - K * x;
    z = M \ r;
    p = z;
    rsold = r' * z;
    objValues_plot = zeros(maxIter, 1); % ignore, for plot
    objValues_plot(1) = r' * r;         % ignore, for plot

    for iter = 1:maxIter
        Kp = K * p;
        alpha = rsold / (p' * Kp);
        x = x + alpha * p;
        r = r - alpha * Kp;
        z = M \ r;
        rsnew = r' * z;
        objValues_plot(iter + 1) = r' * r;  % ignore, for plot

        if sqrt(rsnew) < tol
            objValues_plot = objValues_plot(1:iter + 1); % ignore, for plot
            num_of_iter = iter;
            return;
        end

        p = z + (rsnew / rsold) * p;
        rsold = rsnew;
        num_of_iter = iter;
    end

    objValues_plot = objValues_plot(1:maxIter); % ignore, for plot
end
