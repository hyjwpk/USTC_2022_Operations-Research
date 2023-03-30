A = [-0.4 0.6 0.6 0 0 0 0 0 0      1 0 0 0 0 0 0 0;
     -0.2 -0.2 0.8 0 0 0 0 0 0     0 1 0 0 0 0 0 0;
     0 0 0 -0.85 0.15 0.15 0 0 0   0 0 1 0 0 0 0 0;
      0 0 0 -0.6 -0.6 0.4 0 0 0    0 0 0 1 0 0 0 0;
      0 0 0 0 0 0 -0.5 -0.5 0.5    0 0 0 0 1 0 0 0;
      1 0 0 1 0 0 1 0 0            0 0 0 0 0 1 0 0;
      0 1 0 0 1 0 0 1 0            0 0 0 0 0 0 1 0;
      0 0 1 0 0 1 0 0 1            0 0 0 0 0 0 0 1
      ];
b = [0 0 0 0 0 2000 2500 1200];
Xn = [1 2 3 4 5 6 7 8 9];
Xb = [10 11 12 13 14 15 16 17]; 
N = [-0.4 0.6 0.6 0 0 0 0 0 0      ;
     -0.2 -0.2 0.8 0 0 0 0 0 0     ;
     0 0 0 -0.85 0.15 0.15 0 0 0   ;
      0 0 0 -0.6 -0.6 0.4 0 0 0    ;
      0 0 0 0 0 0 -0.5 -0.5 0.5    ;
      1 0 0 1 0 0 1 0 0            ;
      0 1 0 0 1 0 0 1 0            ;
      0 0 1 0 0 1 0 0 1            ];
B = eye(8);
Cn = [0.9 1.4 1.9 0.45 0.95 1.45 -0.05 0.45 0.95];
Cb = [0 0 0 0 0 0 0 0];
sigma = Cn - Cb * B * N;
while max(sigma) > 0
    in = 18;
    for i=1:size(sigma,2)
        if ((sigma(i) > 0) && Xn(i) < in)
            in = Xn(i);
            inpos = i;
        end
    end
    a = B * A(:,in);
    theta = (B * b')./a;
    for i = 1:size(theta)
        if(theta(i)<0 || a(i) <0) 
            theta(i) = Inf;
        end
    end
    outpos = find(theta == min(theta));
    out = outpos;
    for i=1:size(out)
        out(i) = Xb(out(i));
    end
    outpos = outpos(out == min(out));
    out = Xb(outpos);
    E = eye(8);
    P = B * A(:,in);
    for i = 1:size(b,2)
        if (i==outpos)
            E(i,outpos) = 1/P(i);
        else
            E(i,outpos) = -P(i)/P(outpos);
        end
    end
    B = E*B;
    Xn(inpos) = out;
    Xb(outpos) = in;
    N(:,inpos) = A(:,out);
    [Cb(outpos),Cn(inpos)] = deal(Cn(inpos),Cb(outpos));
    sigma = Cn - Cb * B * N;
end
X = B*b';
z = Cb*X;
for i=1:9
    pos = find(Xb == i);
    if(isempty(pos))
        fprintf('%f ',0);
    else
        fprintf('%f ',X(pos));
    end
end
disp(z)