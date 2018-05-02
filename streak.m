function streak(file_path)
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
imwrite(mat2gray(k,[0 Sm]),'streak.png');