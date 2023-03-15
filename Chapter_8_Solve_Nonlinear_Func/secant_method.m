clc
clear
close all

x0 = 5;
x1 = 4;

func = @(x) tan(x) - (x./2);

tolerance = 1e-2;

xn = NewtonMethod(x0, x1, func, tolerance);

function [x_n, hist_data] = NewtonMethod(x0, x1, func, tolerance)
    max_iter = 1000;
    hist_data = zeros(max_iter, 6);
    iter = 0;
    error = 1;
    
    x_prev = x0;
    x_n = x1;

    while iter < max_iter && error > tolerance       
        f_d = (func(x_n) - func(x_prev)) / (x_n - x_prev);
        x_next = x_n - func(x_n) / f_d;
        hist_data(iter + 1, :) = [x_prev, x_n, func(x_n), f_d, x_next, error];
        
        iter = iter + 1;
        error = abs(x_next - x_n);
        x_prev = x_n;
        x_n = x_next;
    end
    
    if iter == max_iter
        fprintf("Error\n");
        return;
    end

    hist_data = hist_data(1:iter, :);
    
    % Plot result
    animate_x = (min(x0, x1) - 5 : 0.01 : max(x0, x1) + 5)';
    animate_y = func(animate_x);
    
    figure("Name", "Function Root")
    hold on; grid on; axis tight;
    plot(animate_x, animate_y, "LineWidth", 1.5);
    scatter(x_n, func(x_n), 40, "LineWidth", 1.5);


    % Print solution
    fprintf("According to the source, we can give following data：\n");
    fprintf("    xn-1,       xn,         f(xn),      f'(xn),     xn+1,       error\n");
    PrintMatrix(hist_data);

    fprintf("\nThe root of the funciton is: %7.4f\n", x_n);
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end