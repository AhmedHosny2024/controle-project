M1 = 100; M2 = 100; 
K1 = 5; K2 = 50; K3 = 5; 
F1 = 100; F2 = 100;

B1 = tf(1,1);
B2 = tf(K1,1);
B3 = tf([F1,0],1);
B4 = tf([M1,0,0],1);
B5 = tf(1,K2);
B6 = tf(K2,1);
B7 = tf(K2,1);
B8 = tf(K3,1);
B9 = tf([F2,0],1);
B10 = tf(1,[M2,0,0]);
B11 = tf(K2,1);
BlockMat=append(B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11);
connect_map = [2,5,0,0,0,0,0,0,0,0,0;...
    3,5,0,0,0,0,0,0,0,0,0;...
    4,5,0,0,0,0,0,0,0,0,0;...
    5,11,-4,-3,-2,1,0,0,0,0,0;...
    6,5,0,0,0,0,0,0,0,0,0;...
    7,10,0,0,0,0,0,0,0,0,0;...
    8,10,0,0,0,0,0,0,0,0,0;...
    9,10,0,0,0,0,0,0,0,0,0;...
    10,6,-7,-8,-9,0,0,0,0,0,0;...
    11,10,0,0,0,0,0,0,0,0,0;...
    ];
input_loc = 1;
output_loc=[5,10];
sys=connect(BlockMat,connect_map,input_loc,output_loc);
tran_func= tf(sys);
%display(tran_func);
p=stepplot(sys);

X1_U=tran_func(1);
X2_U=tran_func(2);
display(X1_U);
display(X2_U);

X1_U_Poles=pole(X1_U);
s=size(X1_U_Poles);
stable=true;
critical_stable=false;
for i = 1:s
    if(X1_U_Poles(i)>0)
        stable=false;
        break;
    end
    if(X1_U_Poles(i)==0)
        critical_stable=true;
    end
end
if(~stable)
    disp("the system is unstable ");
elseif (critical_stable)
    disp("the system is critical stabel ");
else
    disp("the system is stabel ");
end
disp("and the poles are ");
disp(X1_U_Poles);
disp(isstable(X1_U))



