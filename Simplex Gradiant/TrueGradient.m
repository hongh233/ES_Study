function g = TrueGradient(x, funcIndex)
    switch funcIndex
        case 1
            g = x / norm(x);  % linear sphere
        case 2
            g = 2 * x;  % quadratic sphere
        case 3
            g = 3 * (sum(x.^2)^(1/2)) * x;  % cubic sphere
        case 4
            n = length(x);
            g = zeros(n, 1);
            for i = 1:n
                for j = i:n
                    g(i) = g(i) + 2 * sum(x(1:j));
                end
            end
            % Schwefel's function
        case 5
            beta = 1;
            n = length(x);
            g = zeros(n, 1);
            g(1) = -4 * beta * x(1) * (x(2) - x(1)^2) - 2 * (1 - x(1));
            for i = 2:n-1
                g(i) = 2 * beta * (x(i) - x(i-1)^2) - 4 * beta * x(i) * (x(i+1) - x(i)^2) - 2 * (1 - x(i));
            end
            g(n) = 2 * beta * (x(n) - x(n-1)^2);
            % quartic function
        otherwise
            error('Unknown function index');
    end
end