function streak(file_path)
% This function generates an image which contains the trajecgtory of the target traversed. The trajectory specified by the user 
% while generating the images using img_gen function will be visualised by this function. The image genearted is segmented so 
% that the user can distinguish the taget path from the noise
%% Path Generation %%
global Sm;
fileFolder = fullfile(file_path);
dirOutput = dir(fullfile(fileFolder,'test_*.png'));
fileNames = {dirOutput.name}';
fileNames = natsort(fileNames);
num = numel(fileNames);

k = uint8(zeros(size(imread('test_0.png'))));

for i = 0:+1:num-1
    k = k + (imread(strcat('test_',int2str(i),'.png')));
end
k = k./uint8(num);
%% Seed Calculation for the mask %%
b = max(max(k));
b = find(k==b)
size_b = size(b);
size_k = size(k);
floor(size_b(1))
if(size_b==1)
    r = floor(b(1)/size_k(1));
    c = b(r+1) - r*size_k(1);
else
    r = floor(b(floor(size_b(1)/2))/size_k(1));
    c = b(floor(size_b(1)/2)) - r*size_k(1);
end
%% Mask Calculation and Segmentation %%
mask = false(size(k)); 
mask(r,c) = true;
W = graydiffweight(k, mask, 'GrayDifferenceCutoff', 25);
thresh = 0.01;
[BW, ~] = imsegfmm(W, mask, thresh);
figure
imshow(BW)
title('Segmented Image');
imwrite(mat2gray(k,[0 Sm]),'streak_with_noise.png');
imwrite(BW,'streak.png');
