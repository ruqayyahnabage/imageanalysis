function y = classify(x, classification_data)
% IMPLEMENT YOUR CHOSEN MACHINE LEARNING CLASSIFIER HERE
% 
% % My chosen classifier is a 3 nearest neighbour classifier.
%  
%     n = size(classification_data{2},2);
%     dist = zeros(1,n);
%     for i = 1: n
% % %       % find the distance between x and every 'i' of the classification data)
% % %       % find the min, what's the label of that min
% % %       %distance
%         dist(i) = norm((x - classification_data{1}(:,i)),'fro');
% % %     
%     end
% % %   plot(dist);
% % % %  % sort the dist array and store former positions in ind and get the classes
% % % %  % of the 3 nearest neighbor by checking the index in ind and accessing the
% % % %  % classification from the training data Y which is in classification_data
% % % %  % then an if to count the votes
% % % %  
%    [~,ind] = sort(dist);
% % %   
%    nn1 = classification_data{2}(ind(1));
%    nn2 = classification_data{2}(ind(2));
%    nn3 = classification_data{2}(ind(3));  
%    if (nn1 == nn2) && (nn2 == nn3)
%         y = nn1;
%    elseif (nn1 == nn2) && (nn3 ~= nn2)
%         y = nn1;
%    elseif (nn1 ==nn3) && (nn3 ~= nn2)
%         y = nn1;
%    elseif (nn2 == nn3) && (nn3 ~= nn1)
%         y = nn2;
%    end 




    n = size(classification_data{2},2);
    dist = zeros(1,n);
    for i = 1: n
%  % find the distance between x and every 'i' of the classification data)
%  % find the min, what's the label of that min distance
        dist(i) = norm((x - classification_data{1}(:,i)));
    end
    [~, column] = min(dist);
    y = classification_data{2}(column);
