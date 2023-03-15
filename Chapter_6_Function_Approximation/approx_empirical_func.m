clc
clear
close all

% Source data
x_list = [57.59, 108.11, 149.57, 227.84];
y_list = [87.97, 224.70, 365.26, 696.98];

% Linearization function
x_linearize_func = @(x) log(x);
y_linearize_func = @(y) log(y);

% Approximation order
order = 1;

% Display figure or not
animation_flag = true;

[data_list, matrix_A, matrix_b, params] = LeastSquare(x_list, ...
                                                      y_list, ...
                                                      x_linearize_func, ...
                                                      y_linearize_func, ...
                                                      order, ...
                                                      animation_flag); 

function [data_list, matrix_A, matrix_b, params] = LeastSquare(x_list, y_list, x_linearize_func, y_linearize_func, order, animation_flag)
    x_tilde = x_linearize_func(x_list);
    y_tilde = y_linearize_func(y_list);
    
    x_tilde = reshape(x_tilde, [length(x_tilde), 1]);
    y_tilde = reshape(y_tilde, [length(x_tilde), 1]);   

    data_list = zeros(length(x_tilde), 2 + order * 3);
    
    % 1, x, x^2, x^3, ...
    temp_x = ones(length(x_tilde), 1);
    for i = 1 : 2 + (2 * order) - 1
        data_list(:, i) = temp_x;
        temp_x = temp_x .* x_tilde;
    end
    
    % y, yx, yx^2, ...
    temp_x = ones(length(y_tilde), 1);
    for i =  2 + 2 * order : 2 + order * 3
        data_list(:, i) = y_tilde .* temp_x;
        temp_x = temp_x .* x_tilde;
    end
    
    % n, sum_x, sum_x^2 ..., sum(y), 
    sum_elements = zeros(1, size(data_list, 2));
    for i = 1 : size(data_list, 2)
        sum_elements(i) = sum(data_list(:, i));
    end
    
    % Construct matrix_A
    sum_idx = 1;
    matrix_A = zeros(order+1, order+1);
    for i = 1 : size(matrix_A, 1)
        for j = 1 : size(matrix_A, 2)
            matrix_A(i, j) = sum_elements(sum_idx + j - 1);
        end
        sum_idx = sum_idx + 1;
    end
    
    % Construct matrix_B
    sum_idx = 2 + 2 * order;
    matrix_b = zeros(order+1, 1);
    for i = 1 : size(matrix_b, 1)
        matrix_b(i) = sum_elements(sum_idx);
        sum_idx = sum_idx + 1;
    end
    
    % Get solution
    params = matrix_A \ matrix_b;
    
    % find inverse function
    syms x y;
    fx = x_linearize_func(x);
    fy = y_linearize_func(y);

    gx = matlabFunction(finverse(fx));
    gy = matlabFunction(finverse(fy));

    % Print solution
    fprintf("According to the source, we can give following data：\n");
    PrintMatrix(data_list);
    
    fprintf("\nSum of each cols：\n");
    PrintMatrix(sum_elements);

    fprintf("\nLeast square matrix：");
    fprintf("Matrix A = \n")
    PrintMatrix(matrix_A);

    fprintf("\nMatrix b = \n")
    PrintMatrix(matrix_b);

    fprintf("\nLeast square params a =\n")
    PrintMatrix(params);
    
    fprintf("\nSouce function least square params a' =\n")
    PrintMatrix(gx(params));

    if animation_flag
        animate_x = (min(x_tilde) : 0.01 : max(x_tilde))';
        animate_y = zeros(length(animate_x), 1);
        
        temp_y = ones(length(animate_x), 1);
        for i = 1 : length(params)
            animate_y = animate_y + params(i) .* temp_y;
            temp_y = temp_y .* animate_x;
        end

        figure("Name", "least_square_result")
        hold on; grid on; axis auto;
        plot(gx(animate_x), gy(animate_y), "LineWidth", 1.5);
        scatter(x_list, y_list, 50, "filled", "LineWidth", 1.5);
        xlabel("X");
        ylabel("Y");
    end
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end