% rng(13);

n = 80;                 % dimansion of K
V = orth(randn(n)); 
cond_number = 1e10;     % cond of K
min_eigenvalue = 1; 
max_eigenvalue = min_eigenvalue * cond_number;
D = diag(linspace(min_eigenvalue, max_eigenvalue, n));
K = V * D * V'; 
fTrain = randn(n, 1);

[x, hah_plot, num_of_iter] = CG_nonGradient(K, fTrain, 1e-8, 5000, 1);


fprintf('Number of iterations: %d\n', num_of_iter);


figure;
hold on;
plot(1:num_of_iter, hah_plot(1:num_of_iter));
xlabel('Iteration');
ylabel('Residual Squared');
title('Convergence of PCG');
% set(gca, 'yscale', 'log');
hold off;
