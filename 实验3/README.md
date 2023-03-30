# 实验三  整数规划

## 整数规划模型的建立

​	设`x1`为在12:00到13:00休息的全时服务员人数，`x2`为在13:00到14:00休息的全时服务员人数，`x3-x7`分别为在9:00-13:00、10:00-14:00、11:00-15:00、12:00-16:00、13:00-17:00连续工作的半时服务员人数，xi均为大于等于0的整数

​	根据题目条件，`目标函数`为

$$
minz = 100(x1+x2)+40(x3+x4+x5+x6+x7)
$$

​	`约束条件`为

$$
\left\{\begin{matrix}
  x1&+x2&+x3&   &   &   &   &=&4 \\
  x1&+x2&+x3&+x4&   &   &   &=&3 \\
  x1&+x2&+x3&+x4&+x5&   &   &=&4 \\
    &+x2&+x3&+x4&+x5&+x6&&=&6 \\
  x1&   &   &+x4&+x5&+x6&+x7&=&5 \\
  x1&+x2&   &   &+x5&+x6&+x7&=&6 \\
  x1&+x2&   &   &   &+x6&+x7&=&8 \\
  x1&+x2&   &   &   &   &+x7&=&8 \\
   &  &x3&+x4&+x5&+x6&+x7&<=&3 \\
\end{matrix}\right.
$$


## 实验方法与步骤

​	使用MATLAB建立`求解整数规划的模型`

- 初始化

  `f`为目标函数系数，`intcon`限制为整数的变量序号，`A`为约束Ax<=b中的A，`b`为约束Ax<=b中的b，`Aeq`为约束Aeqx=beq中的Aeq，`beq`为约束Aeqx=beq中的beq，`lb`为x的下限，`ub`为x的上限

  ```matlab
  f=[100 100 40 40 40 40 40];
  intcon=1:7;
  A=[ -1 -1 -1  0  0  0  0;
      -1 -1 -1 -1  0  0  0;
      -1 -1 -1 -1 -1  0  0;
       0 -1 -1 -1 -1 -1  0;
      -1  0  0 -1 -1 -1 -1;
      -1 -1  0  0 -1 -1 -1;
      -1 -1  0  0  0 -1 -1;
      -1 -1  0  0  0  0 -1;
       0  0  1  1  1  1  1
      ];
  =[-4 -3 -4 -6 -5 -6 -8 -8 3];
  Aeq=[];
  beq=[];
  lb=zeros(7,1);
  ub=[];
  ```

- 调用`intlinprog`函数求解

  对应的`MATLAB`代码如下

  ```matlab
  [x, fval] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
  ```

  `x`为方程的最优整数解，`fval`为最小目标函数值

## 实验结果

执行`lab3.m`的结果如下

```matlab
>> lab3
LP:                Optimal objective value is 770.000000.                                           

Cut Generation:    Applied 1 zero-half cut.                                                         
                   Lower bound is 820.000000.                                                       
                   Relative gap is 0.00%.                                                          


Optimal solution found.

Intlinprog stopped at the root node because the objective value is within a gap tolerance of the optimal value,
options.AbsoluteGapTolerance = 0 (the default value). The intcon variables are integer within tolerance,
options.IntegerTolerance = 1e-05 (the default value).

最优整数解:

x =

     3
     4
     0
     0
     2
     0
     1

最小目标函数值:

fval =

   820

```
输出结果为`最优整数解`各变量的值，需要3名在12:00到13:00休息的全时服务员，4名在13:00到14:00休息的全时服务员，2名在11:00到15:00连续工作的半时服务员，1名在13:00到17:00连续工作的半时服务员

`预期的最小总开支`为 $100*(3+4)+40*(2+1)=820$ 元
