
enigma = zeros(100, 4);

format long g

numOfIteration = 1;

for n = 2:101
    for k = 2:2
        numOfFuncUsedTemp = zeros(1, numOfIteration);
        for i = 1:numOfIteration
            [numOfFuncUsedTemp(i), TPS, FPS, TPG, FPG] = experimentOnSimplex(k, n);
        end
        numOfFuncUsed = mean(numOfFuncUsedTemp);
        [~, name] = ObjFunction([], k);
    end
    enigma(n-1, :) = [TPS ; FPS; TPG; FPG];
end

semilogy(2:101, enigma);
xlabel('Dimension');
ylabel('Ratio');
legend('TPS', 'FPS', 'TPG', 'FPG');










% numOfFuncUsedTemp = zeros(1, numOfIteration);
    % for i = 1:numOfIteration
    %     numOfFuncUsedTemp(i) = mainWOSurr(k, n);
    % end
    % numOfFuncUsed = mean(numOfFuncUsedTemp);
    % [~, name] = ObjFunction([], k);
    % disp(name + " without surrogate model: " + num2str(numOfFuncUsed));
    % 
    % 
    % numOfFuncUsedTemp = zeros(1, numOfIteration);
    % for i = 1:numOfIteration
    %     numOfFuncUsedTemp(i) = mainWithSurr(k, n);
    % end
    % numOfFuncUsed = mean(numOfFuncUsedTemp);
    % [~, name] = ObjFunction([], k);
    % disp(name + " with surrogate model: " + num2str(numOfFuncUsed));


