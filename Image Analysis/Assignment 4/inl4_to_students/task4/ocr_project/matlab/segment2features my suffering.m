function features = segment2features(If)

%first step; filter the image to remove noise; I'll use a median filter

%second step; centering the image
% Find centroid.
prop = regionprops(If, 'Centroid');
% Translate the image.
centepide = prop.Centroid;
xt = centepide(1,1);
yt = centepide(1,2);
% Get center of image
[rows, columns] = size(If);
xc = columns/2;
yc = rows/2;
deltax = xc - xt;
deltay = yc - yt;
Ic = imtranslate(If,[deltax deltay],'FillValues', 0);


% you will be the backbone of my normalizations
props = regionprops(Ic,'BoundingBox');
box = props.BoundingBox;
x_start = round(box(1,1)); %starting column
y_start = round(box(1,2)); %starting row
if y_start > 1
    y_start = y_start-1;
end 

width = box(1,3); %will be  used to normalize longest line
height = box(1,4);

x_end = round(x_start + width)-1;
y_end = round(y_start + height)-1;

ncol = round(width); %columns in bounding box
nrow = round(height); %rows in bounding box

%image size
row = size(Ic,1);
column = size(Ic,2);

% top to bottom half of the image
half = round(row/2);
if (row/2 ~= half)
    half = half-1;
end


%half of bounding box
col_half = round(ncol/2);

if col_half == 0
    col_half = 1;
elseif (ncol/2 ~= col_half)
    col_half = col_half-1;
end

row_half = round(nrow/2);

if row_half ==0
    row_half = 1;
elseif (nrow/2 ~= row_half)
    row_half = row_half-1;
end

% ratio of white pixels to total number of pixels in bounding box
nrnnz = nnz(Ic);
pixels = ncol*nrow;
ratio = (nrnnz/pixels);

% dividing the image-bounding box
bounding_box = Ic(y_start:y_end,x_start:x_end);
top = Ic(y_start:y_start+row_half,x_start:x_end);
bottom = Ic(y_start+row_half:y_end,x_start:x_end);
left = Ic(y_start:y_end,x_start:x_start+col_half);
right = Ic(y_start:y_end,x_start+col_half:x_end);

% ratio of white pixels to total number of pixels in top of bounding box
nrnnz_top = nnz(top);
pixels_topbot = ncol*nrow/2;
ratio_top = (nrnnz_top/pixels_topbot);

% ratio of white pixels to total number of pixels in bottom of bounding box
nrnnz_bottom = nnz(bottom);
ratio_bottom = (nrnnz_bottom/pixels_topbot);

% ratio of white pixels to total number of pixels in left of bounding box
nrnnz_left = nnz(left);
pixels_side = ncol/2*nrow;
ratio_left = (nrnnz_left/pixels_side);

% ratio of white pixels to total number of pixels in right of bounding box
nrnnz_right = nnz(right);
ratio_right = (nrnnz_right/pixels_side);

com_top = 0;
com_bottom = 0;
com_left = 0;
com_right = 0;
%if top has more pixels than bottom
if nrnnz_top > nrnnz_bottom
    com_top = 1;
elseif nrnnz_top < nrnnz_bottom
    com_bottom = 1;
elseif nrnnz_top == nrnnz_bottom
    com_top = 1;
    com_bottom = 1;
end

%if left or right has more pixels
if nrnnz_right > nrnnz_left
    com_right = 1;
elseif nrnnz_right < nrnnz_left
    com_left = 1;
elseif nrnnz_right == nrnnz_left
    com_right =1;
    com_left = 1;
end

%first feature the horizontal edges of the image 
 gx= [1 0 -1; 2 0 -2; 1 0 -1];
 f1 = conv2(gx,bounding_box);
 hist = histogram(f1,4);
 xbin_1 = hist.Values(1);
 xbin_2 = hist.Values(2);
 xbin_3 = hist.Values(3); %0s so not used
 xbin_4 = hist.Values(4);
 normalizer = xbin_1 + xbin_2 + xbin_3+ xbin_4;
 xbin1 = (xbin_1/normalizer);
 xbin2 = (xbin_2/normalizer);
 xbin3 = (xbin_3/normalizer);
 xbin4 = (xbin_4/normalizer);



%have to think creatively about y'all so for now take out


%feature1 = mean2(f1)*10;

%second feature the vertical edges of the image (useful for 1,4,5,7?)
gy= [-1 -2 -1; 0 0 0; 1 2 1];
f2 = conv2(gy,bounding_box);
hist2 = histogram(f2,4);
ybin_1 = hist2.Values(1);
ybin_2 = hist2.Values(2);
ybin_3 = hist2.Values(3); %0s here
ybin_4 = hist2.Values(4);
y_normalizer = ybin_1 + ybin_2 + ybin_3+ ybin_4;
ybin1 = (ybin_1/y_normalizer);
ybin2 = (ybin_2/y_normalizer);
ybin3 = (ybin_3/y_normalizer);
ybin4 = (ybin_4/y_normalizer);


%horizontal and vertical edges of the image 
gxy = [1 1 0;1 0 -1;0 -1 -1];
f2_2 = abs(conv2(gxy,Ic));
feature2_1 = mean2(f2_2);


%sixth feature variance of number of black pixels in rows  
variance_row = var(Ic,1,2);
f6 = var(variance_row, 1, "all")*10;


%seventh feature variance of number of black pixels in columns
variance_col = var(Ic,1,1);
f7 = var(variance_col, 1, "all")*10;

%eight feature variance of entire image at the same time
f8 = var(Ic,1,'all')*10;


perimeter = bwperim(Ic);
per = (sum(perimeter,"all"))/(2* (width+height));


%trying to find the longest line

% longest vertical line
line = 0;
lines = [];
longest_line = zeros(column,1); %zeros(140,1)
for i = 1:column   %i = 1:140
    for j = 1:row    %j = 1:28
        if Ic(j,i) == 1     %Ic(j,i) == 1 j+y_start,i+x_start cuz y operates down rows and x operates across columns
            line = line+1;                  %same logic used in normalizing position hpos and vpos   % Ic(j+y_start-1,i+x_start-1) == 1
        else
            lines = [lines, line];
            line = 0;
        end 
    end 
    if isempty(lines)
        longest_line(i) = 0;
    else
        longest_line(i) = max(lines);
    end
    lines = 0;
end 
[vertical, pos] = max(longest_line);
vertical = vertical/height; %scaled using height
vpos = pos-x_start/width; %but the position scaled using x_start and x_end and x_end - x_start = width anyway


% longest horizontal line
line2 = 0;
lines2 = [];
longest_line2 = zeros(row,1);    %zeros(28,1);
noOfLinesinRow = zeros(row,1);       %zeros(28,1);
for i = 1:row        %i = 1:28
    for j = 1:column       %j = 1:140
        if Ic(i,j) == 1         %Ic(i+y_start-1,j+x_start-1) == 1
            line2 = line2+1;
        else
            if line2 > 0
                lines2 = [lines2, line2];
            end 
            line2 = 0;
        end 
    end 
    if numel(lines2) > 0
        longest_line2(i) = max(lines2);
        noOfLinesinRow(i) = numel(lines2); 
        lines2 = 0;
    end 
end 
[horizontal, pos2] = max(longest_line2);
horizontal = horizontal /width; %min max doesn't work for other datasets i'm a clown so normalizing with width
hpos = pos2-y_start/height; %position scaled using y_start and y_end - y_start = height so used directly



 %because it's messy to use nrow/2 directly could be double
% because noOfLinesinRow was created as zeros(nrow,1); nrow is its dimension
top_half  = noOfLinesinRow(1:half,1);         %noOfLinesinRow(1:14,1);
bottom_half = noOfLinesinRow(half:row,1); %noOfLinesinRow(15:28,1);

% top_half  = noOfLinesinRow(1:(half+y_start),1);         %noOfLinesinRow(1:14,1);
% bottom_half = noOfLinesinRow((half+y_start):(numel(noOfLinesinRow)),1); %noOfLinesinRow(15:28,1);


top_d1 = 0;
top_d2 = 0;
for i = 1:half
    if top_half(i) == 1
        top_d1 = top_d1 +1;
    elseif top_half(i) > 1
        top_d2 = top_d2 +1;
    end
end

if (top_d1>2)
    top_d1 = top_d1/(height/2);
end

if (top_d2>2)
    top_d2 = top_d2/(height/2); %scaled by what half of no. of rows of bounding box is
end


bottom_d1 = 0;
bottom_d2 = 0;
for i = 1:half
    if bottom_half(i) == 1
        bottom_d1 = bottom_d1 +1;
    elseif bottom_half(i) > 1
        bottom_d2 = bottom_d2 +1;
    end
end

if (bottom_d1>2)
    bottom_d1 = bottom_d1/half;
else
    bottom_d1 = bottom_d1;
end

if (bottom_d2>2)
    bottom_d2 = bottom_d2/half; %scaled by what half of no. of rows of bounding box is
end




% inverse of I, take bwlabel of that. that'll give me the holes in the
% image. if it's 2 then that's an 8 and so on.
% you calculated the max width; which row its on. if its on the lower side
% then 5, works


inverse = ~Ic;
[~ ,conn] = bwlabel(inverse);
% conn = (conn-1)/(3-1);

pixel_count_at_col_center = sum(bounding_box(:, col_half))/height;
pixel_count_at_col_center2 = sum(bounding_box(:, round(col_half/2)))/height;
pixel_count_at_col_center3 = sum(bounding_box(:, round(col_half/4*3)))/height;
pixel_count_at_row_center = sum(bounding_box(row_half, :))/width;
pixel_count_at_row_center2 = sum(bounding_box(round(row_half/2), :))/width;
pixel_count_at_row_center3 = sum(bounding_box(round(nrow/4*3), :))/width;
stats = regionprops(bounding_box, 'Eccentricity', 'Extent', 'EulerNumber', 'Solidity', 'Area', 'Perimeter');
perimeter = stats.Perimeter;
area = stats.Area;
compactness = (perimeter .^ 2) ./ (4 * pi * area);

features = [conn pixel_count_at_col_center pixel_count_at_col_center2 pixel_count_at_col_center3 pixel_count_at_row_center pixel_count_at_row_center2 pixel_count_at_row_center3 width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% 16.7% I give up features = [conn horizontal vertical hpos vpos top_d1 top_d2 bottom_d1 bottom_d2 xbin1 xbin2 xbin3 xbin4 ybin1 ybin2 ybin3 ybin4 feature2_1 f6 f7 f8 width height width/height per ratio];


% 15.1% features = [xbin1 xbin2 xbin3 xbin4 ybin1 ybin2 ybin3 ybin4 width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% 24.7% features = [xbin1 xbin2 xbin3 xbin4 ybin1 ybin2 ybin3 ybin4 pixel_count_at_col_center pixel_count_at_col_center2 pixel_count_at_col_center3 pixel_count_at_row_center pixel_count_at_row_center2 pixel_count_at_row_center3 width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% final features = [conn pixel_count_at_col_center pixel_count_at_col_center2 pixel_count_at_col_center3 pixel_count_at_row_center pixel_count_at_row_center2 pixel_count_at_row_center3 width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% 41.8% features = [horizontal vertical conn ratio_right ratio_left pixel_count_at_col_center pixel_count_at_row_center pixel_count_at_row_center3 ratio width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% 32.1% features = [horizontal vertical conn ratio_right ratio_left ratio width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% 27.7% features = [ratio_top ratio_bottom ratio_right ratio_left ratio width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% 43.8% features = [pixel_count_at_col_center pixel_count_at_row_center pixel_count_at_row_center3 width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% 43.7% features = [pixel_count_at_col_center pixel_count_at_col_center2 pixel_count_at_col_center3 pixel_count_at_row_center pixel_count_at_row_center2 pixel_count_at_row_center3 width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% 35% features = [conn horizontal vertical width/height stats(1).Eccentricity stats(1).Extent stats(1).EulerNumber stats(1).Solidity compactness/5];

% features = [ratio_right ratio_left ratio_bottom ratio_top conn horizontal vertical hpos vpos top_d1 top_d2 bottom_d1 bottom_d2 per f6 f7 f8 feature2_1 xbin1 xbin2 xbin4 ybin1 ybin2 ybin4 ratio width/height];

% 18.2% features = [conn conn^2 horizontal horizontal^2 vertical vertical^2 hpos vpos top_d1 top_d1^2 top_d2 bottom_d1 bottom_d1^2 bottom_d2 xbin1 xbin2 xbin4 ybin1 ybin2 ybin4 feature2_1 f6 f7 f8 f10 width height];

% com_left com_right com_bottom com_top
end