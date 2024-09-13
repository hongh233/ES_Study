% Gaussian Process for n dimension

% predictedX: n * 400
% predictedY: 1 * 400
% observedX:  n * 5
% observedY:  1 * 5

% theta: scale parameter
% idx: index of the kernel
% title: name of the kernel

% d1:   5 * 5, d2:   5 * 400, d3:   400 * 400
% K:    5 * 5, Ks:   5 * 400, Kss:  400 * 400
% sigma: 400 * 400

function [predictedY, sigma, title, alpha] = GP(predictedX, observedX, observedY, ...
    theta, kernel, isNormalized, isRegularized, interpolateMode)

    d1 = pdist2(observedX', observedX', 'euclidean');
    d2 = pdist2(observedX', predictedX', 'euclidean');
    d3 = pdist2(predictedX', predictedX', 'euclidean');

    
    switch kernel
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
        K = d1 .^2 .* log(d1);          K(isnan(K)) = 0;
        Ks = d2 .^2 .* log(d2);         Ks(isnan(Ks)) = 0;
        Kss = d3 .^2 .* log(d3);        Kss(isnan(Kss)) = 0;
        title = 'Thin Plate Kernel';
    case 4
        % Inverse Multiquadric kernel   
        c = 5;
        K = sqrt(d1 .^2 + c .^2);
        Ks = sqrt(d2 .^2 + c .^2);
        Kss = sqrt(d3 .^2 + c .^2);
        title = 'Inverse Multiquadratic Kernel';
    case 5
        % Linear kernel                  
        K = d1;
        Ks = d2;
        Kss = d3;
        title = 'Linear Kernel';
    case 6
        % Quadratic kernel               
        K = d1 .^2;
        Ks = d2 .^2;
        Kss = d3 .^2;
        title = 'Quadratic Kernel';
    otherwise
        disp('Wrong number passed as kernel param in GP function.')
    end



    if (isNormalized == 1) 
        K = K ./ sum(K, 2);
        Ks = Ks ./ sum(Ks, 1);
        Kss = Kss ./ sum(Kss, 2);
        title = ['Normalized ', title];
    end



    % In BO, we have to add the regularization to make other kernels work 
    % except for squared and exponential kernel 
    regularization = 0;
    if (isRegularized == 1)
        regularization = 1.0e-08*eye(size(observedX, 2));
    end
    inverseK = inv(K + regularization);
    % disp(cond(K));


        
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
        disp(alpha);
    
        predictedY = alpha + (Ks' * lambda);
    end


    sigma = Kss - Ks.'* inverseK * Ks;
end
