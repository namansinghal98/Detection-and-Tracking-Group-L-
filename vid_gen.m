function vid_gen(file_path)
% This function is the video generator which creates a video name target.avi by combining all the images generated using img_gen function.
% The frame rate of the video is taken to be 25 frames per second.
fileFolder = fullfile(file_path);
dirOutput = dir(fullfile(fileFolder,'test_*.png')); % The png files starting with 'test_' are taken into account
fileNames = {dirOutput.name}';
fileNames = natsort(fileNames);% Natural sorting of the filenames
outputVideo = VideoWriter(fullfile(file_path, 'target.avi'));
outputVideo.FrameRate = 25;% Frame rate of the video
open(outputVideo);
for i = 1:length(fileNames)% Combinig the images
   img = imread(fullfile(file_path,strcat('test_',int2str(i-1),'.png')));
   writeVideo(outputVideo,img)
end
close(outputVideo);
