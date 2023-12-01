data = importdata('Train/labels.txt');
img_nrs = data(:,1);
true_labels = data(:,(2:4));

train = 1000;
test = 200;
train_labels = {};
test_labels = {};

train_patterns = [];
test_patterns = [];

fprintf('Extracting Training Digits...\n');
% a = extractDigits1(imread("Train\captcha_1100.png"));
% y(end+1,:) = BasicFeatureExtraction(a{1});

%TRAINING
for i=1:train
    if i < 10
        a = extractDigits1(imread(strcat(strcat('Train/captcha_000',num2str(i)),'.png'))); 
    elseif i >= 10 && i < 100
        a = extractDigits1(imread(strcat(strcat('Train/captcha_00',num2str(i)),'.png'))); 
    elseif i >=100 && i < 1000
        a = extractDigits1(imread(strcat(strcat('Train/captcha_0',num2str(i)),'.png'))); 
    elseif i >= 1000
        a = extractDigits1(imread(strcat(strcat('Train/captcha_',num2str(i)),'.png'))); 
    end

    for j=1:3
            train_patterns(end+1,:) = a(j,:);
            train_labels{end+1} = num2str(true_labels(i,j));
    end

end

fprintf('Extracting Testing Digits...\n');

% test
for i=1:test
    if i+train < 10
        a = extractDigits1(imread(strcat(strcat('Train/captcha_000',num2str(i+train)),'.png'))); 
    elseif i+train >= 10 && i+train < 100
        a = extractDigits1(imread(strcat(strcat('Train/captcha_00',num2str(i+rain)),'.png'))); 
    elseif i+train >=100 && i+train < 1000
        a = extractDigits1(imread(strcat(strcat('Train/captcha_0',num2str(i+ntrain)),'.png'))); 
    elseif i+train >= 1000
        a = extractDigits1(imread(strcat(strcat('Train/captcha_',num2str(i+train)),'.png'))); 
    end

    for j=1:3
            test_patterns(end+1,:) = a(j,:);
            test_labels{end+1} = num2str(true_labels(i+train,j));
    end


end

% KNN 
k=3;
Model = fitcknn(double(train_patterns),train_labels, 'NumNeighbors',k, 'BreakTies','nearest');
save Model;

fprintf('\nResubstitution error: %5.2f%%\n\n',100*resubLoss(Model));
fprintf('Predicting validation set...\n');
t=tic;
validation_pred = predict(Model,test_patterns);
toc(t);
x = categorical(transpose(test_labels));

accuracy = mean(validation_pred == x);
fprintf('Validation accuracy: %5.2f%%\n',accuracy*100);

f=figure(2);
if (f.Position(3)<800)
	set(f,'Position',get(f,'Position').*[1,1,1.5,1.5]); %Enlarge figure
end
confusionchart(test_labels, validation_pred, 'ColumnSummary','column-normalized', 'RowSummary','row-normalized');
title(sprintf('Validation accuracy: %5.2f%%\n',accuracy*100));

% wat = []
% IM = imread("Mini Project\Intro2IA_Mini_Project_complete\mini_project\Train\captcha_1001.png");
% imshow(IM);
% a = extractDigits1(IM);
%     for j=1:3
%             wat(end+1,:) = a(j,:);
%             %the{end+1} = num2str(true_labels(i+train,j));
%     end
% 
% w = predict(Model,wat)








% dist=pdist2(test_patterns,train_patterns); %Pairwise distance from each validation pattern to all training patterns
% y = categorical(transpose(train_labels));

% %Then find the k Smallest distances, and vote on the correct class
% k=3;
% [dst,knn]=mink(dist,k,2); %k nearest neighbours and their distances
% votes=train_labels(knn); %votes from the nearest neighbours
% 
% C=categories(y); %Class names
% clear validation_pred;
% for i=1:size(dst,1) %for each test sample
%    count=accumarray(double(y(knn(i,:))),1,size(C)); %Count votes
% 	[s,v]=maxk(count,2); %get the two most voted classes
% 	if (s(1)==s(2)) %if equal vote count
% 		validation_pred(i,1)=votes(i,1); %select the nearest class
% 	else
% 		validation_pred(i,1)=C(v(1)); %otherwise the most voted
% 	end
% end
% 
% 
% 
% 
% accuracy = mean(validation_pred == x);
% fprintf('Validation accuracy: %5.2f%%\n',accuracy*100);
% 
% f=figure(2);
% if (f.Position(3)<800)
% 	set(f,'Position',get(f,'Position').*[1,1,1.5,1.5]); %Enlarge figure
% end
% confusionchart(transpose(test_labels), validation_pred, 'ColumnSummary','column-normalized', 'RowSummary','row-normalized');
% title(sprintf('Validation accuracy: %5.2f%%\n',accuracy*100));

