function myerrorbar(x, y, u, t)
% function myerrorbar(x, y, u, t)

line([x x], [y y+u]);
line([x-t x+t], [y+u y+u]);
