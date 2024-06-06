function S = im2segment(im)

 im = uint8(im); %converting the image into 8 bit
 
 im_f = medfilt2(im);
 im_f = imgaussfilt(im_f); %filtering the image for noise
 
 bnd = 40; % set some arbitrary bound on thresholding
 im_t = im_f>bnd; % threshold the image

 %I want to try it now with dilation before segmentation
 % Define the structuring element for dilation (you can adjust its size and shape)
%  se = strel('disk', 1); % Example: Creates a disk-shaped structuring element with a radius of 1 pixel
 % Apply dilation to the thresholded image
%  im_d = imclose(im_t,se);

%  L = bwlabel(im_t); % label connected components in image
%  nrseg = max(L(:)); % find out number of segments
 counter = sum(im_t,2);
 white_pixels = find(counter>0);
 first = white_pixels(1);
 last = white_pixels(end);

 image = im_t
%  initialnrseg = max(L(:));
%   for i = 1:5
%       if nrseg > 5
%           im_d = bwmorph(im_d,'majority');
%           L = bwlabel(im_d);
%           nrseg = max(L(:)); 
%       end
%   end 
  
%   if initialnrseg > 5
%       im_d = bwmorph(im_d,'thin');
%       L = bwlabel(im_d);
%   end 
  %nrseg = 5;

S = cell(1,nrseg); %creating the cell array S
for kk = 1:nrseg    %created a for loop to store the different segments in 
          S{kk} = (L==kk); %different cells of the array when the index is the same as segment number

end

