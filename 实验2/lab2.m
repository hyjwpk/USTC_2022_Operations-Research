C = [0 5 4 3;2 8 3 4;1 7 6 2];
C_copy = C;
[r, l] = size(C);
S = zeros(r,l);
S_pos = zeros(r,l);
Need = [1500 2000 3000 3500];
Need_copy = Need;
Supply = [2500 2500 5000];
Supply_copy = Supply;
Find = 0;

% 伏格尔法求初始解
for k = 1 : r + l - 1
    if(k == r + l -1 && Find)
        break;
    end
    delta = zeros(1,r+l);
    for i = 1 : r
        if(Supply_copy(i) > 0)
            min1 = Inf;
            min2 = Inf;
            for j = 1 : l
                if(Need_copy(j) > 0 && C(i, j) < min2)
                    if(C(i, j)< min1)
                        min2 = min1;
                        min1 = C(i, j);
                    else
                        min2 = C(i, j);
                    end
                end
            end
            delta(i) = min2 - min1; 
        end
    end
    for j = 1 : l
        if(Need_copy(j) > 0)
            min1 = Inf;
            min2 = Inf;
            for i = 1 : r
                if(Supply_copy(i) > 0 && C(i, j) < min2)
                    if(C(i, j)< min1)
                        min2 = min1;
                        min1 = C(i, j);
                    else
                        min2 = C(i, j);
                    end
                end
            end
            delta(j + r) = min2 - min1; 
        end
    end
    pos = find(delta == max(delta));
    pos = pos(1);
    if(pos <= r)
        posr = pos;
        posl = find(C_copy(posr,:) == min(C_copy(posr,:)));
        posl = posl(1);
    else
        posl = pos - r;
        posr = find(C_copy(:,posl) == min(C_copy(:,posl)));
        posr = posr(1);
    end
    S(posr, posl) = min(Supply_copy(posr),Need_copy(posl));
    S_pos(posr,posl) = 1;
    Supply_copy(posr) = Supply_copy(posr) - S(posr, posl);
    Need_copy(posl) = Need_copy(posl) - S(posr, posl);
    if(Supply_copy(posr) == 0)
        C_copy(posr,:) = Inf;
    end
    if(Need_copy(posl) == 0)
        C_copy(:,posl) = Inf;
    end
    % 退化
    if(Supply_copy(posr) == 0 && Need_copy(posl) == 0 && k~= r + l - 1 && ~Find)
        for m = 1 : r
            if(S_pos(m,posl)==0)
                S_pos(m,posl) = 1;
                Find = 1;
                break;
            end
        end
        for m = 1 : l
            if (Find)
                break;
            end
            if(S_pos(posr,m)==0)
                S_pos(posr,m) = 1;
                Find = 1;
                break;
            end
        end
    end     
end

while (true)
    % 位势法
    A = zeros(r+l,r+l);
    B = zeros(r+l,1);
    k = 1;
    for i = 1 : r
        for j = 1 : l
            if (S_pos(i,j) == 1)
                A(k,i) = 1;
                A(k,j + r) = 1;
                B(k,1) = C(i,j);
                k = k + 1;
            end
        end
    end
    A(r+l,1) = 1;
    X = linsolve(A, B);
    sigma = zeros(r,l);
    for i = 1 : r
        for j = 1 : l
            sigma(i,j) = C(i,j) - X(i) - X(j+r);
        end
    end
    if(min(min(sigma)) >= 0)
        break;
    end
    
    % 闭回路调整法
    [posr,posl] = find(sigma == min(min(sigma)));
    posr = posr(1);
    posl = posl(1);
    visited = S_pos;
    visited(visited == 0) = -1;
    visited(visited == 1) = 0;
    visited(posr,posl) = 2;
    path = zeros(r+l+1,2);
    path(1,1) = posr;
    path(1,2) = posl;
    num = 2;
    posr_last = posr;
    posl_last = posl;
    [visited,path,num,posr_last,posl_last] = lab2_func(visited,path,num,posr_last,posl_last);
    path(num:r+l+1,:) = [];
    num = num - 1;
    theta = Inf;
    for i = 1 : num
        if(mod(i,2) == 0 && S(path(i,1),path(i,2)) < theta)
            theta = S(path(i,1),path(i,2));
        end
    end
    for i = 1 : num
        if(mod(i,2) == 0)
            S(path(i,1),path(i,2)) = S(path(i,1),path(i,2)) - theta;
        else
            S(path(i,1),path(i,2)) = S(path(i,1),path(i,2)) + theta;
        end   
    end
    S_pos(posr,posl) = 1;
    for i = 1 : num
        if(mod(i,2) == 0 && S(path(i,1),path(i,2)) == 0)
            S_pos(path(i,1),path(i,2)) = 0;
            break;
        end
    end
end

cost = 0;
for i = 1 : r
    for j = 1 : l
        cost = cost + S(i,j) * C(i,j);
    end
end
disp(S)

% 闭回路调整法
function [visited,path,num,posr_last,posl_last] = lab2_func(visited,path,num,posr_last,posl_last)
    if(mod(num,2)==0)
        r_possible = find(visited(:,posl_last)==0);
        if(isempty(r_possible))
            return;
        end
        for i = r_possible'
            posr_last = i;
            visited(posr_last,posl_last) = 1;
            path(num,1) = posr_last;
            path(num,2) = posl_last;
            num = num + 1;
            if((path(1,1) == posr_last || path(1,2) == posl_last) && num >=5)
                break;
            end
            [visited,path,num,posr_last,posl_last] = lab2_func(visited,path,num,posr_last,posl_last);
            if((path(1,1) == posr_last || path(1,2) == posl_last) && num >=5)
                break;
            end
            num = num -1;
            posr_last = path(num,1);
            posl_last = path(num,2);
        end
    else
        l_possible = find(visited(posr_last,:)==0);
        if(isempty(l_possible))
            return;
        end
        for i = l_possible
            posl_last = i;
            visited(posr_last,posl_last) = 1;
            path(num,1) = posr_last;
            path(num,2) = posl_last;
            num = num + 1;
            if((path(1,1) == posr_last || path(1,2) == posl_last) && num >=5)
                break;
            end
            [visited,path,num,posr_last,posl_last] = lab2_func(visited,path,num,posr_last,posl_last);
            if((path(1,1) == posr_last || path(1,2) == posl_last) && num >=5)
                break;
            end
            num = num -1;
            posr_last = path(num,1);
            posl_last = path(num,2);
        end
    end
end