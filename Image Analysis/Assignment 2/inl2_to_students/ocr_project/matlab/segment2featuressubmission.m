function features = segment2features(I)

%first step; filter the image to remove noise; I'll use a median filter
If= medfilt2(I);

%second step; centering the image
% Find centroid.
props = regionprops(If, 'Centroid');
% Translate the image.
xt = props.Centroid(1);
yt = props.Centroid(2);
% Get center of image
[rows, columns] = size(If);
xc = columns/2;
yc = rows/2;
deltax = xc - xt;
deltay = yc - yt;
Ic = imtranslate(If,[deltax deltay],'FillValues', 0);

%first feature the horizontal edges of the image
gx= [1 0 -1; 2 0 -2; 1 0 -1];
f1 = abs(conv2(gx,Ic));
feature1 = mean2(f1);

%second feature the vertical edges of the image
gy= [-1 -2 -1; 0 0 0; 1 2 1];
f2 = abs(conv2(gy,Ic));
feature2 = mean2(f2)*10;

%horizontal and vertical edges of the image 
gxy = [1 1 0;1 0 -1;0 -1 -1];
f2_2 = abs(conv2(gxy,Ic));
feature2_1 = mean2(f2_2);

%third feature gotten from harris corners
corners = detectHarrisFeatures(Ic);
feature3 = length(corners)/14;

%fourth feature sum along columns
sum_along_1= sum(Ic,1);
sum_1 = sparse(sum_along_1);
f4_1 = sum(sum_1(61:70))/121;
f4_2 = sum(sum_1(71:80))/108;
f4_3 = mean(sum_along_1,"all")/1.6;

%fifth feature sum along rows
sum_along_2= sum(Ic,2);
sum_2 = sparse(sum_along_2);
f5_1 = sum(sum_2(1:14))/123;
f5_2 = sum(sum_2(15:28))/106;
f5_3 = mean(sum_along_2, "all")/8;

%sixth feature variance of number of black pixels in rows  
variance_row = var(Ic,1,2);
f6 = var(variance_row, 1, "all")*1000;

%seventh feature variance of number of black pixels in columns
variance_col = var(Ic,1,1);
f7 = var(variance_col, 1, "all")*100;

%eight feature variance of entire image at the same time
f8 = var(Ic,1,'all')*10;

f9 = bwarea(Ic)/289;

perimeter = bwperim(Ic);
f10 = (sum(perimeter,"all"))/90;

props = regionprops(Ic,'all');
width = props.BoundingBox(3)/16;
height = props.BoundingBox(4)/22;
convex_area = props.ConvexArea/278;
diameter = props.EquivDiameter/14;
feret1 = props.MaxFeretDiameter/24; 
feret2 = props.MinFeretDiameter/14;

features = [feature1 feature2 feature2_1 feature3 f4_1 f4_2 f4_3 f5_1 f5_2 f5_3 f6 f7 f8 f9 f10 width height diameter feret1 feret2 convex_area];
