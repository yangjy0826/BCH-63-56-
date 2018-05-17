%------------------encoder----------------------------------------
m=[1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0 1]; %�ɸ���32 bit message code; Ϊʲôֻ����32λ���ǲ��ǿ���ֱ������56λ��Ϣλ
a=[0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1];                 %padding altering zeros and ones (24 bits) at the begining
In=[a,m];  %InΪ56λ������Ϣλ
disp('56λ��ϢλΪ��');
disp(In);
x=zeros(1,7); %x(7)=0����;
xp=zeros(1,7); %xp(7)=0����;
for i=1:56    %�����·
    x(7)=xor(xp(1),In(i)); %x(1)����ߵĵ�һλ
    x(6)=xp(7);
    x(5)=xor(xp(6),x(7));
    x(4)=xp(5);
    x(3)=xp(4);
    x(2)=xp(3);
    x(1)=xor(xp(2),x(7));
    xp=x;
end
disp(x);   
C=[In,x];  %�������Ϣλ��У��λ
%-------------------�ŵ�����������-------------------------------
ne= input('������������:'); %����������
if ne>0  %��������
  e=input('������ɴ��������롰0���������������λ�������롰1��:');
      if e==0 %�������ne����
      disp('�������Ĵ���λ��Ϊ��');
      k=unidrnd(63,1,ne); %����1��ne�ֱ������ɵľ���R����63������������ɣ���������������
      disp(k);
      end
      if e==1   %�ֶ�����ne����
         for j=1:ne
         k(j)=input(['����������ĵ�',num2str(j),'������λ�ã�']);
         end
      end
end  
   R=C;    %R��ʾ��������63λ
      for j=1:ne
         if R(k(j))==0;
            R(k(j))=1;
         else
            R(k(j))=0;
         end
      end    
if ne==0
  R=C;
  disp('δ�������');
end
 disp(R);
 %---------------------decoder-----------------------------------
y=zeros(1,7); %y(7)=0;
yp=zeros(1,7); %yp(7)=0;
 for i=1:63    %������ʽ
    y(7)=xor(yp(1),R(i));
    y(6)=yp(7);
    y(5)=xor(yp(6),yp(1));
    y(4)=yp(5);
    y(3)=yp(4);
    y(2)=yp(3);
    y(1)=xor(yp(2),yp(1));
    yp=y;
 end
 disp('���������ʽΪ��');
 disp(y);
 
 %%����Ϊ�·�����һ���ĵط�
 s1(1)=y(2); %����s1��alfa^6=alfa^2+1
 s1(2)=y(3);
 s1(3)=y(4);
 s1(4)=y(5);
 s1(5)=xor(y(1),y(6));
 s1(6)=xor(y(1),y(7));
 disp('�����s1Ϊ��');
 disp(s1);
 s1_d=s1(1)*32+s1(2)*16+s1(3)*8+s1(4)*4+s1(5)*2+s1(6);%����Ϊʮ����
 disp(s1_d);
 
 s2(1)=s1(1); %����s2
 s2(2)=xor(s1(1),s1(4));
 s2(3)=s1(2);
 s2(4)=xor(s1(2),s1(5));
 s2(5)=s1(3);
 s2(6)=xor(s1(3),s1(6));
 disp('�����s2Ϊ��');
 disp(s2);
 s2_d=s2(1)*32+s2(2)*16+s2(3)*8+s2(4)*4+s2(5)*2+s2(6);%����Ϊʮ����
 disp(s2_d);
 
 y_eoro=y(1)+y(2)+y(3)+y(4)+y(5)+y(6)+y(7);
 %�жϰ���ʽy����ż
 if mod(y_eoro,2) == 0
 %number is even
 odd_even=0;%��żУ��ֵΪ0
 end
 if mod(y_eoro,2) == 1
 %number is odd
 odd_even=1;%��żУ��ֵΪ1
 end
 
 if (s1==0) 
    disp('û�з�������');
 end
 
 if(s1_d>0) %�д�
  %BCH��������У���Ҫ�����Ľ���GF��alfa^6������Ԫ�ص����㣬����Ӳ���������У���Ԫ����Ҫͨ�������ұ�������ʵ��
  
 [s]=xlsread('lut',1,'G2:G65'); %ȫ���ĵ�ֵַ
 [p]=xlsread('lut',1,'A2:F65');%ȫ���Ķ�����ֵ
 
 if odd_even==1 %��1λ
 for i=1:64
     if s(i)==s1_d;
         break;
     end
 end
 p1=p(i,:);
 disp('�������ֵַp1Ϊ��');
 p1_d=p1(1)*32+p1(2)*16+p1(3)*8+p1(4)*4+p1(5)*2+p1(6);
 disp(p1_d);
 
  for j=1:64
     if s(j)==s2_d;
         break;
     end
 end
 p2=p(j,:);
 disp('�������ֵַp2Ϊ��');
 p2_d=p2(1)*32+p2(2)*16+p2(3)*8+p2(4)*4+p2(5)*2+p2(6);
 disp(p2_d);
 if(p1_d>p2_d)
     p=p1_d-p2_d;%��verilog�᲻һ��
%      p=63+(p1_d-p2_d);
 end
 if(p1_d<=p2_d)
%      p=p1_d-p2_d;
     p=63+(p1_d-p2_d);
 end
 disp(['�������ڵ�',num2str(p),'λ']);
 Rn=R;  %�������λRn����������о���
 if Rn(p)==0;
    Rn(p)=1;
 else
    Rn(p)=0;
 end
 disp('���������Ϣλ+У��λΪ');
 disp(Rn);
 end   %���ڴ���λ���ܼ��
 
 if odd_even==0
     disp('�޷���������')
 end
 end