function K = gpt_contrast_final( Intensity_location )
%GPT_CONTRAST 
%   This function calculates the contrast of the gaussian plume target.
%   It takes the intensities of pixels of the frame containing the target
%   and returns its contrast.

global aE;
global aN;
% Semiaxes aE, aN (footprint, assumed for simplicity
% oriented along the sensor’s coordinates).
global Sm;    % Sm = maximum intensity of the target

[m1, m2] = size(Intensity_location);
m = m1*m2;

K = Sm*Sm*pi*aE*aN*(1 - ((4*pi*aE*aN)/m));  % calculating equation

end