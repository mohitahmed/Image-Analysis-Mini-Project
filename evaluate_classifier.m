tic
data = importdata('Train/labels.txt');
img_nrs = data(:,1);
true_labels = data((1000:1200),(2:4));

my_labels = [];
N = size(img_nrs);

% im = imread('Train/captcha_1002.png');
% imshow(im)
% x = myclassifier(im);
% x = true_labels(:,1);
% y = 1;
for n = 1000:N
    %k = img_nrs(n);
    sprintf('Train/captcha_%04d.png', n)
    im = imread(sprintf('Train/captcha_%04d.png', n));
    my_labels(end+1,:) = myclassifier(im);
end


fprintf('\n\nAccuracy: \n');
fprintf('%f\n\n',mean(sum(abs(true_labels(:,1) - my_labels(:,1)),2)==0));
fprintf('%f\n\n',mean(sum(abs(true_labels(:,2) - my_labels(:,2)),2)==0));
fprintf('%f\n\n',mean(sum(abs(true_labels(:,3) - my_labels(:,3)),2)==0));
toc

