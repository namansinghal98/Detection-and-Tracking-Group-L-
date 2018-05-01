function Cords = centroid( Intensity_location)
%CENTROID
%   This function calculates the centroid of the target.
%   It takes the intensities of pixels of the frame containing the target
%   and returns its location (Cordinates).

%% To convert image into a gray image.
[rows, columns, numberofColorChannels] = size(Intensity_location);
if numberofColorChannels > 1
Intensity_location = rgb2gray(Intensity_location);
end

Intensity_location = double(Intensity_location);    % typecasting uint8 to double
[m1, m2] = size(Intensity_location);

%% For X cordinate:
xtemp = Intensity_location.*(meshgrid(-((m1+1)/2 - 1):((m1+1)/2 - 1)));    % creating grid of X cordinates
xsum_num1 = sum(xtemp);
xsum_num2 = sum(xsum_num1(:));

xsum_deno1 = sum(Intensity_location);
xsum_deno2 = sum(xsum_deno1(:));

E = xsum_num2/xsum_deno2;

%% For y cordinate:
ytemp = Intensity_location.*(meshgrid(((m1+1)/2 - 1):-1:-((m1+1)/2 - 1))');    %creating grid of Y cordinate
ysum_num1 = sum(ytemp);
ysum_num2 = sum(ysum_num1(:));

ysum_deno1 = sum(Intensity_location);
ysum_deno2 = sum(ysum_deno1(:));

N = ysum_num2/ysum_deno2;

%% location of the target
Cords = [E N];

end
