clc;clear;
db_path = '/home/XXX/Desktop/LIVE-C/';
file = [dir(strcat(db_path, '/*.bmp')) ; dir(strcat(db_path, '/*.JPG'))];

for i = 1:length(file)
    disp(i);
    img = imread(fullfile(db_path, file(i).name));
    imname = file(i).name(1:end-4);
    generate_all(img, imname);
end
