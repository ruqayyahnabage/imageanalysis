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

%ratio of width to height
ratio = width/height;

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

% dividing the image-bounding box
bounding_box = Ic(y_start:y_end,x_start:x_end);
top = Ic(y_start:y_start+row_half,x_start:x_end);
bottom = Ic(y_start+row_half:y_end,x_start:x_end);
left = Ic(y_start:y_end,x_start:x_start+col_half);
right = Ic(y_start:y_end,x_start+col_half:x_end);

[Gx, Gy] = imgradient(bounding_box,'sobel');
magnitude = norm(Gx+Gy);
% magnitude = sqrt(Gx.^2 + Gy.^2);
dir = atan2(Gy, Gx);
direction = mean(dir(:));

[Gx1, Gy1] = imgradient(top,'sobel');
% mag1 = sqrt(Gx1.^2 + Gy1.^2);
mag1 = norm(Gx1+Gy1);
dir1 = atan2(Gy1, Gx1);
direction1 = mean(dir1(:));


[Gx2, Gy2] = imgradient(bottom,'sobel');
% mag2 = sqrt(Gx2.^2 + Gy2.^2);
mag2 = norm(Gx2+Gy2);
dir2 = atan2(Gy2, Gx2);
direction2 = mean(dir2(:));

[Gx3, Gy3] = imgradient(left,'sobel');
% mag3 = sqrt(Gx3.^2 + Gy3.^2);
mag3 = norm(Gx3+Gy3);
dir3 = atan2(Gy3, Gx3);
direction3 = mean(dir3(:));

[Gx4, Gy4] = imgradient(right,'sobel');
% mag4 = sqrt(Gx4.^2 + Gy4.^2);
mag4 = norm(Gx4+Gy4);
dir4 = atan2(Gy4, Gx4);
direction4 = mean(dir4(:));


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

vertical_center = sum(bounding_box(:, col_half))/height;
vertical_quarter = sum(bounding_box(:, round(col_half/2)))/height;
vertical_3quarter = sum(bounding_box(:, round(col_half/4*3)))/height;
horizontal_center = sum(bounding_box(row_half, :))/width;
horizontal_quarter = sum(bounding_box(round(row_half/2), :))/width;
horizontal_3quarter = sum(bounding_box(round(nrow/4*3), :))/width;

% regionprops features
stats = regionprops(bounding_box, 'Eccentricity', 'Extent', 'EulerNumber', 'Solidity', 'Area', 'Perimeter');
perimeter = stats.Perimeter;
area = stats.Area;
eccentricity = stats.Eccentricity;
extent = stats.Extent;
enum = stats.EulerNumber;
solidity = stats.Solidity;
compactness = ((perimeter .^ 2) ./ (4 * pi * area))/5;

% no. of holes in image
inverse = ~Ic;
[~ ,conn] = bwlabel(inverse);

features = [magnitude, direction, mag1, direction1, mag2, direction2, mag3, direction3, mag4, direction4];

% features = [conn com_left com_right com_bottom com_top vertical_center vertical_quarter vertical_3quarter horizontal_center horizontal_quarter horizontal_3quarter ratio eccentricity extent enum solidity compactness];