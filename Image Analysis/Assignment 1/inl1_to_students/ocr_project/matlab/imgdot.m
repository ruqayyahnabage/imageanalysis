function [I] = imgdot(A, B)

I = sum((A.*B),"all");


