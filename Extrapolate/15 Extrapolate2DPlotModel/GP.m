% Gaussian Process for n dimension

% predictedX: n * 400
% predictedY: 1 * 400
% observedX:  n * 5
% observedY:  1 * 5

% theta: scale parameter
% idx: index of the kernel
% title: name of the kernel

% d1:   5 * 5
% d2:   5 * 400
% d3:   400 * 400
% K:    5 * 5
% Ks:   5 * 400
% Kss:  400 * 400
% Sigma: 400 * 400

function [predictedY, title] = GP(predictedX, observedX, observedY, theta, idx)

    d1 = pdist2(observedX', observedX', 'euclidean');
    d2 = pdist2(observedX', predictedX', 'euclidean');
    d3 = pdist2(predictedX', predictedX', 'euclidean');

    
    switch idx
    case 1
        % Squared exponential kernel
        K = exp(-(d1/theta).^2/2);
        Ks = exp(-(d2/theta).^2/2);
        Kss = exp(-(d3/theta).^2/2);
        title = 'Squared Exponential Kernel';
    case 2   
        % Exponential Kernel    
        K = exp(-d1/theta);
        Ks = exp(-d2/theta);
        Kss = exp(-d3/theta);
        title = 'Exponential Kernel';
    case 3
        % Thin plate spline     
        K = (d1/theta) .^2 .* log(d1/theta);          K(isnan(K)) = 0;
        Ks = (d2/theta) .^2 .* log(d2/theta);         Ks(isnan(Ks)) = 0;
        Kss = (d3/theta) .^2 .* log(d3/theta);        Kss(isnan(Kss)) = 0;
        title = 'Thin Plate Kernel';
    case 4
        % Inverse Multiquadric kernel   
        K = 1 ./ sqrt((d1/theta) .^2 + 1);
        Ks = 1 ./ sqrt((d2/theta) .^2 + 1);
        Kss = 1 ./ sqrt((d3/theta) .^2 + 1);
        title = 'Inverse Multiquadratic Kernel';
    case 5   
        % Linear kernel                  
        K = d1/theta;
        Ks = d2/theta;
        Kss = d3/theta;
        title = 'Linear Kernel';
    case 6
        K = (1 - (d1/theta) .^2) .* exp(-(d1/theta) .^2 / 2);
        Ks = (1 - (d2/theta) .^2) .* exp(-(d2/theta) .^2 / 2);
        Kss = (1 - (d3/theta) .^2) .* exp(-(d3/theta) .^2 / 2);
        title = 'Mexian Hat';
    otherwise
        disp('Wrong number passed as kernel param in GP function.')
    end
    
    
    % In BO, we have to add the regularization to make other kernels work 
    % except for squared and exponential kernel 
    regularization = 1.0e-08*eye(size(observedX, 2));
    regularization = 0;

    
    inverseK = inv(K + regularization);
    % disp(cond(K));


    interpolateMode = 2;
    if (interpolateMode == 0)
        predictedY = (Ks.' * inverseK * (observedY).').';
        alpha = 0;
    elseif (interpolateMode == 1)
        predictedY = min(observedY) + (Ks.' * inverseK * (observedY - min(observedY)).').';
        alpha = 0;
    else
        % Solve for lambda under the constraint sum(lambda) = 0
        % A = [K  1]
        %     [1T 0]
        A = [K ones(size(K, 1), 1); ones(1, size(K, 2)) 0];
        % b = [observedY]
        %     [    0    ]
        b = [observedY'; 0];
        % A [lambda] = b
        %   [alpha ]
        params = A \ b;
        lambda = params(1:end-1);   % First n elements are lambda
        alpha = params(end);        % Last element is alpha
        predictedY = alpha + (Ks' * lambda);
    end


end

