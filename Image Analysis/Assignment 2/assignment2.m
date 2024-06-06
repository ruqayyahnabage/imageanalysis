image = imread("image1.jpeg");
image = double(image)/255;
imagesc(image)
colormap(gray)
image = rgb2gray(image);
f1 = (1/3)* [1 1 0; 1 0 -1; 0 -1 -1];
f2 = (1/25) * [1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1;1 1 1 1 1];
f3= [0 -1 0; -1 5 -1;0 -1 0];
f4 = [0 0 0;0 1 0;0 0 0];
f5 = [1 -2 1];

filter1 = conv2(image, f1);
imagesc(filter1)
%% 2a
f = [3 4 7 4 3 5 6 12];
plot(f,'-o');
%% 2c
x = -3;
result = [];
for x = -3:0.1:3
    if abs(x) <= 1
        g = cos((pi/2)*x);
        result = [result g];
    elseif (1 < abs(x)) && (abs(x) <= 2)
        g = -(pi/2)*(abs(x)^3 - 5*abs(x)^2 + 8 *abs(x) -4);
        result = [result g];
    else
        g = 0;
        result = [result g];
    end
end

plot([-3:0.1:3],result, '-o')
%% 2d Fg(x) for 1 to 8

f = [3 4 7 4 3 5 6 12];
f_g = [];

for x = 1:0.1:8
    f_ix = [];
    for i = 1:8
        if abs(x-i) <= 1
            g = cos((pi/2)*(x-i)) * f(i);
            f_ix = [f_ix g];
        elseif (1 < abs(x-i)) && (abs(x-i) <= 2)
            g = (-(pi/2)*(abs(x-i)^3 - 5*abs(x-i)^2 + 8 *abs(x-i) -4))*f(i);
            f_ix = [f_ix g];
        else
            g = 0;
        end
    end
    g_sum = sum(f_ix);
    f_g = [f_g g_sum];
end 
plot([1:0.1:8],f_g, '-o')
%% 3a Nearest Neighbour
class = [0.4003 0.3988 0.3998 0.3997;
    0.2554 0.3139 0.2627 0.3802;
    0.5632 0.7687 0.0524 0.7586];

test = [0.4010 0.3995 0.3991;
0.3287 0.3160 0.2924;
0.4243 0.5005 0.6769];

minimum = zeros(3);
for i = 1:9
    %testing for minimum of test i
    closest = 20;
    sample = test(i);
    for c = 1:9
        dist = abs(sample - class(c));
        if dist < closest
            closest = dist;
            minimum(i) = c;
        end 
    end 
end
for i = 1:9
    if minimum(i) == 1 || minimum(i) == 4 || minimum(i) == 7|| minimum(i) == 10
        minimum (i) = 1;
    elseif minimum(i) == 2 || minimum(i) == 5 || minimum(i) == 8 || minimum(i) == 11
        minimum (i) = 2;
    else 
        minimum(i) = 3;
    end 
end 

disp(minimum)
%% 3.2 Gaussian distrubution
%each individual element of x will have its own probability & it's own p(y=j|x) and subsequently its class and i don't
%need to know what each is except the class
% baye's formula is p(y=j|x) = p(x|y=j)*p(y=j) / p(x) 
% p(x) = summation of p(x|y=j)*p(y=j) for all values of j 
%side note: p(x) is a normaliser that's why i was getting values above 1
%when i ran y1,y2,y3 by themselves and also that's why it's a summation

% defining the prior p(y=j) for each 3 class to be 1/3 since each class is likely
% to occur
p1 = 1/3;
p2 = 1/3;
p3 = 1/3;

x_values = [0.4003 0.3988 0.3998 0.3997 0.4010 0.3995 0.3991
0.2554 0.3139 0.2627 0.3802 0.3287 0.3160 0.2924
0.5632 0.7687 0.0524 0.7586 0.4243 0.5005 0.6769];

%creating variable to store predictions
y_predict = zeros(size(x_values));

%p(x|y=1) i.e prob that it's class 1
    y1 = normpdf(x_values,0.4,0.01);

    %p(x|y=2) i.e prob that it's class 2
    y2 = normpdf(x_values, 0.32, 0.05);

    %p(x|y=3) i.e prob that it's class 3
    y3 = normpdf(x_values, 0.55, 0.2);

    %the denominator as stated above
    px = y1.*p1 + y2.*p2 + y3.*p3

    py_1 = y1.*p1./px;
    py_2 = y2.*p2./px;
    py_3 = y3.*p3./px;

for i = 1:21
    
    %this wahala is to see the max
    %pys = [py_1,py_2, py_3]

    %max_posterio = zeros("like", x_values);
    %max_posterio(i)= max(pys);
    %disp(max(max_posterio))
    %end max wahala back to real function
%end
    if py_1(i) > py_2(i) && py_1(i) > py_3(i)
        y_predict(i) = 1;
    elseif py_2(i) > py_1(i) && py_2(i) > py_3(i)
        y_predict(i) = 2;
    elseif py_3(i) > py_1(i) && py_3(i) > py_2(i)
        y_predict(i) = 3;
    end 
end 
disp(y_predict)
%disp(reshape(y_predict,[7,3]))
%disp(max(max_posterio))








