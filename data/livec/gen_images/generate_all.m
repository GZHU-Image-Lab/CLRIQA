function output = generate_all(img, img_name)

bmp_imname = strcat(img_name, '.bmp');
jpeg_imname = strcat(img_name, '.jpg');
jpeg_tempath = '/home/XXX/Desktop/Gen_LIVEC/Gendata12/temp/temp.jpg';
jpeg_level = [90	84	76	67	59];
OU_type = {'Original', 'OE', 'UE', 'OEandUE'};
mulfile_type = {'1','2','3' ,'4', '1,2','1,3','1,4','2,3','2,4' ,'3,4', '1,2,3','1,2,4','1,3,4','2,3,4', '1,2,3,4'};

for ou = 1:4
path = '/home/XXX/Desktop/Gen_LIVEC/Gendata12';
path = fullfile(path, OU_type{ou});

for t = 5:15
path = fullfile('/home/XXX/Desktop/Gen_LIVEC/Gendata12', OU_type{ou});
path = fullfile(path, strcat('t', num2str(t)));
cho_com = randi(2);

    
for level = 0:5
save_path = fullfile(path, num2str(level));
if level == 0
    temp_img = img;
    imwrite(temp_img, fullfile(save_path, bmp_imname),'bmp');
else
    oue_img = simulate_ou(img, ou, level);
    mult_num = strsplit(mulfile_type{t}, ',');
    
    switch length(mult_num)
           case 1
                temp_img = im2uint8(gentype(oue_img, str2double(mult_num{1}), level));
                 if cho_com == 1
                       imwrite(temp_img, jpeg_tempath,'jpg','quality', jpeg_level(level));
                       temp_img = imread(jpeg_tempath);
                 end
                       imwrite(temp_img, fullfile(save_path,bmp_imname),'bmp');
                 
           case 2
               temp_img1 = gentype(oue_img, str2double(mult_num{1}), level);
               temp_img2 = gentype(oue_img, str2double(mult_num{2}), level);
               temp_img = im2uint8(temp_img1/2+temp_img2/2);
                if cho_com == 1
                       imwrite(temp_img,jpeg_tempath,'jpg','quality', jpeg_level(level));
                       temp_img = imread(jpeg_tempath);
                 end
                       imwrite(temp_img, fullfile(save_path,bmp_imname),'bmp');
                       
           case 3
                   temp_img1 = gentype(oue_img, str2double(mult_num{1}), level);
                   temp_img2 = gentype(oue_img, str2double(mult_num{2}), level);
                   temp_img3 = gentype(oue_img, str2double(mult_num{3}), level);
                   temp_img = im2uint8(temp_img1/3+temp_img2/3+temp_img3/3);
                    if cho_com == 1
                           imwrite(temp_img,jpeg_tempath,'jpg','quality', jpeg_level(level));
                           temp_img = imread(jpeg_tempath);
                     end
                           imwrite(temp_img, fullfile(save_path,bmp_imname),'bmp');
                           
           case 4
                   temp_img1 = gentype(oue_img, str2double(mult_num{1}), level);
                   temp_img2 = gentype(oue_img, str2double(mult_num{2}), level);
                   temp_img3 = gentype(oue_img, str2double(mult_num{3}), level);
                   temp_img4 = gentype(oue_img, str2double(mult_num{4}), level);
                   temp_img = im2uint8(temp_img1/4+temp_img2/4+temp_img3/4+temp_img4/4);
                    if cho_com == 1
                           imwrite(temp_img,jpeg_tempath,'jpg','quality', jpeg_level(level));
                           temp_img = imread(jpeg_tempath);
                     end
                           imwrite(temp_img, fullfile(save_path,bmp_imname),'bmp'); 
            
    end
    
    
end
end
end
end
end

