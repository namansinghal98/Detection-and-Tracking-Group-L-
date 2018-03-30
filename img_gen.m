function n = img_gen(start_pt, end_pt, a_x, a_y, vel, img_edge)
%Image Generator
%This function generates grayscale images based on gaussian plume model
%This function takes in the starting and ending points of the target, the
%semi-axes of the gaussian-plume, the velocity('vel') of the target and the
%edge length of the image
%The start_pt and end_pt must be matrices of size 1x2.........(1)
%The edge length of the image must be such that i could accomodate the
%traversal of the image
if numel(start_pt)~=2 %check for condition(1)
    error('start_pt should be of the format [x,y]')
end
if numel(end_pt)~=2 %check for condition(1)
    error('start_pt should be of the format [x,y]')
end

A = [start_pt;end_pt];
dist = pdist(A,'euclidean'); %euclidean distance between the atart and end points
dist_x = vel.*((end_pt(1)-start_pt(1))./dist);%distance covered by the target in x-direction in one sampling period
%disp(dist);
%disp(dist_x);
dist_y = vel.*((end_pt(2)-start_pt(2))./dist);%distance covered by the target in y-direction in one sampling period
bound = round((img_edge-1)/2);
[X,Y] = meshgrid(-1*bound:1:bound);

for j = 0:+1:(dist/vel)%image generation loop
    Z = 10.*exp(-1/2*(((X-start_pt(1)-j.*dist_x).^2/(a_x^2))+((Y-start_pt(2)-j.*dist_y).^2/(a_y^2))));
    Z = imnoise(mat2gray(Z,[0 10]),'gaussian');
    %sz = size(Z);
    %Z = [Z 10.*ones(sz(1),1)];
    imwrite(Z, strcat('test_',int2str(j),'.png'));
end
n = floor(dist/vel)+1;
