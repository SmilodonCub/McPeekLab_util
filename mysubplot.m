function h = mysubplot(rows, cols, row1, col1)
% function mysubplot(rows, cols, row1, col1)

% disp([rows cols row1 col1])

plotpos = (row1-1) .* cols + col1;
h = subplot(rows, cols, plotpos);
return