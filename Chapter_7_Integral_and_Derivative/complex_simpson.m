clc
clear
close all

n = 10;
a = 1;
b = 2;
func = @(x) exp(1./x);

[I, data_list] = ComplexSimpson(n, a, b, func);

function [I, data_list] = ComplexSimpson(n, a, b, func)
    data_list = zeros(n/2, 4);
    
    I = func(a) + func(b); % Result
    h = (b - a) / n;       % Step
    
    % Simpson 求积
    m = n / 2;
    for k = 1 : m
        x_2km1 = a + (2 * k - 1) * h;
        I = I + 4 * func(x_2km1);
        data_list(k, 1) = x_2km1;
        data_list(k, 3) = func(x_2km1);
    
        if k < m
            x_2k = a + 2 * k * h;
            I = I + 2 * func(x_2k);
            data_list(k, 2) = x_2k;
            data_list(k, 4) = func(x_2k);
        end
    end
    data_list(m, 2:2:4) = NaN;
    I = (h/3) * I;
    
    % Print solution
    fprintf("According to the source, we can give following data：\n");
    fprintf("    x_2k-1,     x_2k,       f(x_2k),    f(x_2km1)\n");
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