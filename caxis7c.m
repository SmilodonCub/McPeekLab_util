set(gca, 'xtick', [80:100:500]);set(gca, 'xticklabel', [0:100:400]);h = vlin(80, 'k');if exist('min_width')endif exist('page')	if page == 0		set(h, 'color', [1 1 1]);		set(h, 'linewidth', 2);	else		set(h, 'linewidth', 2);			endend%vlin(150, 'k');