tic;
data = importdata('Train/labels.txt');
img_nrs = data(:,1);
true_labels = data(:,(2:4));

train = length(img_nrs);
train_labels = {};

train_patterns = [];

fprintf('Extracting Training Digits...\n');

for i=1:train
    k = img_nrs(i);
    im = imread(sprintf('Train/captcha_%04d.png', k));
    a = Preprocessing(im);
    for j=1:3
        train_patterns(end+1,:) = a(j,:);
        train_labels{end+1} = num2str(true_labels(i,j));
    end

end

fprintf('Model training...\n');

tr = templateTree('MaxNumSplits',100);
model = fitcensemble(train_patterns, train_labels, 'Learners',tr); 
save model;

toc;
