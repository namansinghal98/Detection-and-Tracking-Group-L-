function varc = gpt_variance( Intensity_location, cen, var )
%GPT_VARIANCE
%   This function calculates the variance of the centroid of the gaussian plume target.
%   It takes the intensities of pixels of the frame containing the target,
%   centroid of the target, variance of the noise introduced in the frame
%   as inputs and returns the variance of the centroid.

global aE;
global aN;
% Semiaxes aE, aN (footprint, assumed for simplicity
% oriented along the sensor’s coordinates).
global Sm;    % Sm = maximum intensity of the target

E = cen(1);
N = cen(2);
[m1, m2] = size(Intensity_location);
m = m1*m2;

%% For X cord
xsum1 = sum(meshgrid(-((m1+1)/2 - 1):((m1+1)/2 - 1)).*meshgrid(-((m1+1)/2 - 1):((m1+1)/2 - 1)));
xsum2 = sum(xsum1(:));

varcx = ((E*E*m*var + var*xsum2)/((Sm*2*pi*aE*aN*Sm*2*pi*aE*aN) + m*var)) + (1/(48*pi*aE*aN));    % calculating equation

%% For Y cord
ysum1 = sum((meshgrid(((m1+1)/2 - 1):-1:-((m1+1)/2 - 1))').*(meshgrid(((m1+1)/2 - 1):-1:-((m1+1)/2 - 1))'));
ysum2 = sum(ysum1(:));

varcy = ((N*N*m*var + var*ysum2)/((Sm*2*pi*aE*aN*Sm*2*pi*aE*aN) + m*var)) + (1/(48*pi*aE*aN));    % calculating equation

%% Centroid variance
varc = [varcx varcy];

end