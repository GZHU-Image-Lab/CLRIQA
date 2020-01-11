clc;clear;
db_path = '/home/fuzhao/Desktop/LIVE';
file = dir(strcat(db_path, '/*.bmp'));


    for i = 1:length(file)
        img = imread(fullfile(db_path, file(i).name));
        imname = file(i).name(1:end-4);

        generate_image(img, imname);
    end
