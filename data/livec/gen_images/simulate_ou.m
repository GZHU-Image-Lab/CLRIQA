function output = simulate_ou(temp_img, type, level)

switch type
    case 1
        output = temp_img;

    case 2
        [m,n,k1] = size(temp_img);
        hsv = rgb2hsv(temp_img);
        V = hsv(:,:,3);
 
        hsv = rgb2hsv(temp_img);

        for j = 1:m   
            for k = 1: n

        sharp = 0.006 * hsv(j,k,3)^3.00;
        sharp2 = 0.0315*hsv(j,k,3)^2.42;
        hsv(j,k,3) = sharp*level^2+sharp2*level+(hsv(j,k,3));

            end
        end
        output = im2uint8(hsv2rgb(hsv));

    case 3
              
        [m,n,k1] = size(temp_img);
        hsv = rgb2hsv(temp_img);
        V = hsv(:,:,3);
 
        hsv = rgb2hsv(temp_img);

        for j = 1:m   
            for k = 1: n

        sharp = -0.0018 * log(hsv(j,k,3))-0.00005;
        sharp2 = 0.000021 * hsv(j,k,3)^(-3.0);
        hsv(j,k,3) = -sharp*level^2-sharp2*level+(hsv(j,k,3));

            end
        end
        output = im2uint8(hsv2rgb(hsv));

 case 4
        [m,n,k1] = size(temp_img);
        hsv = rgb2hsv(temp_img);
        V = hsv(:,:,3);
 
        hsv = rgb2hsv(temp_img);

        for j = 1:m   
            for k = 1: n

        sharp = 0.006 * hsv(j,k,3)^3.00;
        sharp2 = 0.0315*hsv(j,k,3)^2.42;
        hsv(j,k,3) = sharp*level^2+sharp2*level+(hsv(j,k,3));

            end
        end
        temp_img = im2uint8(hsv2rgb(hsv));

        hsv = rgb2hsv(temp_img);
        V = hsv(:,:,3);
 
        hsv = rgb2hsv(temp_img);

        for j = 1:m   
            for k = 1: n

        sharp = -0.0018 * log(hsv(j,k,3))-0.00005;
        sharp2 = 0.000021 * hsv(j,k,3)^(-3.0);
        hsv(j,k,3) = -sharp*level^2-sharp2*level+(hsv(j,k,3));

            end
        end
        output = im2uint8(hsv2rgb(hsv));
end