clc
clear
close all

x0 = 4;
func = @(x) tan(x) - (x./2);

tolerance = 1e-2;

xn = NewtonMethod(x0, func, tolerance);

function [xn, hist_data] = NewtonMethod(x0, func, tolerance)
    syms x;
    f = func(x);
    f_d = matlabFunction(diff(f, x));

    max_iter = 1000;
    hist_data = zeros(max_iter, 5);
    iter = 0;
    error = 1;
    
    xn = x0;
    while iter < max_iter && error > tolerance       
        x_next = xn - func(xn) / f_d(xn);
        hist_data(iter + 1, :) = [xn, func(xn), f_d(xn), x_next, error];
        
        iter = iter + 1;
        error = abs(x_next - xn);
        xn = x_next;
    end
    
    if iter == max_iter
        fprintf("Error\n");
        return;
    end

    hist_data = hist_data(1:iter, :);

    % Plot result
    animate_x = (x0 - 5 : 0.01 : x0 + 5)';
    animate_y = func(animate_x);
    
    figure("Name", "Function Root")
    hold on; grid on; axis tight;
    plot(animate_x, animate_y, "LineWidth", 1.5);
    scatter(xn, func(xn), 40, "LineWidth", 1.5);

    % Print solution
    fprintf("According to the source, we can give following data：\n");
    fprintf("    xn,         f(xn),      f'(xn),     xn+1,       error\n");
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