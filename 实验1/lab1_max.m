A = [0 5 1 0 0;6 2 0 1 0;1 1 0 0 1];
b = [15 24 5];
Xn = [1 2];
Xb = [3 4 5];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
N = [0 5;6 2; 1 1];
B = [1 0 0;0 1 0;0 0 1];
Cn = [2 1];
Cb = [0 0 0];
sigma = Cn - Cb * B * N;
while max(sigma) > 0
    inpos = find(sigma==max(sigma));
    inpos = inpos(1);
    in = Xn(inpos);
    a = B * A(:,in);
    theta = (B * b')./a;
    for i = 1:size(theta)
        if(theta(i)<0 || a(i) <0) 
            theta(i) = Inf;
        end
    end
    outpos = find(theta == min(theta));
    outpos = outpos(1);
    out = Xb(outpos);
    E = eye(3);
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
for i=1:6
    pos = find(Xb == i);
    if(isempty(pos))
        fprintf('%f ',0);
    else
        fprintf('%f ',X(pos));
    end
end
disp(z)