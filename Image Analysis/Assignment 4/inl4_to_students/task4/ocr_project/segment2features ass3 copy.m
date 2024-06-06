function features = segment2features(If)

%first step; filter the image to remove noise; I'll use a median filter
%If= medfilt2(I);

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


% divide an image into 4 quadrants; take the magnitude and angle of each
% quadrant
%first feature the horizontal edges of the image (useful for 1,4,5,7?)


gx= [1 0 -1; 2 0 -2; 1 0 -1];
f1 = conv2(gx,Ic);
hist = histogram(f1,4);
xbin1 = (hist.Values(1) - 23)/(63-23);
xbin2 = (hist.Values(2) - 24)/(131-24);
xbin3 = hist.Values(3); %0s so not used
xbin4 = (hist.Values(4)-22)/(58-22);



%feature1 = mean2(f1)*10;

%second feature the vertical edges of the image (useful for 1,4,5,7?)
gy= [-1 -2 -1; 0 0 0; 1 2 1];
f2 = conv2(gy,Ic);
hist2 = histogram(f2,4);
ybin1 = (hist2.Values(1) -9)/(62-9);
ybin2 = (hist2.Values(2) - 26)/(121-26);
ybin3 = hist2.Values(3); %0s here
ybin4 = (hist2.Values(4)-10)/(63-10);



%horizontal and vertical edges of the image 
gxy = [1 1 0;1 0 -1;0 -1 -1];
f2_2 = abs(conv2(gxy,Ic));
feature2_1 = mean2(f2_2)*10;


%sixth feature variance of number of black pixels in rows  
variance_row = var(Ic,1,2);
f6 = var(variance_row, 1, "all")*1000;


%seventh feature variance of number of black pixels in columns
variance_col = var(Ic,1,1);
f7 = var(variance_col, 1, "all")*100;

%eight feature variance of entire image at the same time
f8 = var(Ic,1,'all')*10;


perimeter = bwperim(Ic);
f10 = (sum(perimeter,"all"))/90;

props = regionprops(Ic,'all');
box = props.BoundingBox;
width = box(1,3)/16;
height = box(1,4)/22;

%trying to find the longest line

% longest vertical line
line = 0;
lines = [];
longest_line = zeros(140,1);
for i = 1:140
    for j = 1:28
        if Ic(j,i) == 1
            line = line+1;
        else
            lines = [lines, line];
            line = 0;
        end 
    end 
    longest_line(i) = max(lines);
    lines = 0;
end 
[vertical, pos] = max(longest_line);
vertical = (vertical - 5)/(19-5); %min max scaling of longest vertical line
vpos = (pos - 63)/(76-63); %min max scaling of position of longest vertical line


% longest horizontal line
line2 = 0;
lines2 = [];
longest_line2 = zeros(28,1);
noOfLinesinRow = zeros(28,1);
for i = 1:28
    for j = 1:140
        if Ic(i,j) == 1
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
horizontal = (horizontal - 4)/(14-4); %min max scaling of longest horizontal line
hpos = (pos2-5)/(22-5); %min max scaling of position of longest horizontal line

% dividing into two halves
top_half  = noOfLinesinRow(1:14,1);
bottom_half = noOfLinesinRow(15:28,1);

top_d1 = 0;
top_d2 = 0;
for i = 1:14
    if top_half(i) == 1
        top_d1 = top_d1 +1;
    elseif top_half(i) > 1
        top_d2 = top_d2 +1;
    end
end

% top_d1 only has 0 and 1 as values. thinking of scaling by 0.5 to reduce
% effect?
 top_d2 = (top_d2 - 5)/(12-5); %min max scaling


bottom_d1 = 0;
bottom_d2 = 0;
for i = 1:14
    if bottom_half(i) == 1
        bottom_d1 = bottom_d1 +1;
    elseif bottom_half(i) > 1
        bottom_d2 = bottom_d2 +1;
    end
end

 bottom_d1 = (bottom_d1 - 1)/(9-1); %min max scaling
 bottom_d2 = (bottom_d2 - 5)/(13-5);

% inverse of I, take bwlabel of that. that'll give me the holes in the
% image. if it's 2 then that's an 8 and so on.
% you calculated the max width; which row its on. if its on the lower side
% then 5, works


inverse = ~Ic;
[~ ,conn] = bwlabel(inverse);
conn = (conn-1)/(3-1);


features = [conn conn^2 horizontal horizontal^2 vertical vertical^2 hpos vpos top_d1 top_d1^2 top_d2 bottom_d1 bottom_d1^2 bottom_d2 xbin1 xbin2 xbin4 ybin1 ybin2 ybin4 feature2_1 f6 f7 f8 f10 width height];

