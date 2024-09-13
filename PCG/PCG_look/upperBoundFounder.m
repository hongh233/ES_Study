function final_theta = upperBoundFounder(xTrain)



orig_warning_state = warning('query', 'MATLAB:nearlySingularMatrix');
cleanupObj = onCleanup(@() warning(orig_warning_state.state, 'MATLAB:nearlySingularMatrix'));
warning('error', 'MATLAB:nearlySingularMatrix');

theta = ones(1, length(xTrain));

% Check if theta = 1 works
try
    GP(xTrain, theta);
    % If theta = 1 works, go to branch A
    branchA = true;
catch ME
    if contains(ME.message, 'Matrix is close to singular or badly scaled')
        % If theta = 1 doesn't work, go to branch B
        branchA = false;
    else
        rethrow(ME);
    end
end

if branchA
    % Branch A: theta > 1
    step = 1;
    while true
        try
            GP(xTrain, theta);
            theta = theta + step; % Increment theta
        catch ME
            if contains(ME.message, 'Matrix is close to singular or badly scaled')
                theta = theta - step; % Move back to the last working theta
                break;
            else
                rethrow(ME);
            end
        end
    end
    
    % Binary search with lower precision (1e-3)
    upper_bound = theta(1);
    lower_bound = theta(1) - step;
    tolerance = 1e-3;
else
    % Branch B: theta <= 1
    upper_bound = 1;
    lower_bound = 0;
    tolerance = 1e-10;
end

while upper_bound - lower_bound > tolerance
    mid_theta = (upper_bound + lower_bound) / 2;
    theta = ones(1, length(xTrain)) * mid_theta;
    
    try
        GP(xTrain, theta);
        lower_bound = mid_theta; % If no warning, move lower bound up
    catch ME
        if contains(ME.message, 'Matrix is close to singular or badly scaled')
            upper_bound = mid_theta; % If warning, move upper bound down
        else
            rethrow(ME);
        end
    end
end

if branchA
    final_theta = floor(lower_bound * 1e3) / 1e3; % Round down to nearest 1e-3 for larger theta
    fprintf(['Safe upper bound for theta is: [', repmat('%.3f ', 1, length(theta)), ']\n'], final_theta);
else
    final_theta = floor(lower_bound * 1e16) / 1e16; % Round down to nearest 1e-16 for smaller theta
    fprintf(['Safe upper bound for theta is: [', repmat('%.16f ', 1, length(theta)), ']\n'], final_theta);
end

warning(orig_warning_state.state, 'MATLAB:nearlySingularMatrix');

end

function GP(xTrain, theta)
    theta_K = repmat(theta', 1, length(xTrain));
    d1 = pdist2(xTrain', xTrain', 'euclidean');
    K = exp(-(d1./theta_K).^2/2).';
    inv(K);
end
