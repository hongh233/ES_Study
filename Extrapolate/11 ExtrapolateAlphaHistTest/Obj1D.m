% objective function
function [val, expr] = Obj1D(x)
    % val = x;

    % val = x .^2 - 100;
    % expr = 'x .^2 - 100';


    % val = abs(x);
    % expr = '|x|';

    val = x .^ 4 + 100;
    expr = 'x .^ 4 + 100';

    

    % val = 10 + x .^2 - 10 * cos(2 * pi * x);
    
    % val = x .^3;
    % val = 1 / x;
    % val = x .^(1/2);
    % val = e .^x;
    % val = log(x);


    % val = x/3 + sin(3 * pi * x);
    % val = sin(x);
    
    
    % val = log(x);

    % val = 
end