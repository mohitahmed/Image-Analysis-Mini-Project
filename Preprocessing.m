function a=Preprocessing(I)
    I_gray = rgb2gray(I);
    %Fourier transform
    fft = fft2(double(I_gray));
    fftshifted = fftshift(fft); 
    size_image = size(fftshifted);
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
    ifftshifted = ifftshift(fftshifted);
    ifft = uint8(ifft2(ifftshifted));
    
    %increasing the contrast
    adjust = imadjust(ifft );

    %resizing 
    resize = imresize(adjust, 0.7);

    %Gaussian filter
    filtered =imgaussfilt(resize,1.5);

    %resizing 
    resized = imresize(filtered , 0.9);

    %Binirizing 
    I_binary = imbinarize(resized );
    I_binary = ~I_binary;

    %Morphology: erotion
    se = strel("diamond",3);
    I_eroded = imerode(I_binary,se);
    
    %Morphology: dilation
    se = strel("diamond",2);
    I_dilated = imdilate(I_eroded,se);
    
    %Morphology: opening
    I_open = bwareaopen(I_dilated, 300);

    %skeleton
    I_skeleton = bwskel(I_open,'MinBranchLength',4);
    
    %Digits extracting
    count = bwconncomp(I_skeleton,8);
    props = regionprops(count, 'Image');
    a = [];
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

    else
        a(1,:) = FeatureExtraction(props(1).Image);
        a(2,:) = FeatureExtraction(props(2).Image);
        a(3,:) = FeatureExtraction(props(3).Image);     
    end

end

