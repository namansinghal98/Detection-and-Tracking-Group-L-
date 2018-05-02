function Displayimg(file_path)
fileFolder = fullfile(file_path);
dirOutput = dir(fullfile(fileFolder,'test_*.png'));
fileNames = {dirOutput.name}';
if(isempty(fileNames))
    error('There are no images present in the current folder: \n1)Try running Image generation function first and try again.\n2)Check if the file path "%s" specified is correct',file_path);
end
global num_of_img;
global bound;
figure; hold on
[X,Y] = meshgrid(-1*bound:1:bound);
for i = 0:+1:num_of_img-1
        k = imread(fullfile(file_path,strcat('test_',int2str(i),'.png')));

surf(X,Y,k);
colormap default;
colorbar;
end
L = imread(fullfile(file_path,strcat('test_',int2str(num_of_img-1),'.png')));
surf(X,Y,L);
view(17,20)
hold off

figure; hold on
[X,Y] = meshgrid(-1*bound:1:bound);
for i = 0
        k = imread(fullfile(file_path,strcat('test_',int2str(i),'.png')));

surf(X,Y,k);
colormap default;
colorbar;
end
L = imread(fullfile(file_path,strcat('test_',int2str(num_of_img-1),'.png')));
surf(X,Y,L);
view(17,20);
hold off

figure;
hold on
if(num_of_img>5)
    b = floor((num_of_img)/5)*5;
    for i = 0:+5:b-1
        k = imread(fullfile(file_path,strcat('test_',int2str(i),'.png')));
        surf(X,Y,k);
    end
end
L = imread(fullfile(file_path,strcat('test_',int2str(num_of_img-1),'.png')));
surf(X,Y,L);
colorbar;
view(17,20);