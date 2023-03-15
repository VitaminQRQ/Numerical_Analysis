clc
clear
close all

n = 10;
a = 0;
b = 1;
func = @(x) exp(-x.^2);
[data_list, I] = ComplexTrapezoid(n, a, b, func);

function [data_list, I] = ComplexTrapezoid(n, a, b, func)
I = func(a) + func(b); % 复化梯形求积结果
h = (b - a) / n; % 步长
data_list = zeros(n - 1, 2);

% 复化梯形求积
for k = 1 : n - 1
    x_k = a + k * h;
    I = I + 2 * func(x_k);
    
    data_list(k, :) = [x_k, func(x_k)];
end
I = (h/2) * I;

% Print solution
fprintf("According to the source, we can give following data：\n");
fprintf("    x_k,        f(x_k)\n");
PrintMatrix(data_list);

fprintf("\nnumerical solution: %f\n", I);
fprintf("\nexact solution: %f\n", integral(func, a, b));
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end