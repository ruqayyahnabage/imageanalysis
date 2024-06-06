%% 8. Image Bases
%I've divided the code into sections. This first section runs the iterations.

%first iteration with test set 1 & base 1, the notation for this iteration
%is "11". i.e the projected image is proj11, the error is r11 the sum of
%means is r_sum11 and the mean error is r_mean11. the same notation will be
%used for all iterations.

%init
proj11 = cell(1,400);   %created a 1x400 cell array to store the resulting projections in
r_sum11 = 0;
for imnr = 1:400
    [proj11{imnr}, r11] = projection(stacks{1}(:,:,imnr),bases{1}(:,:,1),bases{1}(:,:,2),bases{1}(:,:,3),bases{1}(:,:,4));
    r_sum11 = r_sum11 + r11;
end
r_mean11 = r_sum11/400

%second iteration with test set 1 & base 2, notation: "12" 
proj12 = cell(1,400);   %created a 1x400 cell array to store the resulting projections in
r_sum12 = 0;
for imnr = 1:400
    [proj12{imnr}, r12] = projection(stacks{1}(:,:,imnr),bases{2}(:,:,1),bases{2}(:,:,2),bases{2}(:,:,3),bases{2}(:,:,4));
    r_sum12 = r_sum12 + r12;
end
r_mean12 = r_sum12/400

%third iteration with test set 1 & base 3, notation: "13" 
proj13 = cell(1,400);   %created a 1x400 cell array to store the resulting projections in
r_sum13 = 0;
for imnr = 1:400
    [proj13{imnr}, r13] = projection(stacks{1}(:,:,imnr),bases{3}(:,:,1),bases{3}(:,:,2),bases{3}(:,:,3),bases{3}(:,:,4));
    r_sum13 = r_sum13 + r13;
end
r_mean13 = r_sum13/400

%fourth iteration with test set 2 & base 1, notation: "21" 
proj21 = cell(1,400);   %created a 1x400 cell array to store the resulting projections in
r_sum21 = 0;
for imnr = 1:400
    [proj21{imnr}, r21] = projection(stacks{2}(:,:,imnr),bases{1}(:,:,1),bases{1}(:,:,2),bases{1}(:,:,3),bases{1}(:,:,4));
    r_sum21 =r_sum21 + r21;
end
r_mean21 = r_sum21/400

%fifth iteration with test set 2 & base 2, notation: "22"
proj22 = cell(1,400);   %created a 1x400 cell array to store the resulting projections in
r_sum22 = 0;
for imnr = 1:400
    [proj22{imnr}, r22] = projection(stacks{2}(:,:,imnr),bases{2}(:,:,1),bases{2}(:,:,2),bases{2}(:,:,3),bases{2}(:,:,4));
    r_sum22 = r_sum22 + r22;
end
r_mean22 = r_sum22/400

%sixth iteration with test set 2 & base 3, notation: "23"
proj23 = cell(1,400);   %created a 1x400 cell array to store the resulting projections in
r_sum23 = 0;
for imnr = 1:400
    [proj23{imnr}, r23] = projection(stacks{2}(:,:,imnr),bases{3}(:,:,1),bases{3}(:,:,2),bases{3}(:,:,3),bases{3}(:,:,4));
    r_sum23 = r_sum23 + r23;
end
r_mean23 = r_sum23/400

%% This section has plots of some random images from the two test sets before projection

% Plot of image 28 from set 1.
subplot(3,2,1)
image(stacks{1}(:,:,89))
title('Image 28 from Test Set 1')

% Plot of image 28 from set 2.
subplot(3,2,2)
image(stacks{2}(:,:,89))
title('Image 28 from Test Set 2')

% Plot of image 10 from set 1 before projection.
subplot(3,2,3)
image(stacks{1}(:,:,10))
title('Image 10 from Test Set 1')

% Plot of image 10 from set 2 before projection.
subplot(3,2,4)
image(stacks{2}(:,:,10))
title('Image 10 from Test Set 2')

% Plot of image 200 from set 1 before projection.
subplot(3,2,5)
image(stacks{1}(:,:,200))
title('Image 200 from Test Set 1')

% Plot of image 200 from set 2 before projection.
subplot(3,2,6)
image(stacks{2}(:,:,200))
title('Image 200 from Test Set 2')
%% This section has the plots of sample images before projection, and after on the different bases.
% To illustrate the differences clearly, I am displaying the image at the
% same index in both sets and also these same 2 images onto the different
% bases.

% Plot of image from set 1 before prrojection.
subplot(4,2,1)
image(stacks{1}(:,:,89))
title('Image 89 from Test Set 1')

% Plot of image from set 2 before projection.
subplot(4,2,2)
image(stacks{2}(:,:,89))
title('Image 89 from Test Set 2')

% Plot of image from set 1 projected onto base 1. 
subplot(4,2,3)
image(proj11{89})
title("Image from Test Set 1 Projected onto Base 1")

% Plot of image from set 2 projected onto base 1.
subplot(4,2,4)
image(proj21{89})
title("Image from Test Set 2 Projected onto Base 1")

% Plot of image from set 1 projected onto base 2.
subplot(4,2,5)
image(proj12{89})
title("Image from Test Set 1 Projected onto Base 2")

% Plot of image from set 2 projected onto base 2.
subplot(4,2,6)
image(proj22{89})
title("Image from Test Set 2 Projected onto Base 2")

% Plot of image from set 1 projected onto base 3.
subplot(4,2,7)
image(proj13{89})
title("Image from Test Set 1 Projected onto Base 3")

% Plot of image from set 2 projected onto base 3.
subplot(4,2,8)
image(proj23{89})
title("Image from Test Set 2 Projected onto Base 3")

%% this section plots the basis elements of each base

% Plot of basis element 1 of base 1.
subplot(3,4,1)
imagesc(bases{1}(:,:,1))
title("Basis element 1 of Base 1")

% Plot of basis element 2 of base 1.
subplot(3,4,2)
imagesc(bases{1}(:,:,2))
title("Basis element 2 of Base 1")

% Plot of basis element 3 of base 1.
subplot(3,4,3)
imagesc(bases{1}(:,:,3))
title("Basis element 3 of Base 1")

% Plot of basis element 4 of base 1.
subplot(3,4,4)
imagesc(bases{1}(:,:,4))
title("Basis element 4 of Base 1")

% Plot of basis element 1 of base 2.
subplot(3,4,5)
imagesc(bases{2}(:,:,1))
title("Basis element 1 of Base 2")

% Plot of basis element 2 of base 2.
subplot(3,4,6)
imagesc(bases{2}(:,:,2))
title("Basis element 2 of Base 2")

% Plot of basis element 3 of base 2.
subplot(3,4,7)
imagesc(bases{2}(:,:,3))
title("Basis element 3 of Base 2")

% Plot of basis element 4 of base 2.
subplot(3,4,8)
imagesc(bases{2}(:,:,4))
title("Basis element 4 of Base 2")

% Plot of basis element 1 of base 3.
subplot(3,4,9)
imagesc(bases{3}(:,:,1))
title("Basis element 1 of Base 3")

% Plot of basis element 2 of base 3.
subplot(3,4,10)
imagesc(bases{3}(:,:,2))
title("Basis element 2 of Base 3")

% Plot of basis element 3 of base 3.
subplot(3,4,11)
imagesc(bases{3}(:,:,3))
title("Basis element 3 of Base 3")

% Plot of basis element 4 of base 3.
subplot(3,4,12)
imagesc(bases{3}(:,:,4))
title("Basis element 4 of Base 3")