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
%req 4
t=linspace(0,100,1000);
% calculate the step response for X1 and X2
[Y_X1,t_X1]=step(X1_U,t);
[Y_X2,t_X2]=step(X2_U,t);
%get steady state values 
Steady_state_value_X1=Y_X1(end);
Steady_state_value_X2=Y_X2(end);
fprintf("steady state value for X1 %f \n",Steady_state_value_X1);
fprintf("steady state value for X2 %f \n",Steady_state_value_X2);
%end of req4

G1=tf(-1,K2);
G2=tf([M2,F2,K2+K3],1);
G3=tf(1,K2);
G4=tf([M1,F1,K1+K2],1);
sysCommon=series(G2,G3);
%system to X1
sys1=feedback(series(G1,sysCommon),G4);
%system to X2
sys2=feedback(G1,series(sysCommon,G4));
%req5
sys3=feedback(sys2,1);
X2_Xd=minreal(sys3);
%end of req5

%req6
[Y_X2_XD,t_X2_XD]=step(2*X2_Xd,t);
figure;
plot(t_X2_XD,Y_X2_XD)
%end of req6
%req7
stepinfo(X2_Xd);
%end of req7

%req 8
t_values=[1,10,100,1000];
for KP=t_values
    sys3=feedback(sys2,KP);
    X2_Xd=minreal(sys3);
    [Y_X2_XD,t_X2_XD]=step(2*X2_Xd,t);
    figure;
    plot(t_X2_XD,Y_X2_XD)
    stepinfo(X2_Xd)
    Steady_State_Error=Y_X2_XD(end)-2;
end

%end of Req 8
