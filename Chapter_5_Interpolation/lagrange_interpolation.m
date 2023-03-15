clc
clear
close all

x_raw = [1; 1.1;     1.2;     1.3;     1.4];
y_raw = [1; 1.23368; 1.55271; 1.99372; 2.661170];
x_interp = 1.25;
[A_list, L] = LagrangeInterpolation(x_raw, y_raw, x_interp);

A2 = ((x_interp - 1)/(1.1 - 1)) * ...
     ((x_interp - 1.2)/(1.1 - 1.2)) * ...
     ((x_interp - 1.3)/(1.1 - 1.3)) * ...
     ((x_interp - 1.4)/(1.1 - 1.4));

function [A_list, L] = LagrangeInterpolation(x_raw, y_raw, x)
    x_raw = reshape(x_raw, [length(x_raw), 1]);
    y_raw = reshape(y_raw, [length(y_raw), 1]);
    A_list = ones(size(x_raw, 1), 1);

    current_idx = 0;

    for i = 1 : size(x_raw, 1)
        current_idx = current_idx + 1;
        x_current = x_raw(current_idx);
        
        for j = 1 : size(x_raw, 1)
            if current_idx == j
                continue;
            end
            A_list(i) = A_list(i) * (x - x_raw(j))/(x_current - x_raw(j));
        end
    end
    
    fprintf("According to the source, we can give following data：\n");
    fprintf("    Ak\n");

    PrintMatrix(A_list);

    L = A_list .* y_raw;
    fprintf("\nNumerical solution is: %7.4f\n", sum(L));
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end