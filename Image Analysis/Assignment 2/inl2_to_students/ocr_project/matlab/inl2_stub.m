datadir = '../datasets/short1'; % change or check so that you are in the right directory

a = dir(datadir);

file = 'im4';

fnamebild = [datadir filesep file '.jpg'];
fnamefacit = [datadir filesep file '.txt'];

bild = imread(fnamebild);
fid = fopen(fnamefacit);
facit = fgetl(fid);
fclose(fid);

S = im2segment(bild);
B = S{3};
image(bild);
x = segment2features(B);




