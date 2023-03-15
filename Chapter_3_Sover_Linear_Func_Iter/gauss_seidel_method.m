clc
clear
close all

A = [10,  1,   2,   3,  4;
     1,   9,  -1,   2, -3;
     2,  -1,   7,   3, -5;
     3,   2,   3,  12, -1;
     4,  -3,  -5,  -1,  15];
 
b = [12; -27; 14; -17; 12];

x0 = [0; 0; 0; 0; 0];

tolerance = 1e-2;

[result, x, error, iter] = JacobMethod(A, b, x0, tolerance);

function [result, x_list, error_list, iter] = JacobMethod(A, b, x0, tolerance)
    x = x0;   
    error = Inf;   
    max_iter = 1000;
    iter = 0;    
    
    x_list = zeros(max_iter, length(x0));
    error_list = zeros(max_iter, 1);

    D = eye(length(x0), length(x0)) .* diag(A);
    L = -tril(A, -1);
    U = -triu(A, 1);
    M = (D - L) \ U;
    g = (D - L) \ b;
    
    
    while (error > tolerance) && (iter < 1000)
        x = M * x + g;
        x_list(iter + 1, :) = x';
        
        error = norm(b - A*x)/norm(b);
        error_list(iter + 1) = error;
        
        iter = iter + 1;
    end

    error_list = error_list(1:iter, :);
    x_list = x_list(1:iter, :);
    
    result = x;

    % Print solution
    fprintf("According to the source, we can give following data：\n");
    fprintf("    x0");
    for i = 2 : length(x0)
        fprintf("          x%d", i-1);
    end
    fprintf("          error\n");
    PrintMatrix([x_list, error_list]);

    fprintf("\nThe result is：\n");
    PrintMatrix(result');
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end