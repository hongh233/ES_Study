% Symmetric Successive Over-Relaxation, SSOR

% PCG: Kx=y, x=inv(K)y, r=y-Kx, (y-Kx)'(y-Kx), 
% M: precondition, speed up the convergence rate
function [x, hah_plot, num_of_iter] = PCG_SSOR(K, fTrain, threshold, maxIter, plotOn)
    M_inv = get_ssor_precondition_matrix(K, 0.2);
    x = zeros(size(fTrain));
    r_old = fTrain - K * x;
    z_old = M_inv * r_old;
    p = z_old;

    hah_plot = NaN(maxIter + 1, 1);       % for plot

    k = 0;
    while k < maxIter && sqrt(r_old' * r_old) >= threshold
        hah_plot(k+1) = 0.5 * x' * K * x - fTrain' * x;   % obj function

        alpha = (z_old' * r_old) / (p' * K * p);
        x = x + alpha * p;
        r_new = r_old - alpha * K * p;
        z_new = M_inv * r_new;
        beta = (z_new' * r_new) / (z_old' * r_old);
        p = z_new + beta * p;

        z_old = z_new;
        r_old = r_new;
        k = k + 1;
        num_of_iter = k;
    end

    figure;
    hold on;
    histogram(eig(K));
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


function M_inv = get_ssor_precondition_matrix(A, w)
    % 获取矩阵的维度
    dim = size(A, 1);
    
    % 提取上三角和下三角矩阵
    UD = triu(A);
    LD = tril(A);
    
    % 构造对角矩阵
    D = diag(diag(A));
    
    % 调整上三角和下三角矩阵
    for i = 1:dim
        for j = i+1:dim
            UD(i, j) = w * UD(i, j);
        end
    end
    for i = 1:dim
        for j = 1:i-1
            LD(i, j) = w * LD(i, j);
        end
    end
    
    % 计算SSOR预条件矩阵的逆矩阵
    M_inv = inv(UD) * D * inv(LD);
end
