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
 w=0;
 for i=1:7 %计算伴随式的汉明重量
  if y(i)==1
     w=w+1;
  end
 end
 disp(['伴随式的汉明重量为',num2str(w)]);
 el=0; %el--error location 定义为0
if w==0 
    disp('没有发生错误');
end
if w>0 %发生错误时，分为错误发生在信息位还是校验位2种情况
  if w==1 %错误发生在7位校验位
      n=0;
      for i=1:7
          if y(i)==0
          n=n+1;
          end
          if y(i)==1
          break;
          end
      end 
     n=n+1;  %伴随式的第n位为1，也就是校验位的第n位出现错误，即整个序列R的第n+56位出现错误
     el=n+56; %el为错误位置
     Rn=R;  %设纠正后位Rn，将错误进行纠正
     if Rn(el)==0;
        Rn(el)=1;
     else
        Rn(el)=0;
     end
     disp(['错误发生在第',num2str(el),'位']);
     disp('纠正后的信息位+校验位为');
     disp(Rn);
   end  
 if w>1; %汉明重量大于1，说明错误发生在56位信息位，搜索查找表
    [S]=xlsread('lookuptable',1,'C2:I57'); %全部的伴随式
    [EPA]=xlsread('lookuptable',1,'J2:BM57');%全部的错误图样
    
    %在15b和13a的matlab版本上都尝试了xlsread的函数使用，15b根本不能使用，
    %需要去掉Excel中的COM加载项，13a的最多可以读取两个.xls的文件。
    %COM加载项的去除方法（我的Excel是10破解版），用Excel打开.csv的文件，
    %点击左上角的文件-选项-加载项，就可以看到活动段应用程序加载项，
    %然后再页面左下角管理-COM加载项-转到，然后那几项对勾点掉就可以了
    
    for i=1:56
        if S(i,:)==y;
            break;
        end
    end
    if (i==56 && isequal(S(56,:),y)==0) %i=56且错误不是发生在第56位，说明查找表中没有此伴随式y
        disp('BCH(63,56)码无法纠正此错误')
    else
     [EP]=EPA(i,:);
     disp('错误图样为');
     disp(EP);
     %由错误图样得到错误位置
     el=0;
     for k=1:56
         if EP(k)==0;
             el=el+1;
         end
         if EP(k)==1;
             break;
         end    
     end
     el=el+1; %el为错误位置
     Rn=R;  %设纠正后位Rn，将错误进行纠正
     if Rn(el)==0;
        Rn(el)=1;
     else
        Rn(el)=0;
     end
     disp(['错误发生在第',num2str(el),'位']);
     disp('纠正后的信息位+校验位为');
     disp(Rn);
    end
 end   
end
%当错误为三位，分别为第1,2,3位出错时，伴随式与只有第四十位出错的情况相同。是不是证明63,56码只能检测两位错误？