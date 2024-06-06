% Assignment 4a
im = imread("michelangelo_colorshift.jpg"); % reading image
im = double(im)/255;    %this division is to scale the range of colors to be between 0 and 1; just to make things be on the same scale 
% since we have to divide by 0.5 and 1 things like that.

%the mean of each color channel
r_mean = mean(im(:,:,1),"all");
g_mean = mean(im(:,:,2),"all");
b_mean = mean(im(:,:,3),"all");

%scaling factor of each channel
g_alpha = 0.5/r_mean;
g_beta = 0.5/g_mean; 
g_gamma = 0.5/b_mean;

% the final image is just a combination (i.e concatenation along dim 3) of each scaling factor x its channel
grey_image = cat(3, g_alpha*im(:,:,1), g_beta*im(:,:,2), g_gamma*im(:,:,3));
imwrite(grey_image, 'grey_world.jpg')

%now white world
%the max of each color channel
r_max = max(im(:,:,1),[],"all");
g_max = max(im(:,:,2),[],"all");
b_max = max(im(:,:,3),[],"all");

%scaling factor of each channel
w_alpha = 1/r_max;
w_beta = 1/g_max; 
w_gamma = 1/b_max;

%transformed white image
white_image = cat(3, w_alpha*im(:,:,1), w_beta*im(:,:,2), w_gamma*im(:,:,3));
imwrite(white_image, 'white_image.jpg')


subplot(3,1,1)
imshow(white_image);
title("White Patch")

subplot(3,1,2)
imshow(grey_image);
title("Grey World")

github_image = imread("result.jpg");
github_image = double(github_image)/255;

reference = imread("michelangelo_correct.jpg");
reference = double(reference)/255;

subplot(3,1,3)
imshow(grey_image);
title("Github Image")
%% calculating the errors, using PSNR, SSIM and FLIP
% PSNR, must convert RGB to YCbCr
psnr_image_grey = rgb2ycbcr(grey_image);
psnr_image_white = rgb2ycbcr(white_image);
psnr_image_github = rgb2ycbcr(github_image);
psnr_image_ref = rgb2ycbcr(reference);

psnr_grey = psnr(psnr_image_grey(:,:,1),psnr_image_ref(:,:,1))
psnr_white = psnr(psnr_image_white(:,:,1),psnr_image_ref(:,:,1))
psnr_github = psnr(psnr_image_github(:,:,1),psnr_image_ref(:,:,1))

% SSIM 
ssim_grey = ssim(grey_image,reference,"DataFormat","SSC");
ssim_grey = mean(ssim_grey,3)
ssim_white = ssim(white_image, reference,"DataFormat","SSC");
ssim_white = mean(ssim_white,3)
ssim_github = ssim(github_image,reference,"DataFormat","SSC");
ssim_github = mean(ssim_github,3)

% FLIP Error
flip_grey = computeFLIP(reference,grey_image)
flip_white = computeFLIP(reference, white_image)
flip_github = computeFLIP(reference, github_image)


%% 3; two view geometry
a1 = [-4;5;1];
a2 = [3;-7;1];
a3 = [-10;5;1];
b1 = [3;2;1];
b2 = [6;-1;1];
b3 = [2;-2;1];
F = [2 2 4; 3 3 6; -5 -10 -6];
points_a1 = zeros(1,3);
points_a2 = zeros(1,3);
points_a3 = zeros(1,3);

%points that correspond to a1
points_a1(1) = b1.'*F*a1;
points_a1(2) = b2.'*F*a1;
points_a1(3) = b3.'*F*a1;

 %points that correspond to a2
 points_a2(1) = b1.'*F*a2;
 points_a2(2) = b2.'*F*a2;
 points_a2(3) = b3.'*F*a2;

%points that correspond to a3
points_a3(1) = b1.'*F*a3;
points_a3(2) = b2.'*F*a3;
points_a3(3) = b3.'*F*a3;

disp(points_a1)
disp(points_a2)
disp(points_a3)


     



