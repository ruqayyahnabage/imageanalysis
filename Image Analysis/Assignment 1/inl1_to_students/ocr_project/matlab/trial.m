%% Get the directory of a dataset

datadir = '../datasets/short1';
a = dir(datadir);

%% Select a filename
file = 'im2'

%% Generate filename with path and extension
fnamebild = [datadir filesep file '.jpg']
fnamefacit = [datadir filesep file '.txt']

%% Read an image and convert to double
bild = double(imread(fnamebild));
%% Run your segmentation code
S = im2segment(bild);
