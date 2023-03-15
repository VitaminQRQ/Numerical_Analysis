clc
clear
close all

A = [-2,  3;
      1, -1];
 
x0 = [0; 1];

tolerance = 1e-3;

[x_list, y_list, alpha_list, lambda] = CalcMaxEigen(A, x0, tolerance);

function [x_list, y_list, alpha_list, lambda] = CalcMaxEigen(A, x0, tolerance)   
    x0 = reshape(x0, [length(x0), 1]);    
    
    max_iter = 5000;
    error = Inf;
    iter = 0;
    lambda = 0;
    x = x0;
    
    x_list = zeros(max_iter, length(x0));
    y_list = zeros(max_iter, length(x0));
    alpha_list = zeros(max_iter, 1);
    
    while iter < max_iter && error > tolerance
        alpha = max(abs(x));
        y = x / alpha;
        x = A * y;
        
        x_list(iter + 1, :) = x';
        y_list(iter + 1, :) = y';
        alpha_list(iter + 1) = alpha;
        
        error = abs(lambda - alpha);
        lambda = alpha;
        iter = iter + 1;
        
    end
    
    x_list = x_list(1:iter, :);
    y_list = y_list(1:iter, :);
    alpha_list = alpha_list(1:iter, :);

    % Print Result
    fprintf("According to the source, we can give following data：\n");
    fprintf("    x1");
    for i = 2 : length(x0)
        fprintf("          x%d", i)
    end
    fprintf("          alpha");
    fprintf("       y1");
    for i = 2 : length(x0)
        fprintf("          y%d", i);
    end
    fprintf("\n");
    PrintMatrix([x_list, alpha_list, y_list]);
    
    fprintf("\nThe maximum eigen value is: %.4f\n", lambda);
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end