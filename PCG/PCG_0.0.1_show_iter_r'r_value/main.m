% rng(13);
format long g

dimension = 10;
archive = dimension * 8;

global fTest_store;
fTest_store = zeros(1, 5);


numOfIteration = 1;

for k = 5:5

    numOfFuncUsedTemp = zeros(1, numOfIteration);
    for i = 1:numOfIteration
        numOfFuncUsedTemp(i) = mainWithSurr(k, dimension, archive);
    end
    numOfFuncUsed = mean(numOfFuncUsedTemp);
    [~, name] = ObjFunction([], k);
    disp(name + " with surrogate model: " + num2str(numOfFuncUsed));

end





figure;

yyaxis left;
plot(fTest_store(:, 3), 'b-o');
ylabel('Ratio of fTest\_PCG to fTest\_INV');
xlabel('Iterations');
grid on;

yyaxis right;
plot(fTest_store(:, 5), 'r-o');
ylabel('Number of Iterations');
grid on;

title('Ratio of fTest\_PCG to fTest\_INV and Number of Iterations vs. Iterations');
legend('Ratio', 'Number of Iterations');





