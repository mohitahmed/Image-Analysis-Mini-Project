function S = myclassifier(im)
    % im = imread("Mini Project\Intro2IA_Mini_Project_complete\mini_project\Train\captcha_0002.png");
    % imshow(im)
    S = [];
    load ('Model.mat', 'Model');
  
    features = [];
    a = extractDigits1(im); % Extract features
    for j=1:3
        features(end+1,:) = a(j,:);
    end
    
    pred = predict(Model,features);
    S(1) = str2num(pred{1});
    S(2) = str2num(pred{2});
    S(3) = str2num(pred{3});
    
end