xTrain = [0.1, 0.11, 1.1];
theta = [436, 1, 436];
theta_toBeChanged = 2;


cond_values = zeros(1, 100000);
warning_flags = false(1, 100000);
orig_warning_state = warning('query', 'MATLAB:nearlySingularMatrix');
cleanupObj = onCleanup(@() warning(orig_warning_state.state, 'MATLAB:nearlySingularMatrix'));
warning('error', 'MATLAB:nearlySingularMatrix');


for i = 1:100000
    try
        [cond_values(i), warning_flags(i)] = GP(xTrain, theta);
    catch ME
        if contains(ME.message, 'Matrix is close to singular or badly scaled')
            warning_flags(i) = true;
            cond_values(i) = NaN; % Assign NaN for failed inversions
        else
            rethrow(ME);
        end
    end
    theta(theta_toBeChanged) = theta(theta_toBeChanged) + 1;
end

fprintf('Finished.\n');

% Plotting the condition numbers using scatter plot with log values
figure;
scatter(1:100000, cond_values, 'filled');
hold on;
scatter(find(warning_flags), cond_values(warning_flags), 'filled', 'red');
xlabel('theta[?]');
ylabel('Log10 Condition Number');
title('Condition Number Observation');
grid on;
hold off;

function [cond_val, warning_flag] = GP(xTrain, theta)
    theta_K = repmat(theta', 1, length(xTrain));
    d1 = pdist2(xTrain', xTrain', 'euclidean');
    K = exp(-(d1./theta_K).^2/2).';
    warning_flag = false;
    try
        inv(K);
    catch
        warning_flag = true;
    end
    cond_val = log10(cond(K));
end