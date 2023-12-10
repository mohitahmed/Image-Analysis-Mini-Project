function S = myclassifier(im)
    S = [];
    load ('model.mat', 'model');
  
    features = [];
    a = Preprocessing(im); % Extract features
    for j=1:3
        features(end+1,:) = a(j,:);
    end
    
    pred = predict(model,features);
    S(1) = str2num(pred{1});
    S(2) = str2num(pred{2});
    S(3) = str2num(pred{3});
    
end