function classification_data = class_train(X, Y)

% IMPLEMENT TRAINING OF YOUR CHOSEN MACHINE LEARNING MODEL HERE
% Trying this out for nearest neighbour


% nxr = size(X,2);
% nxc =size(X,1);
% ny = size(Y,2);

classification_data = cell(1,2);
classification_data{1} = X;
classification_data{2} = Y;

%     for i = 1:ny
%         classification_data{1}(i) = X(:,i);
%         classification_data{2}(i) = Y(i);
%     end


