function [ ] = target_stats( img_name, var)
%TARGET_STATS
%   This function calculates the centroid, variance of the centroid and
%   its contrast.
%   It Takes the name of the image and variance of noise.

img = imread(img_name);
img = double(img);

Centroid = centroid(img)

Centroid_Variance = gpt_variance(img, Centroid, var)

Contrast = gpt_contrast(img)

end