
function [p_ls,error] = tls(xm,ym)
N = length(xm);
% creating a 2x2 matrix that has the eigen value solution from slide 24 lec10
A = zeros(2);
A(1) = sum((xm.^2)) - (1/N)* (sum(xm))^2;
A(2) = sum(xm.*ym) - (1/N) * sum(xm) *sum(ym);
A(3) = A(2);
A(4) = sum((ym.^2)) - (1/N)* (sum(ym))^2;
%a_b has a in the row 1, and b in row 2
[a_b,~] = eig(A);
a = [a_b(1,:)];
b = [a_b(2,:)];

c = zeros(1,2);
c(1) = (-1/N)* (a(1)*sum(xm) + b(1)*sum(ym));
c(2) = (-1/N)* (a(2)*sum(xm) + b(2)*sum(ym));

% errors; to see which is the min and which is the max
error1 = zeros(1,N);
error2 = zeros(1,N);
for i = 1:N
    error1(i) = (a(1)*xm(i) + b(1)*ym(i) + c(1))^2;
    error2(i) = (a(2)*xm(i) + b(2)*ym(i) + c(2))^2;
    
end
sum_error1 = sum(error1);
sum_error2 = sum(error2);

p_ls = zeros(2,1);

% assigning the set with min error as p_ls
if sum_error1 < sum_error2
    p_ls(1) = -a(1)/b(1);
    p_ls(2) = -c(1)/b(1);
    error = sum_error1;
elseif sum_error1 > sum_error2
    p_ls(1) = -a(2)/b(2);
    p_ls(2) = -c(2)/b(2);
    error = sum_error2;
end

end
