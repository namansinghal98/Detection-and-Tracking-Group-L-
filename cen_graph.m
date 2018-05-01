function [ ] = cen_graph(var)
%CEN_GRAPH
%   This function calculates the centroid, variance in the centroid and contrast
%   of the target of all the images/frames (named as test_N where N is the nth image/frame)
%   present in the current directory .
%   It shows a graph of Centroid Vs Centroid Variance (for both X and Y coordinates) 
%   to compare and confirm parabolic nature of the centroid variance w.r.t its centroid.
%   It shows a graph between Centroid Vs Standard deviation (for both X and Y coordinates).
%   It also shows a graph of centroid of the target with variance of centroid plotted corresponding to each centroid.
%   It takes variance of the white noise introduced as input and returns above mentioned information for all images/frames.

global num_of_img;

%initialising matrices for futher modification
cenx = ones(1, num_of_img);
ceny = ones(1, num_of_img);
varcx = ones(1, num_of_img);
varcy = ones(1, num_of_img);
contrast = ones(1, num_of_img);
imgno = 1:num_of_img;

for i = 0:num_of_img-1
    img = imread(strcat('test_',int2str(i),'.png'));
    cen = centroid(img);
    varc = gpt_variance(img, cen, var);
    contrast(i+1) = gpt_contrast(img);
    cenx(i+1) = cen(1);
    ceny(i+1) = cen(2);
    varcx(i+1) = varc(1);
    varcy(i+1) = varc(2);
    disp(strcat("Information about ", "test_", int2str(i), ".png"));
    target_stats(strcat('test_', int2str(i), '.png'), var);
end

figure;
plot(cenx, sqrt(varcx));
ylabel('Standard deviation in X cord');
xlabel('X cord of centroid');
title('Centroid Vs Standard Deviation');

figure;
plot(cenx, sqrt(varcy));
ylabel('Standard deviation in Y cord');
xlabel('Y cord of centroid');
title('Centroid Vs Standard Deviation');

figure;
scatter(cenx, varcx, '*');
ylabel('Variance in X cord');
xlabel('X cord of centroid');
title('Centroid Vs Variance');

figure;
scatter(ceny, varcy, '*');
ylabel('Variance in Y cord');
xlabel('Y cord of centroid');
title('Centroid Vs Variance');

figure;
plot(imgno, contrast);
ylabel('Contrast of target w.r.t the frame');
xlabel('No. of frame');
title('Contrast Vs No. of frame');

figure;
scatter(cenx, ceny, '+');
hold on
plot(cenx, ceny);
hold on
for i = 0:num_of_img-1
    a = varcx(i+1); % horizontal radius
    b = varcy(i+1); % vertical radius
    x0 = cenx(i+1); % x0,y0 ellipse centre coordinates
    y0 = ceny(i+1);
    t = -pi:0.001:pi;
    x = x0 + a*cos(t);
    y = y0 + b*sin(t);
    plot(x,y);
    hold on
end
hold off
ylabel('Y cord of centroid');
xlabel('X cord of centroid');
title('Centroid of target');

end