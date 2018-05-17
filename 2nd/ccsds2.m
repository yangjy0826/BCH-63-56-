%------------------encoder----------------------------------------
m=[1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1]; %可更换32 bit message code; 为什么只输入32位？是不是可以直接输入56位信息位
a=[0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];                 %padding altering zeros and ones (24 bits) at the begining
In=[a,m];  %In为56位输入信息位
disp('56位信息位为：');
disp(In);
x=zeros(1,7); %x(7)=0错误;
xp=zeros(1,7); %xp(7)=0错误;
for i=1:56    %编码电路
    x(7)=xor(xp(1),In(i)); %x(1)是左边的第一位
    x(6)=xp(7);
    x(5)=xor(xp(6),x(7));
    x(4)=xp(5);
    x(3)=xp(4);
    x(2)=xp(3);
    x(1)=xor(xp(2),x(7));
    xp=x;
end
disp(x);   
C=[In,x];  %编码后信息位＋校验位
%-------------------信道，产生错误-------------------------------
ne= input('请输入错误个数:'); %输入错误个数
if ne>0  %发生错误
  e=input('随机生成错误请输入“0”，自主定义错误位置请输入“1”:');
      if e==0 %随机生成ne个错
      disp('随机引入的错误位置为：');
      k=unidrnd(63,1,ne); %这里1和ne分别是生成的矩阵R（由63以下正整数组成）的行数和列数。
      disp(k);
      end
      if e==1   %手动输入ne个错
         for j=1:ne
         k(j)=input(['请输入引入的第',num2str(j),'个错误位置：']);
         end
      end
end  
   R=C;    %R表示引入错误后，63位
      for j=1:ne
         if R(k(j))==0;
            R(k(j))=1;
         else
            R(k(j))=0;
         end
      end    
if ne==0
  R=C;
  disp('未引入错误');
end
 disp(R);
 %---------------------decoder-----------------------------------
y=zeros(1,7); %y(7)=0;
yp=zeros(1,7); %yp(7)=0;
 for i=1:63    %求解伴随式
    y(7)=xor(yp(1),R(i));
    y(6)=yp(7);
    y(5)=xor(yp(6),yp(1));
    y(4)=yp(5);
    y(3)=yp(4);
    y(2)=yp(3);
    y(1)=xor(yp(2),yp(1));
    yp=y;
 end
 disp('计算出伴随式为：');
 disp(y);
 
 %%以下为新方法不一样的地方
 s1(1)=y(2); %计算s1，alfa^6=alfa^2+1
 s1(2)=y(3);
 s1(3)=y(4);
 s1(4)=y(5);
 s1(5)=xor(y(1),y(6));
 s1(6)=xor(y(1),y(7));
 disp('计算出s1为：');
 disp(s1);
 s1_d=s1(1)*32+s1(2)*16+s1(3)*8+s1(4)*4+s1(5)*2+s1(6);%换算为十进制
 disp(s1_d);
 
 s2(1)=s1(1); %计算s2
 s2(2)=xor(s1(1),s1(4));
 s2(3)=s1(2);
 s2(4)=xor(s1(2),s1(5));
 s2(5)=s1(3);
 s2(6)=xor(s1(3),s1(6));
 disp('计算出s2为：');
 disp(s2);
 s2_d=s2(1)*32+s2(2)*16+s2(3)*8+s2(4)*4+s2(5)*2+s2(6);%换算为十进制
 disp(s2_d);
 
 y_eoro=y(1)+y(2)+y(3)+y(4)+y(5)+y(6)+y(7);
 %判断伴随式y的奇偶
 if mod(y_eoro,2) == 0
 %number is even
 odd_even=0;%奇偶校验值为0
 end
 if mod(y_eoro,2) == 1
 %number is odd
 odd_even=1;%奇偶校验值为1
 end
 
 if (s1==0) 
    disp('没有发生错误');
 end
 
 if(s1_d>0) %有错
  %BCH译码过程中，需要大量的进行GF（alfa^6）上域元素的运算，在软硬件编译码中，域元素主要通过“查找表”法来实现
  
 [s]=xlsread('lut',1,'G2:G65'); %全部的地址值
 [p]=xlsread('lut',1,'A2:F65');%全部的二进制值
 
 if odd_even==1 %错1位
 for i=1:64
     if s(i)==s1_d;
         break;
     end
 end
 p1=p(i,:);
 disp('经查表地址值p1为：');
 p1_d=p1(1)*32+p1(2)*16+p1(3)*8+p1(4)*4+p1(5)*2+p1(6);
 disp(p1_d);
 
  for j=1:64
     if s(j)==s2_d;
         break;
     end
 end
 p2=p(j,:);
 disp('经查表地址值p2为：');
 p2_d=p2(1)*32+p2(2)*16+p2(3)*8+p2(4)*4+p2(5)*2+p2(6);
 disp(p2_d);
 if(p1_d>p2_d)
     p=p1_d-p2_d;%和verilog会不一样
%      p=63+(p1_d-p2_d);
 end
 if(p1_d<=p2_d)
%      p=p1_d-p2_d;
     p=63+(p1_d-p2_d);
 end
 disp(['错误发生在第',num2str(p),'位']);
 Rn=R;  %设纠正后位Rn，将错误进行纠正
 if Rn(p)==0;
    Rn(p)=1;
 else
    Rn(p)=0;
 end
 disp('纠正后的信息位+校验位为');
 disp(Rn);
 end   %现在错两位不能检错
 
 if odd_even==0
     disp('无法纠正错误')
 end
 end