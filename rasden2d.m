function yticks = rasden2(spk1, spk2, evt1, evt2, sizemult, twin, sig, page, yticks, col1, col2, ras_row_spacing, col3, col4, min_width)% function yticks = rasden2(spk1, spk2, evt1, evt2, sizemult, twin, sig, page, yticks, col1, col2, ras_row_spacing, col3, col4, min_width)%	includes events in the raster plotwidth_multiplier = 1;if nargin < 8 | isempty(page)	page = 1;endif page == 0	pencolor = [1 1 1];	bkgcolor = [0 0 0];else	pencolor = [0 0 0];	bkgcolor = [1 1 1];endif nargin < 15 | isempty(min_width)	if page == 0		min_width = 2;	else		min_width = 1;	endendif nargin < 14 | isempty(col4)	col4 = pencolor;endif nargin < 13 | isempty(col3)	col3 = pencolor;endif nargin < 12 | isempty(ras_row_spacing)	ras_row_spacing = 3;endif nargin < 11 | isempty(col2)	col2 = [0 1 0];endif nargin < 10 | isempty(col1)	col1 = [1 0 0];endif nargin < 9	yticks = [];endif nargin < 7 | isempty(sig)	sig = 10;endif nargin > 1 & isempty(spk1) & ~isempty(spk2)	spk1 = spk2;	spk2 = [];endif nargin < 6 | isempty(twin)	twin = [20:size(spk1,1)-20];else	twin = [twin(1):twin(2)];endif nargin < 5 | isempty(sizemult)    sizemult = 1;endset(gcf, 'color', bkgcolor);set(gcf, 'inverthardcopy', 'off');%subplot(2,1,2);yticks = den2c(spk1, spk2, twin, sig, page, yticks, col1, col2, min_width);%subplot(2,1,1);[evt1 ii] = sort(evt1);spk1 = spk1(:, ii);ys = ras1evet(spk1(twin,:), sizemult, col3, yticks(end), evt1, 'c', 'square');if nargin > 1 & ~isempty(spk2)	h = hlin(ys + ras_row_spacing ./ 2, pencolor);	set(h, 'linewidth', min_width);		[evt2 ii] = sort(evt2);	spk2 = spk2(:, ii);	ys = ras1evet(spk2(twin,:), sizemult, col4, ys+ras_row_spacing, evt2, 'c', 'square');endset(gca, 'linewidth', min_width);xx = get(gca, 'xlim');axis([xx(1) xx(2) 0 ys]);raster_set1