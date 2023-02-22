function [theta_next,dtheta_next] = DoublePendulum(theta,dtheta,app_torque,dt)
%Written by Cameron LaMack 1/25/2022
%Inputs
%   theta ------- 1x2 current joint positions (rad)
%   dtheta ------- 1x2 current joint velocities (rad/s)
%   app_torque ------- 1x2 applied joint torques (Nm)
%   dt ------- scalar time step (seconds) NOTE: I use Euler integration,
%                                               so using a dt <0.01 is 
%                                               good practice
%Outputs
%   theta_next ------- 1x2 joint positions (rad) AFTER dt time 
%   dtheta_next ------- 1x2 current joint velocities (rad/s) AFTER dt time 
%   tot_torque ------- 1x2 total joint torques (Nm) at current theta (NOT
%                       AFTER dt)



m1=4; %kg
l1=0.4; %meters
r1=0.2; %meters

m2=6; %kg
l2=0.4; %meters
r2=0.2; %meters

I1=(m1*l1^2)/12;
I2=(m2*l2^2)/12;

g=9.81;

qddot = compute_accel(I1,I2,theta(1),theta(2),dtheta(1),dtheta(2),app_torque(1),app_torque(2),g,l1,m1,m2,r1,r2);
    
q1dot=dtheta(1)+qddot(1)*dt;
q1=theta(1)+dtheta(1)*dt;
    
q2dot=dtheta(2)+qddot(2)*dt;
q2=theta(2)+dtheta(2)*dt;

theta_next = [q1,q2]; 
dtheta_next = [q1dot,q2dot];

end