rng(13);
format long g

dimension = 10;
archive = dimension * 8;

numOfIteration = 1;
global minWeight;
global maxWeight;
global navigation;

minWeight = zeros(50000, 1);
maxWeight = zeros(50000, 1);

navigation = zeros(1, archive);

for k = 4:4
    numOfFuncUsedTemp = zeros(1, numOfIteration);
    for i = 1:numOfIteration
        numOfFuncUsedTemp(i) = mainWithSurr(k, dimension, archive);
    end
    numOfFuncUsed = mean(numOfFuncUsedTemp);
    [~, name] = ObjFunction([], k);
    disp(name + " with surrogate model: " + num2str(numOfFuncUsed));
end


x = 1:3000;
figure; 
hold on;
plot(x, minWeight(1:3000), 'b-', 'Color', 'red'); 
plot(x, maxWeight(1:3000), 'b-', 'Color', 'blue'); 
xlabel('Index');
ylabel('weight value');
title('weight values over index');
grid on;
set(gca, 'yscale', 'log')
hold off;


