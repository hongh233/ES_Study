
n = 2;
funcIndex = 1;
x0 = randn(1, n);
x1 = x0 + 0.1 * randn(1, n);
x2 = x0 + 0.1 * randn(1, n);
x3 = x0 + 0.1 * randn(1, n);
x4 = x0 + 0.1 * randn(1, n);
x5 = x0 + 0.1 * randn(1, n);

fx0 = ObjFunction(x0, funcIndex);
fx1 = ObjFunction(x1, funcIndex);
fx2 = ObjFunction(x2, funcIndex);
fx3 = ObjFunction(x3, funcIndex);
fx4 = ObjFunction(x4, funcIndex);
fx5 = ObjFunction(x5, funcIndex);


figure;
hold on;
scatter3(0, 0, 0, 'green', 'filled');
scatter3(x0(1), x0(2), fx0, 'red', 'filled');
scatter3(x1(1), x1(2), fx1, 'black', 'filled');
scatter3(x2(1), x2(2), fx2, 'black', 'filled');
scatter3(x3(1), x3(2), fx3, 'black', 'filled');
scatter3(x4(1), x4(2), fx4, 'black', 'filled');
scatter3(x5(1), x5(2), fx5, 'black', 'filled');


A = [x1 - x0; x2 - x0; x3 - x0; x4 - x0; x5 - x0];
b = [fx1; fx2; fx3; fx4; fx5];
g = inv(A' * A) * (A' * b);


gPoint = x0 + g';
fxg = ObjFunction(gPoint, funcIndex);
plotx = [x0(1), gPoint(1)];
ploty = [x0(2), gPoint(2)];
plotz = [fx0, fxg];
plot3(plotx, ploty, plotz, '-o');
scatter3(gPoint(1), gPoint(2), fxg, 'blue', 'filled');


% compute real gradient and plot
h = 1e-5;
df_dx = (ObjFunction([x0(1) + h, x0(2)], funcIndex) - ObjFunction([x0(1) - h, x0(2)], funcIndex)) / (2 * h);
df_dy = (ObjFunction([x0(1), x0(2) + h], funcIndex) - ObjFunction([x0(1), x0(2) - h], funcIndex)) / (2 * h);
realG = [df_dx, df_dy];
realGPoint = x0 + realG;
fxRealG = ObjFunction(realGPoint, funcIndex);
plotx = [x0(1), realGPoint(1)];
ploty = [x0(2), realGPoint(2)];
plotz = [fx0, fxRealG];
plot3(plotx, ploty, plotz, '-o');
scatter3(realGPoint(1), realGPoint(2), fxRealG, 'cyan', 'filled');



% Mesh plot
preTempX1 = linspace(-10, 10, 120);
preTempX2 = linspace(-10, 10, 120);
[px1, px2] = meshgrid(preTempX1, preTempX2);
f = zeros(size(px1));

% Evaluate the objective function at each grid point
for i = 1:size(px1, 1)
    for j = 1:size(px1, 2)
        f(i, j) = ObjFunction([px1(i, j), px2(i, j)], funcIndex);
    end
end

mesh(px1, px2, f, 'EdgeColor', 'flat', 'FaceAlpha', 0.5);

