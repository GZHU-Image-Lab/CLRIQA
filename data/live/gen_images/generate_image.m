function output = generate_image(img, img_name)

    path = '/home/fuzhao/Desktop/Gen_LIVE/data';
    temp_jpg = '/home/fuzhao/Desktop/Gen_LIVE/data/temp/temp.jpg';
    temp_jp2 = '/home/fuzhao/Desktop/Gen_LIVE/data/temp/temp.jp2';
 

    jp2k_level = [0.43, 0.33, 0.22, 0.12, 0.01];
    jpeg_level = [81.6,61.50,41.4,21.3,1.2];
    wn_level = [-12,-9,-6,-3,0];
    gblur_level = [19,43,67,91,115];
    
for  type = 1:4
   save_t = fullfile(path,strcat('t', num2str(type)));
    
for level = 0:5
    save_path = fullfile(save_t, num2str(level));
    save_imname = fullfile(save_path, strcat(img_name, '.bmp'));
    %temp_img = img;
if level == 0
        imwrite(img, save_imname,'bmp');
    else
%% type
switch type
    case 1
       %% gaussian blur

        hsize = gblur_level(level);
        h = fspecial('gaussian', hsize, hsize/6);
        temp_img = imfilter(img,h,'symmetric', 'same');
        imwrite(temp_img, save_imname,'bmp');
    case 2
       %% jp2k
        imwrite(img,temp_jp2,'jp2','CompressionRatio', 24 / jp2k_level(level));
        temp_img = imread(temp_jp2);
        imwrite(temp_img, save_imname,'bmp');

    case 3
        %% wn

        temp_img = imnoise(img,'gaussian',0,2^(wn_level(level))); 
        imwrite(temp_img, save_imname, 'bmp');

    case 4
        %% jpeg

        imwrite(img, temp_jpg, 'jpg', 'quality', jpeg_level(level));
        temp_img = imread(temp_jpg);
        imwrite(temp_img, save_imname, 'bmp');
        
end
end
end
end
end
