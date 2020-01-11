clc;clear;
addpath('used_function/');
addpath('BM3D/');
db_path = '/home/fuzhao/Desktop/TID2013/distorted_images';
file = dir(strcat(db_path, '/*')) ;
file = file(3:end,:);

for i = 1:length(file)
    img = imread(fullfile(db_path, file(i).name));
    imname = file(i).name;
    generate_tid2013(img, imname);
end
