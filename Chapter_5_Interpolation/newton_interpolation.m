clc
clear
close all

x = [0;  2;  3; 5];
y = [1; -3; -4; 5];

[y_interp] = NewtonInterp(x, y);

% 计算牛顿插值法的结果
function [y_interp] = NewtonInterp(x, y)
    a = min(x);
    b = max(x);
    
    x_interp = linspace(a, b, 1000)';

    y_interp = zeros(length(x_interp), 1);
    diff_table = CalcDiffTable(x, y);
    %error = zeros(length(x_interp), 1);
    
    for i = 1:length(x_interp)
        extend_row = x_interp(i) - [x_interp(i) - 1; x(1:end-1, 1)];
        extend_row = cumprod(extend_row);
        y_interp(i) = diag(diff_table)' * extend_row;
        %error(i) = y_true(i) - y_interp(i);
    end
    
    fprintf("According to the source, we can give following data：\n");
    fprintf("    f");
    space_num = 11;
    diff_num = 1;
    for i = 2 : size(diff_table, 1)
        for j = 1 : space_num
            fprintf(" ");
        end
        fprintf("f");
        for j = 1 : diff_num
            fprintf("d");
        end
        space_num = space_num - 1;
        diff_num = diff_num + 1;
    end
    fprintf("\n");
    PrintMatrix(diff_table);    

    fprintf("\nThe newton interpolation formula: \n");
    DispPoly(diff_table, x);
end

% 计算差分表
function diff_table = CalcDiffTable(x, y)
    n = length(x);
    diff_table = zeros(n, n);
    
    diff_table(:,1) = y;
    
    for i = 2:n
        for j = i:n
            diff_table(j, i) = (diff_table(j, i-1) - diff_table(j-1, i-1))/(x(j) - x(j+1-i));  
        end
    end
end

% 输出插值多项式表达式
function DispPoly(diff_table, origin_points)
    syms x;
    extend_row = x - [x - 1; origin_points(1:end-1, 1)];
    extend_row = cumprod(extend_row);
    result = diag(diff_table) .* extend_row;
    
    fprintf("p(x) = " + char(result(1)) + "\n");
    for i = 2:length(result)
        fprintf("+ " + char(result(i)) + "\n");
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