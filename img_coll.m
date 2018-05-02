function img_coll(file_path)
%Montage of images
%This function uses the absolute file path of the folder in which the files are located to create a rectangular montage of all the images 
%of the target generated using the img_gen function. The montage will contain 10 pictures in each row, so as to ensure that the collage
%doesn't reduce to a small size.
fileFolder = fullfile(file_path);
dirOutput = dir(fullfile(fileFolder,'test_*.png')); %All the png files starting with 'test_' are taken in to create a matrix of the filenames
fileNames = {dirOutput.name}';
fileNames = natsort(fileNames); %The natsort function is used to sort the filenames of the images the natural order.
num = numel(fileNames);
rows = floor(num/10);
if(rows == num/10)
    col = num/rows;
else
   col = floor(num/rows) + 1; 
end
montage(fileNames,'Size',[rows col]);
