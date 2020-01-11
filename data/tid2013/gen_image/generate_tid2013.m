function output = generate_tid2013(img, img_name)

    path = '/home/XXX/Desktop/Gen_TID2013/data4';
    wn_level = [0.0082,0.019,0.0298,0.0406,0.0514];
    gnc_level = [0.016, 0.025, 0.034, 0.043, 0.052];
    in_level = [0.008, 0.0185,0.029,0.0395,0.050];
    qn_level = [13,10,7,4,1];
    gblur_level = [19,37,55,73,91];
    id_level = [0.008,0.0185,0.0290,0.0395,0.05]; 
    jpeg_level = [42,33,24,15,6];
    jp2k_level = [0.40,0.31,0.22,0.13,0.04];
    nepn_level = [66,120,174,228,282];
    bw_level = [6,12,18,24,30];
    ms_level = [21,30,39,48,57];
    cc_level = [0.79,0.70,0.61,0.52,0.43];
    cs_level = [0.23,-0.025,-0.28,-0.535,-0.79];
    mgn_level = [0.07,0.10,0.13,0.16,0.19];
    cqd_level = [63,48,33,18,3]; 
    ca_level = [4,7,10,13,16];
    
    
for type = 1:17
   path = '/home/fuzhao/Desktop/Gen_TID2013/data4';
   path = fullfile(path, strcat('t', num2str(type)));
for level = 0:5
    save_path = fullfile(path,num2str(level));
    save_imname = img_name;
    %temp_img = img;
%% level 0 
if level == 0 
           imwrite(img, fullfile(save_path, save_imname), 'bmp');
else
%     type = 5;
%% type
switch type
    case 1
       %% #1 Additive Gaussian noise

        temp_img = img;
        temp_img = imnoise(temp_img,'gaussian',0,(wn_level(level)));
        imwrite(temp_img, fullfile(save_path, save_imname), 'bmp');
        
    case 2
       %% #2 Additive noise in color components is more intensive than additive noise in the luminance component
        temp_img = img;
        ycbcr = rgb2ycbcr(temp_img);
        ycbcr = im2double(ycbcr);
        sizeA = size(ycbcr);
        b = ycbcr + sqrt(gnc_level(level))*randn(sizeA);
        b = ycbcr2rgb(b)*255;
        temp_img = uint8(b);
        imwrite(temp_img, fullfile(save_path, save_imname), 'bmp');
        
    case 3
       %% #5 Spatially correlated noise

        temp_img = imnoise(img,'gaussian',0,2^(wn_level(level))); 
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');

    case 4
        %% #6 Impulse noise
        
        temp_img =imnoise(img,'salt & pepper',(in_level(level)));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');

    case 5
        %% #7 Quantization noise
        
        temp_img = QuantizationNoise(img,qn_level(level));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
    case 6
        %% #8 Gaussian blur
        
        hsize = gblur_level(level);
        h = fspecial('gaussian', hsize, hsize/6);
        temp_img = imfilter(img,h,'symmetric');
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
    case 7
        %% #9 Image denoising
        
        temp_img = ImageDenoising(img,id_level(level));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
        
    case 8 
        %% #10 JPEG compression
        
        save_imname_jpeg = strcat(img_name(1:end-4), '.jpg');
        imwrite(img,fullfile(save_path, save_imname_jpeg),'jpg','quality',jpeg_level(level));
        temp_img = imread(fullfile(save_path, save_imname_jpeg));
        imwrite(temp_img, fullfile(save_path, img_name),'bmp');
        
    case 9 
        %% #11 JPEG2000 compression
        
        save_imname_jp2 = strcat(img_name(1:end-4), '.jp2');
        imwrite(img,fullfile(save_path, save_imname_jp2),'jp2','CompressionRatio', 24 / jp2k_level(level));
        temp_img = imread(fullfile(save_path, save_imname_jp2));
        imwrite(temp_img, fullfile(save_path, img_name),'bmp');
        
    case 10
        %% #14 Non eccentricity pattern noise
        
        temp_img = nepn(img,nepn_level(level));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
        
    case 11
        %% #15 Local block-wise distortions of different intensity
        
        temp_img = BlockWise(img,bw_level(level),randi(5));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
        
    case 12
        %% #16 Mean shift (intensity shift)
        
        temp_img = MeanShift(img,ms_level(level));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
        
    case 13 
        %% #17 Contrast change
        
        temp_img = ContrastChange(img,cc_level(level));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
        
    case 14
        %% #18 Change of color saturation

        temp_img = ColorSaturation(img,cs_level(level));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
        
    case 15
        %% #19 Multiplicative Gaussian noise
        
        temp_img = MultiGN(img,mgn_level(level));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
        
    case 16
        %% #22 Image color quantization with dither
        
        [temp,map]=rgb2ind(img,cqd_level(level));
        temp_img = uint8(ind2rgb(temp,map)*255);
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
        
    case 17 
        %% #23 Chromatic aberrations
        
        temp_img = CA(img,ca_level(level));
        imwrite(temp_img, fullfile(save_path, save_imname),'bmp');
end
end
end
end
