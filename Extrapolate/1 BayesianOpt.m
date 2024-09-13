rng(31);
predictedX = linspace(0, 1, 400);
theta = 0.1;

% set up plots
t = tiledlayout(2, 4);
sgtitle('GP with different Kernel Functions, theta = 0.1, (8 iterations)');
sgt.FontSize = 15;

for i = 1:7
    observedX = rand(1, 5);
    if i == 1
        % Display Objective function and the initial data points
        ax = nexttile;
        observedY = Obj1D(observedX);
        hold on;
        plot(ax, predictedX, Obj1D(predictedX), "k", 'LineWidth',2);
        scatter(ax, observedX, observedY, 25, "red", "filled");
        title('Objective function and sample points')
    else
        % Perform Gaussian Process for 8 iterations
        ax = nexttile;
        for j = 1:8
            observedY = Obj1D(observedX);
            
            [predictedY, sigma, type] = GP(predictedX, observedX, observedY, theta, i - 1);
            [ei] = EI(predictedY, sigma, max(observedY));

            [~, idx] = max(ei);
            next_sample = predictedX(idx);

            observedX = [observedX, next_sample];
        end
        
        % Plot Gaussian Process
        observedY = Obj1D(observedX);
        hold on;
        plot(ax, predictedX, predictedY, "k--", 'LineWidth', 2);
        scatter(ax, observedX, observedY, 25, "red", "filled");
        title(ax, type);
    end
end









% objective function
function val = Obj1D(x)
    % val = x/3 + sin(3 * pi * x);
    val = 10 + x .^2 - 10 * cos(2 * pi * x);
    % val = (1+x)./(1+x.^2);
    % val = x .^2;
    % val = abs(x);
end










% acquisition function (expected improvement)
function [ei] = EI(mu, sigma, y_max)
    cauchy = 0;
    Z = (mu - y_max - cauchy) ./ diag(sigma).';
    ei = (mu - y_max - cauchy) .* normcdf(Z) + diag(sigma).' .* normpdf(Z);

    % cauchy = 0;
    % Z = (mu - y_max - cauchy) ./ diag(sigma).';
    % f1 = (mu - y_max) .* normcdf(Z);
    % f2 = (diag(sigma).' / sqrt(2 * pi)) .* exp(-0.5 * Z .^2);
    % ei = f1 + f2;

    ei(ei < 0) = 0;
end














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
function [predictedY, Sigma, title] = GP(predictedX, observedX, observedY, theta, idx)

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
    
    
    % In BO, we have to add the regularization to make other kernels work 
    % except for squared and exponential kernel 
    regularization = 1.0e-08*eye(size(observedX, 2));
    % regularization = 0;

    inverseK = inv(K + regularization);
    predictedY = (Ks.' * inverseK * observedY.').';
    Sigma = Kss - Ks.'* inverseK * Ks;
end