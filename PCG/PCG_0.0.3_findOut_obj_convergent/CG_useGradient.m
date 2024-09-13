% PCG: Kx=y, x=inv(K)y, r=y-Kx, (y-Kx)'(y-Kx), 
% M: precondition, speed up the convergence rate
function [x, hah_plot, num_of_iter] = CG_useGradient(K, fTrain, threshold, maxIter)
    x = zeros(size(fTrain)) + 1;
    grad_old = gradient_f(K, x, fTrain);
    p = -grad_old;

    hah_plot = zeros(maxIter + 1, 1);       % for plot
    num_of_iter = maxIter;                  % for plot

    objValue = (fTrain - K * x)' * (fTrain - K * x);
    
    iter = 0;
    while iter < maxIter && sqrt(objValue) >= threshold

        objValue = 0.5 * x' * K * x - fTrain' * x;
        hah_plot(iter + 1) = objValue;      % for plot

        gamma = (grad_old' * grad_old) / (p' * K * p);
        x = x + gamma * p;
        grad_new = gradient_f(K, x, fTrain);
        p = -grad_new + (grad_new' * grad_new) / (grad_old' * grad_old) * p;
        grad_old = grad_new;

        iter = iter + 1;
        num_of_iter = iter;
    end
end



function grad = gradient_f(K, x, y)
    grad = (K * x - y);
end