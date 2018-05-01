close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ground truth %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set true trajectory 

Xinitial = -5;
Yinitial = -10;
VXtrue = 0.5;
VYtrue = 0.5;
Nsamples=50;
dt=1;
t=0:dt:dt*Nsamples;

% Xtrue and Ytrue is vector of true positions 
Xtrue = Xinitial + VXtrue * t ;
Ytrue = Yinitial + VYtrue * t ;

% Create Images
a_x=4;
a_y=4;
framesize= 100;
img_gen([Xinitial,Yinitial], [Xtrue(Nsamples),Ytrue(Nsamples)], a_x, a_y, sqrt(VXtrue^2 + VYtrue^2), framesize);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Motion equations %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Previous state (initial guess): Our guess is that the train starts at 0 with velocity
% that equals to 50% of the real velocity
Xk_prev = [Xinitial; 
    .5*VXtrue];

Yk_prev = [Yinitial; 
    .5*VYtrue];

% Current state estimate
Xk=[];
Yk=[];

% Motion equation: Xk = Phi*Xk_prev + Noise, that is Xk(n) = Xk(n-1) + Vk(n-1) * dt
% Of course, V is not measured, but it is estimated
% Phi represents the dynamics of the system: it is the motion equation
Phi = [1 dt ;
       0  1];

% The error matrix (or the confidence matrix): P states whether we should 
% give more weight to the new measurement or to the model estimate 
sigma_model = 1;
% P = sigma^2*G*G';
Px = [sigma_model^2             0;
                 0 sigma_model^2];
Py = [sigma_model^2             0;
                 0 sigma_model^2];

% Q is the process noise covariance. It represents the amount of
% uncertainty in the model. In our case, we arbitrarily assume that the model is perfect (no
% acceleration allowed for the train, or in other words - any acceleration is considered to be a noise)
qval = 0.01;
Q = [qval 0;
     0 qval];

% M is the measurement matrix. 
% We measure X, so M(1) = 1
% We do not measure V, so M(2)= 0
M = [1 0];

% R is the measurement noise covariance. Generally R and sigma_meas can
% vary between samples. 
sigma_meas = 3; 
R = sigma_meas^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kalman iteration %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Buffers for later display
Xk_buffer = zeros(2,Nsamples+1);
Xk_buffer(:,1) = Xk_prev;
Yk_buffer = zeros(2,Nsamples+1);
Yk_buffer(:,1) = Yk_prev;
Z_buffer = zeros(2,Nsamples+1);
XEp_buffer = zeros(1,Nsamples);
YEp_buffer = zeros(1,Nsamples);
XEv_buffer = zeros(1,Nsamples);
YEv_buffer = zeros(1,Nsamples);

for k=1:Nsamples
    
    % Z is the measurement vector. In our
    % case, Z = TrueData + RandomGaussianNoise
    Z = centroid_final( imread(strcat('test_',int2str(k-1),'.png')));
    Z(2)=Z(2)*-1;
    Z_buffer(:,k+1) = Z;
    
    
    % Kalman iteration
    P1x = Phi*Px*Phi' + Q;
    Sx = M*P1x*M' + R;
    
    P1y = Phi*Py*Phi' + Q;
    Sy = M*P1y*M' + R;
    
    
    % K is Kalman gain. If K is large, more weight goes to the measurement.
    % If K is low, more weight goes to the model prediction.
    Kx = P1x*M'*inv(Sx);
    Px = P1x - Kx*M*P1x;
    
    Xk = Phi*Xk_prev + Kx*(Z(1)-M*Phi*Xk_prev);
    Xk_buffer(:,k+1) = Xk;    
    
    Ky = P1y*M'*inv(Sy);
    Py = P1y - Ky*M*P1y;
    
    Yk = Phi*Yk_prev + Ky*(Z(2)-M*Phi*Yk_prev);
    Yk_buffer(:,k+1) = Yk;    
    
    % For the next iteration
    Yk_prev = Yk; 
    Xk_prev = Xk; 
    
   XEp_buffer(k) = Px(1);
   YEp_buffer(k) = Py(1);
   XEv_buffer(k) = Px(2);
   YEv_buffer(k) = Py(2);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot resulting graphs %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Position analysis %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(t,Xtrue,'g');
hold on;
grid on;
plot(t,Z_buffer(1,:),'c*');
plot(t,Xk_buffer(1,:),'m');
title('Position estimation results X axis');
xlabel('Time(s)');
ylabel('Position-X (m)');
legend('True position','Measurements','Kalman estimated displacement');


figure;
plot(t,Ytrue,'g');
hold on;
plot(t,Z_buffer(2,:),'c*');
plot(t,Yk_buffer(1,:),'m');
grid on;
title('Position estimation results Y axis');
xlabel('Time(s)');
ylabel('Position-Y (m)');
legend('True position','Measurements','Kalman estimated displacement');


figure;
plot(Xtrue,Ytrue,'g');
hold on;
grid on;
plot(Z_buffer(1,:),Z_buffer(2,:),'c*');
plot(Xk_buffer(1,:),Yk_buffer(1,:),'m');
title('Position estimation results');
xlabel('Position-X (m)');
ylabel('Position-Y (m)');
legend('True position','Measurements','Kalman estimated Position');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Position Error %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(t(1:Nsamples),2*XEp_buffer,'c');
hold on;
grid on;
plot(t(1:Nsamples),-2.*XEp_buffer,'c');
plot(t,Xk_buffer(1,:)-Z_buffer(1,:),'m*');

title('X-Position Estimation Error Covariance');
xlabel('Time (s)');
ylabel('X-Position Estimation Error(m)');
legend('Px(1)*2','Px(1)*-2','Error In Position Estimation');

figure;
plot(t(1:Nsamples),2*YEp_buffer,'c');
hold on;
grid on;
plot(t(1:Nsamples),-2.*YEp_buffer,'c');
plot(t,Yk_buffer(1,:)-Z_buffer(2,:),'m*');

title('Y-Position Estimation Error Covariance');
xlabel('Time (s)');
ylabel('Y-Position Estimation Error(m)');
legend('Py(1)*2','Py(1)*-2','Error In Position Estimation');

figure;
plot(t(1:Nsamples),2*XEv_buffer,'c');
hold on;
grid on;
plot(t(1:Nsamples),-2.*XEv_buffer,'c');
plot(t,Xk_buffer(2,:)-VXtrue,'m*');

title('X-Velocity Estimation Error Covariance');
xlabel('Time (s)');
ylabel('X-Velocity Estimation Error(m)');
legend('Px(2)*2','Px(2)*-2','Error In Position Estimation');


figure;
plot(t(1:Nsamples),2*YEv_buffer,'c');
hold on;
grid on;
plot(t(1:Nsamples),-2.*YEv_buffer,'c');
plot(t,Yk_buffer(2,:)-VYtrue,'m*');

title('Y-Velocity Estimation Error Covariance');
xlabel('Time (s)');
ylabel('Y-Velocity Estimation Error(m)');
legend('Py(2)*2','Py(2)*-2','Error In Position Estimation');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Velocity analysis %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The instantaneous velocity as derived from 2 consecutive position
% measurements
XInstantaneousVelocity = [0 (Z_buffer(1,2:Nsamples+1)-Z_buffer(1,1:Nsamples))/dt];
YInstantaneousVelocity = [0 (Z_buffer(2,2:Nsamples+1)-Z_buffer(2,1:Nsamples))/dt];

% The instantaneous velocity as derived from running average with a window
% of 5 samples from instantaneous velocity
WindowSize = 5;
XInstantaneousVelocityRunningAverage = filter(ones(1,WindowSize)/WindowSize,1,XInstantaneousVelocity);
YInstantaneousVelocityRunningAverage = filter(ones(1,WindowSize)/WindowSize,1,YInstantaneousVelocity);

figure;
plot(t,ones(size(t))*VXtrue,'m');
hold on;
grid on;
plot(t,XInstantaneousVelocity,'g');
plot(t,XInstantaneousVelocityRunningAverage,'c');
plot(t,Xk_buffer(2,:),'k');
title('Velocity estimation results X axis');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('True velocity','Calculated velocity of measurements','Estimated velocity by running average','Estimated velocity by Kalman filter');


figure;
plot(t,ones(size(t))*VYtrue,'m');
hold on;
grid on;
plot(t,YInstantaneousVelocity,'g');
plot(t,YInstantaneousVelocityRunningAverage,'c');
plot(t,Yk_buffer(2,:),'k');
title('Velocity estimation results Y axis');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('True velocity','Calculated velocity of measurements','Estimated velocity by running average','Estimated velocity by Kalman filter');

