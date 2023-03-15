clc
clear
close all

a = 2;
b = 4;
func = @(x) x - log(x) - 2;
tolerance = 1e-3;

xn = BisectionMethod(a, b, func, tolerance);

function [xn, hist_data] = BisectionMethod(a, b, func, tolerance)
    max_iter = 1000;
    hist_data = zeros(max_iter, 5);
    iter = 0;
    error = 1;
    
    while iter < max_iter && error > tolerance
        xn = (a + b) / 2;
        
        hist_data(iter + 1, :) = [xn, a, b, func(xn), error];
        
        if func(a) * func(xn) < 0
            b = xn;
        else
            a = xn;
        end
        
        iter = iter + 1;
        error = (b - a)/2;
    end
    
    hist_data = hist_data(1:iter, :);
    
    % Plot result
    animate_x = (a - 5 : 0.01 : b + 5)';
    animate_y = func(animate_x);
    
    figure("Name", "Function Root")
    hold on; grid on; axis tight;
    plot(animate_x, animate_y, "LineWidth", 1.5);
    scatter(xn, func(xn), 40, "LineWidth", 1.5);
    
    % Print solution
    fprintf("According to the source, we can give following data：\n");
    fprintf("    xn,         a,          b,          f(x),       error\n");
    PrintMatrix(hist_data);

    fprintf("\nThe root of the funciton is: %7.4f\n", xn);
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end