tic

data = importdata('Train/labels.txt');
img_nrs = data(:,1);
true_labels = data(:,(2:4));

threshold = 0.7*length(img_nrs);

train_patterns = {};
test_patterns = {};

train_labels=true_labels(1:threshold,:);
test_labels=true_labels(threshold+1:length(data),:);

for n = 1:threshold
    k = img_nrs(n);
    train_patterns{end+1}=imread(sprintf('Train/captcha_%04d.png', k));
end

model = fit_model(train_patterns, train_labels);

my_labels = zeros(size(test_labels));

for n = threshold+1:length(data)
    k = img_nrs(n);
    im = imread(sprintf('Train/captcha_%04d.png', k));
    my_labels(n-threshold,:) = myclassifier(im, model);
end
fprintf('\n\nAccuracy: \n');
fprintf('%f\n\n',mean(sum(abs(test_labels - my_labels),2)==0)*100);
toc

