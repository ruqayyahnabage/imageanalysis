% REPLACE WITH YOUR OWN FUNCTION

function y = features2class(x, classification_data)

n = size(classification_data{2},2);
    dist = zeros(1,n);
    for i = 1: n
%  % find the distance between x and every 'i' of the classification data)
%  % find the min, what's the label of that min distance
        dist(i) = norm((x - classification_data{1}(:,i)));
    end
    [~, column] = min(dist);
    y = classification_data{2}(column);
