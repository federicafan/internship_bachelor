clear variables
close all
clc

format long

s=tf('s');
Ts=1e-3;
G_p=load('transfer_function');
G1=G_p.G;
ZOH=1/(1+s*Ts*0.5);
G_ZOH=G1*ZOH;

%Steady-state
Kc=4.12;
Css=-Kc/s;
Lss=Css*G_ZOH;
figure(); bode(Lss), grid on;

%Transient
Tp=mag2db(1.38);
Sp=mag2db(1.65);
wc_des=120;
figure(); nichols(Lss,'k'); hold on; t_grid(Tp); s_grid(Sp);
%Lead network, real negative zero
wn=10; %wn=2.1
wz=wc_des/wn;
Cz=(1+s/wz);
C0=Css*Cz;
L1=C0*G_ZOH;
hold on; nichols(L1,'b');
md=18;
wn=6;
wd=wc_des/wn;
Cd=(1+s/wd)/(1+s/(md*wd));
C0_def=C0*Cd;
L2=C0_def*G_ZOH;
hold on; nichols(L2,'r');
%Polo di chiusura
wp=1500;
Cp=1/(1+s/wp);
C0=C0_def*Cp;
L3=C0*G_ZOH;
hold on; nichols(L3,'g');
%return
T=L2/(1+L2);
%figure; bode(T);
% %Discretizzazione
Cd=c2d(C0,Ts,'tustin')
%figure; bode(C0);

%Simulazione
%%Tracking error, step + transient + u(t)
r_s=1;
rho=1;
rho_ramp=0;
t_stop=0.4;
min_step=1e-5;
max_step=1e-4;
sim('Levitatore_lin');
figure();
plot(r.time,r.data,'r','Linewidth',1.5);
hold on;
plot(y.time,y.data,'b','Linewidth',1.5);
title('Step response'); xlabel('Time (s)'); ylabel ('r(t),y(t)'); legend('r(t)','y(t)'); grid on;
figure();
plot(u.time,u.data,'r','Linewidth',1.5); title('Control input'); xlabel('Time (s)'); ylabel('u(t)'); grid on;
figure();
plot(e.time,e.data,'r','Linewidth',1.5); hold on; plot(e.time,e.data,'bo','Linewidth',1.5); title('Tracking error with step reference'); xlabel('Time (s)'); ylabel('e(t)'); grid on;
legend('e(t)','e_s(t)');
%%Ramp Response
r_s=-1;
rho=0;
rho_ramp=1;
sim('Levitatore_lin');
figure();
plot(r.time,r.data,'r','Linewidth',1.5);
hold on;
plot(y.time,y.data,'b','Linewidth',1.5);
title('Ramp response'); xlabel('Time (s)'); ylabel('r(t),y(t)'); legend('r(t)','y(t)','Location','best'); grid on;



