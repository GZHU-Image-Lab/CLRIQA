function output = generate_csiq(img, img_name)

    path = '/home/XXX/Desktop/CSIQ/gen_CSIQ/back';
    wn_level = [0.0050,0.0110,0.01700,0.0230,0.0290];
    cont_level = [0.1128,0.2070,0.3012,0.3954,0.4896];
    gblur_level = [14,32,50,68,86];
    jpeg_level = [42,33,24,15,6];
    jp2k_level = [0.40,0.31,0.22,0.13,0.04];
 
    
type = randi(5);
for level = 1:5
    save_path = fullfile(path,num2str(level));
    save_imname = strcat(img_name , '.bmp');
%% type
switch type
    case 1
       %% #1 awgn

        temp_img = img;
        temp_img = imnoise(img,'gaussian',0,(wn_level(level)));
        imwrite(temp_img, fullfile(save_path, save_imname), 'bmp');
        
    case 2
       %% #2 blur

        hsize = gblur_level(level);
        h = fspecial('gaussian', hsize, hsize/6);
        temp_img = imfilter(img,h,'symmetric');
        imwrite(temp_img, fullfile(save_path, save_imname), 'bmp');        
        
    case 3
       %% #3 contrast
       
        temp_img = img;
        for chann = 1:3
            I = img(:,:,chann);
            temp_img(:,:,chann) = imadjust(I,[],[cont_level(level), 1-cont_level(level)]);
        end
        imwrite(temp_img, fullfile(save_path, save_imname), 'bmp');
        
    case 4
        %% #4 JPEG compression
        
        save_imname_jpeg = strcat(img_name, '.jpg');
        imwrite(img,fullfile(save_path, save_imname_jpeg),'jpg','quality',jpeg_level(level));
        
    case 5
        %% #5 JPEG2000 compression
        
        save_imname_jp2 = strcat(img_name, '.jp2');
        imwrite(img,fullfile(save_path, save_imname_jp2),'jp2','CompressionRatio', 24 / jp2k_level(level));
        

end
end
end
