function ystart = raster(train, sizemult, col, ystart, evt, ecol, emarker)% function ystart = raster(train, col, ystart, evt, ecol, emarker)%% for plotting spike rasters:% train - spike train nxm, where m is trials% col - optionally sets color for spike ticks% ystart - optinally sets height of first row of spikes%% returns: ystart - this gives height of next free line in the raster and can be passed in a subsequent call to ras1 to plot new rasters above previous ones.%if nargin < 7    emarker = 'square';endif nargin < 6    ecol = 'k';endif nargin < 4	ystart = 1;endif nargin < 3	col = 'k';endif nargin < 2    sizemult = 1;endtlen = .5 .* sizemult;tbetween = 1 .* sizemult;twid = 1;myy = ystart + tlen ./ 2;train = double(train);size(train)for i = 1:size(train, 2)%	line([0 25], [ystart+tlen./2 ystart+tlen./2], 'color', 'k', 'linewidth', twid);	f1 = find(train(:,i) > 0);	line([f1 f1]', [ystart; ystart+tlen] * ones(1, length(f1)), 'linewidth', twid, 'color', col);	ystart = ystart + tbetween;endhold onfor i = 1:length(evt)    plot(evt(i), myy, 'color', ecol, 'marker', emarker);    myy = myy + tbetween;end