function [val, name] = ObjFunction(x, index)

    [n, m] = size(x); % 获取输入矩阵的维度

    switch index
        case 1
            val = sum(x.^2, 1).^(1/2); % 处理每个样本
            name = 'linear sphere';
        case 2
            val = sum(x.^2, 1).^(1); % 处理每个样本
            name = 'quadratic sphere';
        case 3
            val = sum(x.^2, 1).^(3/2); % 处理每个样本
            name = 'cubic sphere';
        case 4
            val = zeros(1, m); % 初始化结果向量
            for j = 1:m
                for i = 1:n
                    val(j) = val(j) + sum(x(1:i, j))^2; % 处理每个样本
                end
            end
            name = 'Schwefel''s function';
        case 5
            beta = 1;
            val = zeros(1, m); % 初始化结果向量
            for j = 1:m
                if n == 1
                    val(j) = beta * (x(1, j) - x(1, j).^2).^2 + (1 - x(1, j)).^2; % 处理一维情况
                else
                    for i = 2:n
                        val(j) = val(j) + beta * (x(i, j) - x(i-1, j).^2).^2 + (1 - x(i-1, j)).^2; % 处理每个样本
                    end
                end
            end
            name = 'quartic function';
        otherwise
            val = 'Error';
            name = 'Error';
    end
end