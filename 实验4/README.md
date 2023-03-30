# 实验四  排队论

## M/M/c/N/∞排队系统的模型

$$
P_0 = \frac{1}{\sum_{k=0}^{c}\frac{(c\rho)^k}{k!} + \frac{c^c}{c!}\cdot \frac{\rho({\rho}^c-{\rho}^N)}{1-\rho}    } \\
P_n=\left\{\begin{matrix}
 \frac{(c\rho)^n}{n!}P_0 \quad (0\le n \le c)
\\\frac{c^c}{c!}{\rho}^nP_0 \quad (c\le n \le N)
\end{matrix}\right.\\
L_q = \frac{P_0\rho(c\rho)^c}{c!(1-\rho)^2}[1-{\rho}^{N-c}-(N-c){\rho}^{N-c}(1-\rho)] \\
L_s = L_q + c\rho(1-P_N)\\
W_q = \frac{L_q}{\lambda (1-P_N)} \\
W_s = W_q + \frac{1}{\mu}
$$


## 实验方法与步骤

​	使用MATLAB建立`M/M/c/N/∞排队系统的模型`

- 初始化

  获得问题的参数

  ```matlab
  labmda = input("lambda:");
  mu = input("mu:");
  c = input("c:");
  N = input("N:");
  ```
  
- 输出系统的各参数

  对应的`MATLAB`代码如下

  ```matlab
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
  ```
  

## 实验结果

> 某风景区准备建造旅馆，根据事先的调查知道，顾客到达该景区的规律服从泊松分布，平均有6人/d。在已知的小旅馆等处调查的结果显示顾客平均逗留2d。试讨论该拟建造的旅馆在有8个单间的条件下，每天客房的平均占用数以及满员的概率。

用上述例子执行`lab4.m`的结果如下

```matlab
>> lab4
lambda:6
mu:0.5
c:8
N:8
P0:0.000040
P1:0.000476
P2:0.002854
P3:0.011414
P4:0.034243
P5:0.082183
P6:0.164366
P7:0.281770
P8:0.422655
Lq:0.000000
Ls:6.928139
Wq:0.000000
Ws:2.000000
```
得到每天占用客房的平均数为6.928139、满员的概率为0.422655
