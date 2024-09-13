% objective function
function [val, expr] = Obj1D(x)
    % val = x;

    % val = x .^2 + 10;
    % expr = 'x .^2 + 10';


    val = abs(x) - 50;
    expr = '|x| - 50';

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