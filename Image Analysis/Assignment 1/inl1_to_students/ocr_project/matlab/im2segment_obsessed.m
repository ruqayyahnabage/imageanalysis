function S = im2segment(im)


im = uint8(im); %converting the image into 8 bit

im_f = imgaussfilt(im);
%Thresholding the image
bnd = 45; % set some arbitrary bound on thresholding
im_t = im_f>bnd; % threshold the image
%im_f = medfilt2(im_t); %filter the image to eliminate noise using a median filter

%I want to try it now with dilation before segmentation
% Define the structuring element for dilation (you can adjust its size and shape)
se = strel('disk', 1); % Example: Creates a disk-shaped structuring element with a radius of 1 pixel
% Apply dilation to the segmented image
im_d = imdilate(im_t, se);
L = bwlabel(im_d); % label connected components in image
nrseg = max(L(:)) % find out number of segments
S = cell(1,nrseg); %creating the cell array S
discard = cell(1,10);


for kk = 1:nrseg    %created a for loop to store the different segments in 
    if segment_size >= [5,1]
        S{kk} = (L==kk); %different cells of the array when the index is the same as segment number
    else
        discard{kk} = (L==kk);
    end
end


%  labels =cell(1,nrseg);
%  nr_labels =[];
%  
%  while nrseg > 5
%      for i = 1:nrseg
%          labels{i} = (L == i);
%          nr_labels(i) = nnz(labels{i});
%      end
%      throw = find(nr_labels < 5);
%      labels(:,throw) = [];
%      nr_labels(:,throw) = [];
% 
%      broken = find(nr_labels < 50);
%      broken_size = size(broken,2);
%      
%      if broken_size == 2
%          broken = [broken, 0,0];
%      elseif broken_size == 3
%          broken = [broken,0];
%      end
% 
%      for i = 1:broken_size
%         if i == broken_size
%             break;
%         if (broken(i+1) == broken(i)+1) && (broken(i+2) == broken(i)+2) && (broken(i+3) == broken(i)+3)
%             labels{broken(i)} = labels{broken(i)}+labels{broken(i+1)}+labels{broken(i+2)}+labels{broken(i+3)};
%             delete = [broken(i+1),broken(i+2),broken(i+3)];
%             labels(:, delete) = [];
%             nrseg = nrseg-3;
%             broken_size = broken_size - 3;
%             broken(:,[i+1,i+2,i+3]) = 0;
%             if nrseg == 5
%                 break;
%             end
%         elseif (broken(i+1) == broken(i)+1) && (broken(i+2) == broken(i)+2)
%             labels{broken(i)} = labels{broken(i)}+labels{broken(i+1)}+labels{broken(i+2)};
%             delete = [broken(i+1),broken(i+2)];
%             labels(:, delete) = [];
%             nrseg = nrseg-2;
%             broken_size = broken_size - 2;
%             broken(:,[i+1,i+2]) = 0;
%             if nrseg == 5
%                 break;
%             end
%         if (broken(i+1) == broken(i)+1)
%             labels{broken(i)} = labels{broken(i)}+labels{broken(i+1)};
%             delete = broken(i+1);
%             labels(:,delete) = [];
%             nrseg = nrseg-1;
%             broken_size = broken_size - 1;
%             broken(:,i+1) = 0;
%             if nrseg == 5
%                 break;
%             end
%         end
%      
%      end
%      
%  end 
%  
%  %nrseg = 5;
%  S = cell(1,nrseg); %creating the cell array S
%  
%  if initialnrseg > 5
%      for i = 1:5
%         S{i} = labels{i};
%      end 
%  
%  else
%      for kk = 1:5    %created a for loop to store the different segments in 
%          S{kk} = (L==kk); %different cells of the array when the index is the same as segment number
%      end
%  end
