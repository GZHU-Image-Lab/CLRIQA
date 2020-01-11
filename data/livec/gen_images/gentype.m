function output =  gentype(temp_img ,type, level)
mot_level = [ 6,	10.5,	15,	19.5,	24];
gblur_level = [5,	8,	11,	14,	17];
ca_level = [4,	7,	10,	13,	16];
cont_level = [0.11,	0.20,	0.29,	0.38,	0.47];
   

switch type
    case 1
       %% gaussian blur

        hsize = gblur_level(level);
        h = fspecial('gaussian', hsize, hsize/6);
        temp_img = imfilter(temp_img,h,'symmetric', 'same');
        
    case 2
       %% motion-induced blur distorted

        mot_angle = randi([0,360]);
        PSF = fspecial('motion',mot_level(1,level),mot_angle);
        temp_img = imfilter(temp_img, PSF, 'conv', 'symmetric', 'same');

    case 3
       %% # Chromatic aberrations
        
         hsize = 3;
         R=(temp_img(:,:,1));
         G=(temp_img(:,:,3));
         B=(temp_img(:,:,2));
         R2=R;
         B2=B;
         R2(:,ca_level(level):end)=R(:,1:end-ca_level(level)+1);
         B2(:,ca_level(level)/2:end)=B(:,1:end-ca_level(level)/2+1);
         temp = temp_img;
         temp(:,:,1)=R2;
         temp(:,:,2)=B2;
         temp_img = temp;
         h = fspecial('gaussian', hsize, hsize/6);
         temp_img=imfilter(temp_img,h,'symmetric');
         
    case 4
        %% global contrast
        for chann = 1:3
            I = temp_img(:,:,chann);
            temp_img(:,:,chann) = imadjust(I,[],[cont_level(level), 1-cont_level(level)]);
        end
        
end

output = im2double(temp_img);
