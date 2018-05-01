%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The problem: Predict the position and velocity of a moving train
% having noisy measurements of its positions along the previous 10 seconds (10 samples a second). 

% Ground truth: The train is initially located at the point x = 0 and moves
% along the X axis with constant velocity V = 10m/sec, so the motion equation of the train is X =
% X0 + V*t. Easy to see that the position of the train after 12 seconds
% will be x = 120m, and this is what we will try to find.

% Approach: We measure (sample) the position of the train every dt = 0.1 seconds. But,
% because of imperfect apparature, weather etc., our measurements are
% noisy, so the instantaneous velocity, derived from 2 consecutive position
% measurements (remember, we measure only position) is innacurate. We will
% use Kalman filter as we need an accurate and smooth estimate for the velocity in
% order to predict train's position in the future.

% We assume that the measurement noise is normally distributed, with mean 0 and
% standard deviation SIGMA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

close all
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Ground truth %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set true trajectory 
Nsamples=100;
dt = .1;
t=0:dt:dt*Nsamples;
Vtrue = 10;

% Xtrue is a vector of true positions of the train 
Xinitial = 0;
Xtrue = Xinitial + Vtrue * t ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Motion equations %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Previous state (initial guess): Our guess is that the train starts at 0 with velocity
% that equals to 50% of the real velocity
Xk_prev = [10; 
    .5*Vtrue];

% Current state estimate
Xk=[];

% Motion equation: Xk = Phi*Xk_prev + Noise, that is Xk(n) = Xk(n-1) + Vk(n-1) * dt
% Of course, V is not measured, but it is estimated
% Phi represents the dynamics of the system: it is the motion equation
Phi = [1 dt ;
       0  1];

% The error matrix (or the confidence matrix): P states whether we should 
% give more weight to the new measurement or to the model estimate 
sigma_model = 5;
% P = sigma^2*G*G';
P = [sigma_model^2             0;
                 0 sigma_model^2];

% Q is the process noise covariance. It represents the amount of
% uncertainty in the model.
% The process noise, a scalar, which models the acceleration, is a zero-mean
% white sequence with variance qval
qval = 0.1;
Q = [qval 0;
     0 qval];

% M is the measurement matrix. 
% We measure X, so M(1) = 1
% We do not measure V, so M(2)= 0
M = [1 0];

% R is the measurement noise covariance. Generally R and sigma_meas can
% vary between samples. 
sigma_meas = 1; % 1 m/sec
R = sigma_meas^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Kalman iteration %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Buffers for later display
Xk_buffer = zeros(2,Nsamples+1);
Xk_buffer(:,1) = Xk_prev;
Z_buffer = zeros(1,Nsamples+1);
K_buffer = zeros(1,Nsamples);
L_buffer = zeros(1,Nsamples);

for k=1:Nsamples
    
    % Z is the measurement vector. In our
    % case, Z = TrueData + RandomGaussianNoise
    Z = Xtrue(k+1)+sigma_meas*randn;
    Z_buffer(k+1) = Z;
    
    % Kalman iteration
    P1 = Phi*P*Phi' + Q;
    S = M*P1*M' + R;
    
    % K is Kalman gain. If K is large, more weight goes to the measurement.
    % If K is low, more weight goes to the model prediction.
    K = P1*M'*inv(S);
    P = P1 - K*M*P1;
    
    
    K_buffer(k) = P(1);
    
    L_buffer(k) = P(2);
    
    Xk = Phi*Xk_prev + K*(Z-M*Phi*Xk_prev);
    Xk_buffer(:,k+1) = Xk;
    
    % For the next iteration
    Xk_prev = Xk; 
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
plot(t,Z_buffer,'c*');
plot(t,Xk_buffer(1,:),'m');
grid on;
title('Position estimation results');
xlabel('Time (s)');
ylabel('Position (m)');
legend('True position','Measurements','Kalman estimated displacement');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Error Position %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(t(1:Nsamples),2*K_buffer,'c');
hold on;
plot(t(1:Nsamples),-2.*K_buffer,'c');
plot(t,Xk_buffer(1,:)-Xtrue,'m*');
grid on;

title('Position Estimation Error Covariance');
xlabel('Time (s)');
ylabel('Position Estimation Error(m)');
legend('Px*2','Px*-2','Error In Position Estimation');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Velocity analysis %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The instantaneous velocity as derived from 2 consecutive position
% measurements
InstantaneousVelocity = [0 (Z_buffer(2:Nsamples+1)-Z_buffer(1:Nsamples))/dt];

% The instantaneous velocity as derived from running average with a window
% of 5 samples from instantaneous velocity
WindowSize = 5;
InstantaneousVelocityRunningAverage = filter(ones(1,WindowSize)/WindowSize,1,InstantaneousVelocity);

figure;
plot(t,ones(size(t))*Vtrue,'m');
hold on;
grid on;
plot(t,InstantaneousVelocity,'g');
plot(t,InstantaneousVelocityRunningAverage,'c');
plot(t,Xk_buffer(2,:),'k');
title('Velocity estimation results');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('True velocity','Calculated velocity of measurements','Estimated velocity by running average','Estimated velocity by Kalman filter');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     Error Velocity %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(t(1:Nsamples),2*L_buffer,'c');
hold on;
plot(t(1:Nsamples),-2.*L_buffer,'c');
plot(t,Xk_buffer(2,:)-Vtrue,'m*');
grid on;

title('Velocity Estimation Error Covariance');
xlabel('Time (s)');
ylabel('Velocity Estimation Error(m)');
legend('Pv*2','Pv*-2','Error In Velocity Estimation');
