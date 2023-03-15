clc
clear
close all

N = 3;  % Nodes num
h = 0.2; % Step length
x0 = 0;  % Start point
y0 = 1;  % Initial solution
diff_func = @(x, y) -y - x.*y.^2; % diffrential equation
animation_flag = true;

[x_list, y_list] = EulerMethod(N, h, x0, y0, diff_func, animation_flag);

function [x_list, y_list] = EulerMethod(N, h, x0, y0, diff_func, animation_flag)
    x_list = (x0 : h : N*h)';
    y_list = ones(length(x_list), 1) * y0;
    
    for n = 1 : N
        xn = x_list(n);
        yn = y_list(n);
        y_predict = yn + h * diff_func(xn, yn); 
        y_correction = yn + h * diff_func(xn + h, y_predict);
        y_list(n + 1) = (1/2) * (y_predict + y_correction);
    end
    
    % Plot result
    if animation_flag
        figure("Name", "Numerical Solution")
        hold on; grid on;
        plot(x_list, y_list, "LineWidth", 1.5);
    end

    % Print solution
    solution = [x_list, y_list];
    fprintf("According to the source, we can give following data：\n")
    PrintMatrix(solution);
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end