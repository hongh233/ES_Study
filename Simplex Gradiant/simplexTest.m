% m = 4;
% D=2;
% x1 = rand(D,m);
% x1(:,2:end) = x1(:,1) + 0.01 * randn(D, m-1);
% % a = randn(2,1);
% f1 = (sum(x1.^2)).';
% b1 = f1(2:end) - f1(1);
% a1 = pinv((x1(:, 2:end) - x1(:,1)).');
% disp(a1 * b1);
% disp(x1(:,1)*2);
% horizontal axis: vary number of points, starting at n+1 and increase
% vertical axis: difference between g and sg (euclidean distance)
% run 20 times, plot the average
% do three times, use different scale parameter each time
f = @(x) (sum(x.^2)).';
grad = @(x) x*2;
DIMENSION = 20;
tiledlayout("horizontal")
scaleParam = [0.01, 0.1, 1];
for i = 1:3
    nexttile
    x_axis = zeros(1, 10*DIMENSION - DIMENSION);
    y_axis = zeros(1, 10*DIMENSION - DIMENSION);
    for k = 1:20
        x_axisT = [];
        y_axisT = [];
        for j = (DIMENSION+1):(10*DIMENSION)
            tSet = rand(DIMENSION, j);
            tSet(:, 2:end) = tSet(:,1) + scaleParam(i) * randn(DIMENSION, j-1);
            results = f(tSet);
            b = results(2:end) - f(1);
            a = pinv((tSet(:, 2:end) - tSet(:,1)).');
            sG = a * b;
            g = grad(tSet(:,1));
            diff = sqrt(sum(g - sG).^2);
    
            x_axisT = [x_axisT, j];
            y_axisT = [y_axisT, diff];
        end
        x_axis = x_axis + x_axisT;
        y_axis = y_axis + y_axisT;
    end
    x_axis = x_axis ./ 20;
    y_axis = y_axis ./ 20;
    plot(x_axis, y_axis);
end