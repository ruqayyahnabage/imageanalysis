% Task 4: Fit lines to data points, using total least squares and 
% RANSAC + total least squares

% Clear up
clc;
close all;
clearvars;

% Begin by loading data points from linedata.mat
load linedata

N = length(xm); % number of data points


% Fit a line to these data points with total least squares
% Here you should write code to obtain the p_tls coefficients (assuming the
% line has the form y = p_ls(1) * x + p_ls(2)).

[p_tls, tls_error] = tls(xm,ym);
ls_error = lsError(xm,ym,p_tls);

% Plot data
x_fine = [min(xm)-0.05,max(xm)+0.05]; % used when plotting the fitted lines
xlabel('x') 
ylabel('y')
title('Plot of TLS line and RANSAC') % OBS - CHANGE TITLE!
plot(x_fine, p_tls(1) * x_fine + p_tls(2), 'blue','LineStyle', '--')

hold on 
%%
% Fit a line to these data points using RANSAC and total least squares on the inlier set.
distances = zeros(N,1);
threshold = 1.5;
bestModel = []; % Initialize the best model
noBestInliers = 0; % Initialize the number of inliers for the best model
noIterations = 10000;

for i = 1:noIterations % (no. of iterations) randomly choose 2 points by randomly generating an index and
    % assigning the value from the index of xm and ym

    sampleIndices = randperm(size(xm, 1), 2);
    x = xm(sampleIndices, :);
    y = ym(sampleIndices, :);

    % now to fit them to a straight line model

     a = y(2) - y(1)/x(2) - x(1);
     c = y(1) - a * x(1); 
     line = [a,c];

    % Find inliers (points that fit that particular model)
    for j = 1:N  % (since we're sampling 2 data points, check error for remaining 38 points in xm and ym)
        distances(j) = abs((a*xm(j)) + (-1*ym(j)) + c)/sqrt(a^2 + (-1)^2);
    end

    inliers_index = find(distances < threshold);

% If the current model has more inliers than the best model so far, update it

    if numel(inliers_index) > noBestInliers
        bestModel = line;
        noBestInliers = numel(inliers_index);
        bestInliers = inliers_index;
        x_inliers = xm(inliers_index);
        y_inliers = ym(inliers_index);
    end
    
end

% now fit a line with the best inliers
[p_ransac, ransac_error] = tls(x_inliers,y_inliers);
ransac_ls_error = lsError(x_inliers, y_inliers,p_ransac);

 STR = [" ", "TLS Line" "RANSAC Line"; 
     "TLS Errors" tls_error ransac_error; 
     "LS Errors" ls_error ransac_ls_error];
 disp(STR);
 size(bestInliers)

plot(x_fine, p_ransac(1) * x_fine + p_ransac(2),'color','#A2142F');
hold on

plot(x_inliers, y_inliers,'r*'); hold on;

 x_outliers = ones(40,1);
 x_outliers(bestInliers) = 0;
 x_outliers = xm(x_outliers == 1);
 
 y_outliers = ones(40,1);
 y_outliers(bestInliers) = 0;
 y_outliers = ym(y_outliers == 1);

plot(x_outliers, y_outliers, 'bo'); 

%% 







% REMOVE AND REPLACE WITH TOTAL LEAST SQUARES SOLUTION





% Legend --> show which line corresponds to what (if you need to
% re-position the legend, you can modify rect below)
h=legend('least-squares','RANSAC','Inliers', 'Outliers');
rect = [0.20, 0.65, 0.25, 0.25];
set(h, 'Position', rect)


% After having plotted both lines, it's time to compute errors for the
% respective lines. Specifically, for each line (the total least squares and the
% RANSAC line), compute the least square error and the total
% least square error. For the RANSAC solution compute errors on inlier set. 
% Note that the error is the sum of the individual
% squared errors for each data point! In total you should get 4 errors. Report these
% in your report, and comment on the results. OBS: Recall the distance formula
% between a point and a line from linear algebra, useful when computing orthogonal
% errors!

% WRITE CODE BELOW TO COMPUTE THE 4 ERRORS