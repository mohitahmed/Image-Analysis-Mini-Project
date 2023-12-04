function a=extractDigits1(I)
    a = [];
    I_gray = rgb2gray(I);

    
    %Fourier transform
    fft = fft2(double(I_gray));
    fftshifted = fftshift(fft);
    
    magnitude = log(abs(fftshifted) + 1);
    
    size_image = size(magnitude);
    
    tan_min = tan(deg2rad(66));
    tan_max = tan(deg2rad(67));
    
    for i = 1:size_image(1)
        for j = 1:size_image(2)
            tangent = (j - round(0.5 * size_image(2)))/(i - round(0.5 * size_image(1)));     
            if tangent > tan_min  && tangent < tan_max
                fftshifted(i,j) = 0;
            end 
        end 
    end 
    
    magnitude = log(abs(fftshifted) + 1);
    % imshow(magnitude, []);
    % title("Result Magnitude")
    
    ifftshifted = ifftshift(fftshifted);
    res = uint8(ifft2(ifftshifted));
    res = imadjust( res);

    res= imresize(res, 0.7);

    res =imgaussfilt(res,1.5);
    %res=histeq(res)
    res = imresize(res , 0.9);

    %Binarization
    I_binary = imbinarize(res);

    I_binary = ~I_binary;

    se = strel("diamond",3);
    I_eroded = imerode(I_binary,se);

    se = strel("diamond",2);
    I_eroded = imdilate(I_eroded,se);


    I_open = bwareaopen(I_eroded, 300);


    %Dilation

    I_skeleton = bwskel(I_open ,'MinBranchLength',4);

    count = bwconncomp(I_skeleton,8);
    props = regionprops(count, 'Image');
    
    if count.NumObjects == 1
        [h,w] = size(props(1).Image);
        split = round(w/3);
        I1 = imcrop(props(1).Image,[0 0 split h]);
        I2 = imcrop(props(1).Image,[split 0 split h]);
        I3 = imcrop(props(1).Image,[split*2 0 split h]);
        a(1,:) = FeatureExtraction(I1);
        a(2,:) = FeatureExtraction(I2);
        a(3,:) = FeatureExtraction(I3);
       
    elseif count.NumObjects == 2
        [h1,w1] = size(props(1).Image);
        [h2,w2] = size(props(2).Image);
        if w1 > w2 % Split first image
            I1 = imcrop(props(1).Image,[0 0 round(w1/2) h1]);
            I2 = imcrop(props(1).Image,[round(w1/2) 0 round(w1/2) h1]);
            I3 = props(2).Image;
            
        else % Split second image
            I1 = props(1).Image;
            I2 = imcrop(props(2).Image,[0 0 round(w2/2) h2]);
            I3 = imcrop(props(2).Image,[round(w2/2) 0 round(w2/2) h2]);
            
        end
        a(1,:) = FeatureExtraction(I1);
        a(2,:) = FeatureExtraction(I2);
        a(3,:) = FeatureExtraction(I3);

    elseif count.NumObjects == 3
        a(1,:) = FeatureExtraction(props(1).Image);
        a(2,:) = FeatureExtraction(props(2).Image);
        a(3,:) = FeatureExtraction(props(3).Image);

   elseif count.NumObjects == 4 %some captchas detect 4 digits. can be skipped
        a(1,:) = FeatureExtraction(props(1).Image);
        a(2,:) = FeatureExtraction(props(2).Image);
        a(3,:) = FeatureExtraction(props(3).Image);

        
    end

end

