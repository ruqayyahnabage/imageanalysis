datadir = '../datasets/short1';

a = dir(datadir);

file = 'im2';

fnamebild = [datadir filesep file '.jpg'];
fnamefacit = [datadir filesep file '.txt'];

bild = imread(fnamebild);
fid = fopen(fnamefacit);
facit = fgetl(fid);
fclose(fid);

S = im2segment(bild);
B = S{4};
x = segment2features(B);
disp(size(x));

