close all
clear

% ========================================================================
fprintf(" =========================== Req 2 ===========================\n");
M1 = 100;
M2 = 100;
K1 = 5;
K2 = 50;
K3 = 5;
F1 = 100;
F2 = 100;

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
BlockMat = append(B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11);
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
output_loc = [5,10];
sys=connect(BlockMat,connect_map,input_loc,output_loc);
tran_func = tf(sys);

p = stepplot(sys);
title("Response of the system for the step function");

X1_U = tran_func(1);
X2_U = tran_func(2);
display(X1_U);
display(X2_U);

% ========================================================================
fprintf(" =========================== Req 3 ===========================\n");
pzmap(X1_U)

X1_U_Poles = pole(X1_U);

if(isstable(X1_U))
    disp("the system is stabel ");
else
    disp("the system is unstable ");
end

disp("\nThe poles are ");
disp(X1_U_Poles);

% ========================================================================
fprintf(" =========================== Req 4 ===========================\n");
t = linspace(0,100,1000);
% Calculate the step response for X1 and X2
[Y_X1,t_X1] = step(X1_U, t);
[Y_X2,t_X2] = step(X2_U, t);
% Get steady state values 
Steady_state_value_X1 = Y_X1(end);
Steady_state_value_X2 = Y_X2(end);
fprintf("\nsteady state value for X1 %f \n", Steady_state_value_X1);
fprintf("steady state value for X2 %f \n", Steady_state_value_X2);

% ========================================================================
fprintf(" =========================== Req 5 ===========================\n");
G1 = tf(-1,K2);
G2 = tf([M2,F2,K2+K3],1);
G3 = tf(1,K2);
G4 = tf([M1,F1,K1+K2],1);
sysCommon = series(G2,G3);
sys1 = feedback(series(G1,sysCommon),G4);
sys2 = feedback(G1,series(sysCommon,G4));

sys3 = feedback(sys2,1);
X2_Xd = minreal(sys3);

% ========================================================================
fprintf(" =========================== Req 6 ===========================\n");
[Y_X2_XD,t_X2_XD] = step(2*X2_Xd,t);
figure;
plot(t_X2_XD,Y_X2_XD)
title("Response of X2");
xlabel("Time (S)");
ylabel("Y X_2 X_D");

% ========================================================================
fprintf(" =========================== Req 7 ==========================\n");
stepinfo(X2_Xd)

% ========================================================================
fprintf(" =========================== Req 8 ===========================\n");
t_values = [1,10,100,1000];
for KP = t_values
    sys3 = feedback(sys2*KP, 1); % Changed
    X2_Xd = minreal(sys3);
    [Y_X2_XD,t_X2_XD] = step(2*X2_Xd,t);
    figure;
    plot(t_X2_XD,Y_X2_XD)
    title(strcat("Kp = ",num2str(KP)))
    xlabel('Time (s)')
    ylabel('Displacement (m)')
    fprintf("\n");
    stepinfo(X2_Xd)
    Steady_State_Error = Y_X2_XD(end)-2;
end

% ========================================================================
fprintf(" =========================== Req 9 ===========================\n");
ref = 4;
Kp = 0;
e_ss = 1;
stbl = true;
while e_ss > 0.01
    Kp = Kp + 0.1;
    sys_prop = tf(Kp);
    sys_closed_loop = feedback(Kp*sys2, 1);
    stbl = isstable(sys_closed_loop);
    if ~stbl
        break;
    end
    [y,t] = step(ref*sys_closed_loop, 0:0.1:8000);
    yss = mean(y(end-10/0.1:end));
%     Over check to get more accurate point representing the yss
%     Y_MAX_INDICEIS = find_local_maxima_indices(y);
%     if(isempty(Y_MAX_INDICEIS))
%        yss = y(end);
%     else
%         yss = (y(Y_MAX_INDICEIS(end))+y(Y_MAX_INDICEIS(end-1)))/2;
%     end
     e_ss = abs(ref - yss);
end

figure;
plot(t(1:600), y(1:600))
title(strcat("Kp = ",num2str(Kp)))
xlabel('Time (s)')
ylabel('Displacement (m)')
fprintf("\n");
disp(['The error constant Kp for a steady-state error of less than 0.01 is ', num2str(Kp)])
fprintf("\nEss = %f\n", e_ss);

sys_closed_loop_Poles = pole(sys_closed_loop);

if(isstable(sys_closed_loop))
    disp("The system is stable ");
else
    disp("The system is unstable ");
end

disp("\nThe poles are: ");
disp(sys_closed_loop_Poles);

% ========================================================================
fprintf(" ========================== Req 10 ==========================\n");
Kp = 100;
Ki = 5;
sys_pi = tf([Kp Ki], [1 0]);
sys_closed_loop = feedback(sys_pi*sys2, 1);
[y,t] = step(4*sys_closed_loop, 0:0.1:1000);
figure;
plot(t, y)
title('Step response of the system with PI controller')
xlabel('Time (s)')
ylabel('Displacement (m)')

e_ss = abs(ref - y(end));
fprintf("\nEss = %f\n", e_ss);

sys_closed_loop_Poles = pole(sys_closed_loop);

if(isstable(sys_closed_loop))
    disp("The system is stable ");
else
    disp("The system is unstable ");
end

disp("\nThe poles are ");
disp(sys_closed_loop_Poles);
disp(isstable(sys_closed_loop))