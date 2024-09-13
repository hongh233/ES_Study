% PCG: Kx=y, x=inv(K)y, r=y-Kx, (y-Kx)'(y-Kx), 
% M: precondition, speed up the convergence rate
function [x, hah_plot, num_of_iter] = CG_nonGradient(K, fTrain, threshold, maxIter, plotOn)
    x = zeros(size(fTrain));
    r_old = fTrain - K * x;
    p = r_old;

    hah_plot = NaN(maxIter + 1, 1);       % for plot

    num_of_iter = maxIter;
    k = 0;
    while k < maxIter && sqrt(r_old' * r_old) >= threshold
        hah_plot(k+1) = 0.5 * x' * K * x - fTrain' * x;   % obj function

        alpha = (r_old' * r_old) / (p' * K * p);
        x = x + alpha * p;
        r_new = r_old - alpha * K * p;
        beta = (r_new' * r_new) / (r_old' * r_old);
        p = r_new + beta * p;

        r_old = r_new;
        k = k + 1;
        num_of_iter = k;
    end

    
    figure;
    hold on;
    eig_K = eig(K);
    histogram(eig_K);
    title('Histogram of Eigenvalues');
    xlabel('Eigenvalue');
    ylabel('Frequency');
    hold off;


    if plotOn
        figure;
        hold on;
        x = K \ fTrain;
        obj_value_real = 0.5 * x' * K * x - fTrain' * x;
        disp(obj_value_real);
        yline(obj_value_real, 'g-', 'LineWidth', 2, 'DisplayName', 'Target value');

        iterations = 1:size(hah_plot, 1);
        obj_values = hah_plot(:, 1);
        plot(iterations, obj_values, '-o', 'Color', 'red', 'DisplayName', 'PCG Obj value');
    
        blue_points = obj_values >= obj_value_real;
        plot(iterations(blue_points), obj_values(blue_points), ...
            'bo', 'MarkerFaceColor', 'blue', 'DisplayName', 'Points >= target', ...
            'MarkerSize', 4);
    
        xlabel('Iterations');
        ylabel('Values');

        legend;
        grid on;
        % set(gca, 'yscale', 'log');
        hold off;
    end
end
