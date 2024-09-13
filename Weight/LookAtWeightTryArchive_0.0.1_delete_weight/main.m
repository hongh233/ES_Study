format long g

dimension = 10;
archive = dimension * 8;

numOfIteration = 1;
global data;
global minWeight;
global maxWeight;
global navigation;

minWeight = zeros(50000, 1);
maxWeight = zeros(50000, 1);

navigation = zeros(1, archive);

data = cell(50000, 8 + archive);
data(1, 1:8) = {"i", "judge", "sigma", "theta", "theta_new","fTest", "fx", "fy"};

for k = 5:5
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

