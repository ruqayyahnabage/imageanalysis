% REPLACE WITH YOUR OWN FUNCTION

function y = features2class(x, classification_data)

ycell = predict(classification_data,x.');
 
y = str2double(cell2mat(ycell));

%  y = predict(classification_data,x.');

% ylength = numel(yfit);
% y = zeros(1,ylength);
% for i = 1:ylength
%     y(i) = yfit(:,i);
% end 


end

% n = size(classification_data{2},2);
%     dist = zeros(1,n);
%     for i = 1: n
% %  % find the distance between x and every 'i' of the classification data)
% %  % find the min, what's the label of that min distance
%         dist(i) = norm((x - classification_data{1}(:,i)));
%     end
%     [~, column] = min(dist);
%     y = classification_data{2}(column);
