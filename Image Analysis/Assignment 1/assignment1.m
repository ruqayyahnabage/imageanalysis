s = 5;
H = zeros(s);

x = linspace(0,1,5);
y = linspace(0,1,5);


for c = 1:s
    for r = 1:s
        H(r,c) = x(c) * (1- y(r));
    end
end
A = flipud(H);
%quantization with 32 different gray levels, 0 to 31
A = round(31 * A);
disp(A)
%% 
%3. Neighbourhood of pixels
f = zeros(15);
% copied the values of matrix f
f = [3 3 3 3 3 2 2 2 2 2 3 3 3 3 3; 3 3 1 2 1 0 0 0 0 0 1 2 3 3 3;3 3 2 0 0 0 0 0 0 0 0 0 2 3 3;3 2 0 0 1 0 0 0 0 0 1 0 0 2 3;3 1 0 2 3 1 0 0 0 3 3 1 0 1 3;2 0 0 3 3 2 0 0 1 3 3 2 0 0 2;2 0 0 2 3 1 0 0 0 2 3 1 0 0 2;2 0 0 0 0 0 0 0 0 0 0 0 0 0 2;2 0 0 0 0 0 0 0 0 0 0 0 0 0 2;2 0 1 2 1 1 0 0 0 1 1 2 2 0 2;3 1 0 2 3 3 3 3 3 3 3 3 0 1 3;3 2 0 0 2 3 3 3 3 3 2 0 0 2 3;3 3 2 0 0 2 3 3 3 2 0 0 2 3 3;3 3 3 2 1 0 0 0 0 0 1 2 3 3 3;3 3 3 3 3 2 2 2 2 2 3 3 3 3 3];
% checks for which value is greater than 1, pixel by pixel 
%ta da! your wahala for loop no need
g =  (f>1);
L= bwlabel(g);
disp(L);
%% just did this to study how things are stored in cells
f = [3 3 3 3 3 2 2 2 2 2 3 3 3 3 3; 3 3 1 2 1 0 0 0 0 0 1 2 3 3 3;3 3 2 0 0 0 0 0 0 0 0 0 2 3 3;3 2 0 0 1 0 0 0 0 0 1 0 0 2 3;3 1 0 2 3 1 0 0 0 3 3 1 0 1 3;2 0 0 3 3 2 0 0 1 3 3 2 0 0 2;2 0 0 2 3 1 0 0 0 2 3 1 0 0 2;2 0 0 0 0 0 0 0 0 0 0 0 0 0 2;2 0 0 0 0 0 0 0 0 0 0 0 0 0 2;2 0 1 2 1 1 0 0 0 1 1 2 2 0 2;3 1 0 2 3 3 3 3 3 3 3 3 0 1 3;3 2 0 0 2 3 3 3 3 3 2 0 0 2 3;3 3 2 0 0 2 3 3 3 2 0 0 2 3 3;3 3 3 2 1 0 0 0 0 0 1 2 3 3 3;3 3 3 3 3 2 2 2 2 2 3 3 3 3 3];
n=3;
S = cell(1,n);
for kk = 1:n
    S{kk} = (f==kk);
    S{kk}
end
%% no 7

f= [-2 6 3; 13 7 5; 7 1 8; -3 4 4];
phi1 = 0.5 * [1 0 -1;1 0 -1;0 0 0;0 0 0];
phi2 = (1/3)*[1 1 1;1 0 1; -1 -1 -1;0 -1 0];
phi3 = (1/3)* [0 1 0;1 1 1;1 0 1;1 1 1];
phi4 = (1/2)*[0 0 0;0 0 0;1 0 -1;1 0 -1];

x1 = imgdot(f,phi1)
x2 = imgdot(f,phi2)
x3 = imgdot(f,phi3)
x4 = imgdot(f,phi4)
[fa,error] = projection(f,phi1, phi2,phi3,phi4)