function [up,r] = projection(u,e1,e2,e3,e4)
up = (imgdot(u,e1)*e1)+(imgdot(u,e2)*e2)+(imgdot(u,e3)*e3)+(imgdot(u,e4)*e4);
r = norm((u-up), 'fro');
