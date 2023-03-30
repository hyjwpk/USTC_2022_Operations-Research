# 实验二 运输问题

## 运输问题模型的建立

​	A、B、C、D四种规格的服装共需要$1500+2000+3000+3500=10000$套，Ⅰ、Ⅱ、Ⅲ三个城市可供应服装共$2500+2500+5000=10000$套，这是一个`产销平衡`问题，需要`预期盈利`最大，可将表中各利润变为其负值+10，则以新表为成本，令`成本最低`即对应原表中`预期利润最大`。

新表如下

| 成本 |  A   |  B   |  C   |  D   | 供给 |
| :--: | :--: | :--: | :--: | :--: | :--: |
|  Ⅰ   |  0   |  5   |  4   |  3   | 2500 |
|  Ⅱ   |  2   |  8   |  3   |  4   | 2500 |
|  Ⅲ   |  1   |  7   |  6   |  2   | 5000 |
| 需求 | 1500 | 2000 | 3000 | 3500 |      |

## 实验方法与步骤

​	使用MATLAB建立`求解运输问题的模型`，主要分为三个部分，`伏格尔法`，`位势法`，`闭回路调整法`

- 初始化

  `C`为成本矩阵，`S`为解矩阵，`S_pos`为基变量的标记，`Need`为需求，`Supply`为供给

  ```matlab
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
  ```

- 伏格尔法

  流程：
  
  • 1. **计算行差和列差**：计算各行和各列的最小成本和次小成本的差额存入delta
  
  • 2. **选择基变量**：从行或列差额中选出最大者，选择它所在行或列中的最小成本对应的变量xij为基变量
  
  • 3. **确定基变量的值**：min(ai, bj)。如果为最后一个元素，停止。否则，进入下一步
  
  • 4. **更新产销平衡表**： ai ←ai - xij ， bj ← bj - xij
  
  • 5. **修改单位运价表**：划去 ai =0的Ai行或 bj =0的 Bj 列 
  
  • 6. **重复1-5**
  
  • 在出现`退化`时，在相应的行列中，选取一个未被划去的位置填0，用`S_pos`在填0的位置标记以区分基变量。
  
  对应的`MATLAB`代码如下，
  
  ```matlab
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
  ```

- 位势法

  利用`linsolve`函数求解`位势法`所需求解的线性方程，其中令$u_1=0$。

  ```matlab
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
  ```

- 闭回路调整法

  使用递归函数求解闭回路，函数如下

  ```matlab
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
  ```
  调用函数的过程如下
  
  ```matlab
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
  ```

​	使用`伏格尔法`求出`初始解`后，利用`位势法`判断`检验数`是否大于等于0，若存在小于0的`检验数`，采用`闭回路调整法`进行迭代，再利用`位势法`判断，重复迭代至`检验数`均大于等于0得到`最优解`。

## 实验结果

执行`lab2.m`的结果如下

```matlab
>> lab2
           0        2000         500           0
           0           0        2500           0
        1500           0           0        3500
```
输出结果为`最优解`各变量的值，表中各数代表各城市提供各类服装的数量

|      |  A   |  B   |  C   |  D   |
| :--: | :--: | :--: | :--: | :--: |
|  Ⅰ   |  0   | 2000 | 500  |  0   |
|  Ⅱ   |  0   |  0   | 2500 |  0   |
|  Ⅲ   | 1500 |  0   |  0   | 3500 |

`预期的最大盈利`为$2000*5+500*6+2500*7+1500*9+3500*8=72000$元
