clc
clear
close all

%% Create band matrix
n = 8;
a = ones(n, 1) * -2;
b = ones(n, 1) * 5;
c = ones(n, 1) * (-2);
d = zeros(n, 1);
d(1) = 220/27;

a(1) = NaN;
b(1) = 2;
c(n) = NaN;
x = BandMatrixLU(a, b, c, d);

%% Solve linear equations
function x = BandMatrixLU(a, b, c, d)
    n = size(a, 1);
    
    l = ones(n, 1) * NaN;
    u = ones(n, 1) * NaN;
    
    u(1) = b(1);
    
    for i = 2 : n
        l(i) = a(i) / u(i - 1);
        u(i) = b(i) - c(i - 1) * l(i);
    end
    y = ones(n, 1) * NaN;
    x = ones(n, 1) * NaN;
    
    fprintf("L: \n");
    disp(l);

    fprintf("U：\n");
    disp(u);

    y(1) = d(1);
    for i = 2 : n
        y(i) = d(i) - l(i) * y(i - 1);
    end
    
    x(n) = y(n) / u(n);
    for i = n-1 : -1 : 1
        x(i) = (y(i) - (c(i)*x(i + 1))) / u(i);
    end

    fprintf("x：\n");
    disp(x);
end