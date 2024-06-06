% REPLACE WITH YOUR OWN FUNCTION
function classification_data = class_train(X, Y)

%   classification_data = fitcecoc(X.',Y);
 
classification_data = TreeBagger(50,X.',Y.');

% classification_data = cell(1,2);
% classification_data{1} = X;
% classification_data{2} = Y;
% 

