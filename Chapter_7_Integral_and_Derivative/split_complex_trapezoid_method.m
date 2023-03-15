clc
clear
close all

epsilon = 3e-4;
func = @(x) 1./(x + cos(x));

I_1 = ComplexTrapzoid(func, 0, pi, epsilon);

function I = ComplexTrapzoid(func, a, b, epsilon)
    tolerance = 3 * epsilon;
    max_iter = 10000;

    iter = 0;
    error = 1;
    
    m = 1;
    h = (b - a) / 2;
    T0 = h * (func(a) + func(b));
    T = T0;
    data_list = zeros(max_iter, 4);

    while iter < max_iter && error > tolerance
        F = 0;
        for k = 1 : 2^(m - 1)
            F = F + func(a + (2*k - 1)*h);
        end

        T = 0.5 * T0 + h * F;
        
        data_list(iter + 1, :) = [m, h, T0, F];

        error = abs(T - T0);
        iter = iter + 1;
        m = m + 1;
        h = h/2;
        T0 = T;
    end
    data_list = data_list(1:iter, :);
    
    % Print result
    fprintf("According to the source, we can give following data：\n");
    fprintf("    m,          h,        T,       F\n");
    PrintMatrix(data_list);

    I = T;
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