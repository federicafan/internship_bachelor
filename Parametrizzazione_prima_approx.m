clear variables
close all
clc

m=0.022; % kg
g=9.81;
z0=0.06; %Utilizzando la scala graduata
z0_ref=0.02; %Rispetto all'origine del sistema di riferimento
Im0=0.6596;
Kc=2.5;
K_trans=1/Kc;
Var=load('V_transducer_correct.mat');
Var.Position1=(Var.Position1-4)*0.01; %Posizione da cm a m
figure();
plot(Var.Position1,Var.Voltage1,'r.-','Linewidth',1.1);
grid on;
xlabel('Posizione (m)');
ylabel('Tensione (V)');
axis([0.00 0.065 -10 10]);
title('Caratteristica del trasduttore di posizione');
V_trasd=(Var.Voltage1(31)-Var.Voltage1(21))/0.01 %#ok<*NOPTS>

Eln=load('Elettromagnete_1.mat');
z=interp1(Var.Voltage1(11:44),Var.Position1(11:44),Eln.Km_dati(:,1));
figure();
plot(Eln.Km_dati(:,2),z,'r','Linewidth',1.5); grid on;
xlabel('Corrente (A)');
ylabel('Posizione (m)');
title('Caratteristica Posizione-Corrente per determinare Km');
Km=((Eln.Km_dati(:,2)).^2./((z).^2))\(m*g*(ones(26,1)))

%Derivazione della funzione di trasferimento - modello di prima
%approssimazione
Im0_calc=z0_ref*sqrt(m*g/Km);
A=[0 1;((2*g)/(Im0))*sqrt(m*g/Km) 0];
B=[0;-2*g*K_trans/Im0];
C=[V_trasd 0];
D=0;
sys=ss(A,B,C,D);
G=tf(sys)