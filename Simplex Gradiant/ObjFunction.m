% objective function
function [val, name] = ObjFunction(x, index)
    global funcCallCount;
    funcCallCount = funcCallCount + 1;
    switch index
        case 1
            val = ((sum(x.^2))^(1/2));
            name = 'linear sphere';
        case 2
            val = (sum(x.^2))^(1);
            name = 'quadratic sphere';
        case 3
            val = (sum(x.^2))^(3/2);
            name = 'cubic sphere';
        case 4
            n = length(x);
            val = 0;
            for i = 1:n
                val = val + sum(x(1:i))^2;
            end
            name = 'Schwefel''s function';
        case 5
            beta = 1;
            n = length(x);
            val = sum(beta * (x(2:n) - x(1:n-1).^2).^2 + (1 - x(1:n-1)).^2);
            name = 'quartic function';
        otherwise
            val = 'Error';
            name = 'Error';
    end
end