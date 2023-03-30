%获得问题输入
labmda = input("lambda:");
mu = input("mu:");
c = input("c:");
N = input("N:");

rho = labmda / (c * mu);
sum = 0;
for i = 0 : c
    sum = sum + ((c * rho) ^ i) / factorial(i) ;
end
P0 = 1 / (sum + c^c / factorial(c) * rho * (rho^c - rho^N) / ( 1 - rho ) );
fprintf("P0:%f\n",P0);

for i = 1 : c
    P = (c * rho)^i / factorial(i) * P0;
    fprintf("P%d:%f\n", i, P);
end

for i = c + 1 : N
    P = c^c / factorial(c) * rho^i * P0;
    fprintf("P%d:%f\n", i, P);
end

Lq = P0 * rho * (c * rho)^c / (factorial(c) * (1 - rho)^2) * (1 - rho^(N-c) - (N - c) * rho^(N-c) * (1-rho));
fprintf("Lq:%f\n",Lq);

Ls = Lq + c * rho * (1-P);
fprintf("Ls:%f\n",Ls);

Wq = Lq / (labmda * (1 - P));
fprintf("Wq:%f\n",Wq);

Ws = Wq + 1 / mu;
fprintf("Ws:%f\n",Ws);

