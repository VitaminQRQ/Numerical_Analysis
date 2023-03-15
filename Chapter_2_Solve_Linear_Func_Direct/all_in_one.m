clc
clear
close all

A = [ 1,  2,  1, -3;
      2,  5,  0, -5;
      1,  0, 14,  1;
     -3, -5,  1, 15];

b = [1; 2; 16; 8];
[x, x_lu, L, U] = AllInOne(A, b);

function [x, x_lu, L, U] = AllInOne(A, b)
    x = A\b;
    [L, U] = lu(A);

    y_lu = L\b;
    x_lu = U\y_lu;

    if A == A'
        L = zeros(size(A, 1), size(A, 1));
    
        for i = 1 : size(A, 1)
            for k = 1 : i
                L(i, k) = A(i, k);

                if k == i
                    for j = 1 : k - 1
                        L(i, k) = L(i, k) - L(k, j)^2;
                    end
                    L(i, k) = sqrt(L(i, k));
                else
                    for j = 1 : k - 1
                        L(i, k) = L(i, k) - L(i, j) * L(k, j); 
                    end
                    L(i, k) = L(i, k) / L(k, k);
                end

            end
        end
        U = L';
    end

    fprintf("L:\n");
    disp(L)

    fprintf("U:\n");
    disp(U)
end