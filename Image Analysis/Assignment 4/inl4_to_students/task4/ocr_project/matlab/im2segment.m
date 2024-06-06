function S = im2segment(im)

im = uint8(im); %converting the image into 8 bit

% im_f = imgaussfilt(im); %filtering the image for noise
im_f = medfilt2(im,[2 2]);

bnd = 28; % set some arbitrary bound on thresholding
im_t = im_f>bnd; % threshold the image
im_d = bwareaopen(im_t,3);

L = bwlabel(im_d); % label connected components in image
nrseg = max(L(:)); % find out number of segments

% discarding any segments with area less than 25%
if nrseg > 5
    connComp = bwconncomp(im_d);
    stats = regionprops(connComp, 'Area');
    thresholdArea = 25; % set by experimenting
    for i = 1:length(stats)
        if stats(i).Area < thresholdArea
            im_d(connComp.PixelIdxList{i}) = 0;
        end
    end
    L = bwlabel(im_d);
    nrseg = max(L(:));
end

S = cell(1,nrseg); %creating the cell array S

for kk = 1:nrseg    %created a for loop to store the different segments in 
        S{kk} = (L==kk); %different cells of the array when the index is the same as segment number
end
