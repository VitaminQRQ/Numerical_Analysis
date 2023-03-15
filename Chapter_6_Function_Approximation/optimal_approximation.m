clc
clear
close all

source_function = @(x) cos(x);

function_basis = {@(x) 1;
                  @(x) x.^2;
                  @(x) x.^4};

order = size(function_basis, 1);

lb = -pi/2;
ub =  pi/2;

animation_flag = true;

% Construct matrix G
matrix_G = zeros(order, order);

syms x;
temp_idx = 1;
for i = 1 : order
    for j = 1 : order
        phi_i = function_basis{temp_idx, 1};
        phi_j = function_basis{j, 1};
        phi = phi_i(x) .* phi_j(x);
        matrix_G(i, j) = int(phi, x, lb, ub);
    end
    temp_idx = temp_idx + 1;
end

% Construct matrix b
matrix_b = zeros(order, 1);
for i = 1 : order
    phi_i = function_basis{i, 1};
    f_phi = phi_i(x) * source_function(x);
    matrix_b(i) = int(f_phi, x, lb, ub);
end

params = matrix_G \ matrix_b;

% Print Solution
fprintf("matrix G = \n");
PrintMatrix(matrix_G);

fprintf("\nmatrix b = \n");
PrintMatrix(matrix_b);

fprintf("\nLeast square params a =\n")
PrintMatrix(params);

if animation_flag
    animate_x = (lb : 0.01 : ub)';
    source_y = source_function(animate_x);

    animate_y = zeros(length(animate_x), 1);
    temp_y = ones(length(animate_x), 1);

    for i = 1 : length(params)
        phi = function_basis{i, 1};
        animate_y = animate_y + params(i) * phi(animate_x);
    end

    figure("Name", "Optimal Approximation")
    hold on; grid on; axis auto;
    plot(animate_x, animate_y, "LineWidth", 1.5);
    plot(animate_x, source_y, "--", "LineWidth", 2);
    legend("approximate function", "source function");
end

function PrintMatrix(matrix)
    for i = 1 : size(matrix, 1)
        for j = 1 : size(matrix, 2)
            fprintf("%10.4f  ", matrix(i, j));
        end
        fprintf("\n")
    end    
end