% objective function
function val = Obj2D(x1, x2)
    val = x1 .^2 + x2 .^2;
    % val = (x1 - 3) * 2 + 2 .* x1 .* x2 + (2 .* x2 + 3) .* 2 - 3;
   
end