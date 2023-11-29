% Read the image with diagonal structured noise
noisy_image = imread('Mini Project\Intro2IA_Mini_Project_complete\mini_project\Train\captcha_0001.png');
y = imbinarize(rgb2gray(noisy_image));
figure;
imshow(y);
noisy_image = rgb2gray(noisy_image);
noisy_image = imgaussfilt(noisy_image,.8);
noisy_image = medfilt2(noisy_image);


%noisy_image = imbinarize(noisy_image);
figure;
imshow(noisy_image);

fft_image = fftshift(fft2(noisy_image));
%magnitude_spectrum = abs(fft_image);
%figure;
%imagesc(log(1 + magnitude_spectrum))
%colormap jet;
%colorbar;
% figure;
% % Define the size of the matrix
% matrix_size1 = 325;
% matrix_size2 = 435;
% 
% % Create a matrix filled with zeros
% matrix = zeros(matrix_size1, matrix_size2);
% 
% % Define the properties of the circles
% radius1 = 25;
% radius2 = 80;
% radius3 = 100;
% 
% % Calculate the center of the matrix
% center1 = (matrix_size1 + 1) / 2;
% center2 = (matrix_size2 + 1) / 2;
% 
% % Generate the three circles
% for i = 1:matrix_size1
%     for j = 1:matrix_size2
%         distance = sqrt((i - center1)^2 + (j - center2)^2);
%         if distance <= radius1 || (distance >= radius2 && distance <= radius3)
%             matrix(i, j) = 1;
%         end
%     end
% end
% 
% % Display or use the matrix as needed
% imshow(matrix, 'InitialMagnification', 'fit');

fx = 1 / 19; % 1 / period in x direction
fy = 1 / 19; % 1 / period in y direction
Nx = 325; % image dimension in x direction
Ny = 435; % image dimension in y direction
[xi, yi] = ndgrid(1 : Nx, 1 : Ny);
mask = sin(2 * pi * (fx * xi  + fy * yi)) > 0; % for binary mask
%mask = (sin(2 * pi * (fx * xi  + fy * yi)) + 1) / 2; % for gradual [0,1] mask
%imagesc(mask); % only if you want to see it

B = double(mask);











filtered_fft_image = fft_image .* B;

% Compute the inverse 2D Fourier Transform to obtain the filtered image
filtered_image = ifft2(ifftshift(filtered_fft_image));
filtered_image = real(filtered_image);  % Ensure real values

% Display the filtered image
figure;
imshow(uint8(filtered_image));
title('Filtered Image');

 x = uint8(filtered_image);
% x = imgaussfilt(x,1.5);
% x = medfilt2(x);
% x = rgb2gray(x);
x = imbinarize(x);
figure;
imshow(x);
x = imcomplement(x);

y = bwareaopen(x,500);
y = imcomplement(y);
figure;
imshow(y);
