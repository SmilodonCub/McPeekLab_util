function yticks = errorline(cats, vals, sems, col, page, yticks, min_width)% function yticks = errorline(cats, vals, sems, col, page, yticks, min_width)width_multiplier = 1;if nargin < 5 | isempty(page)	page = 1;endif page == 0	pencolor = [1 1 1];	bkgcolor = [0 0 0];else	pencolor = [0 0 0];	bkgcolor = [1 1 1];endif nargin < 7 | isempty(min_width)	if page == 0		min_width = 2;	else		min_width = 1;	endendif nargin < 4 | isempty(col)	col = pencolor;endset(gcf, 'color', bkgcolor);set(gcf, 'inverthardcopy', 'off');h = errorbar(cats, vals, sems);set(h, 'color', col);set(h, 'linewidth', min_width .* width_multiplier);hold onplot(cats, vals, 'o', 'color', col, 'markerfacecolor', col, 'markersize', 6 .* min_width);set(gca, 'linewidth', min_width);hold onif nargin >= 6 & ~isempty(yticks)	set(gca, 'ylim', [yticks(1) yticks(end)]);	set(gca, 'ytick', yticks);else	xx = get(gca, 'ytick');	if length(xx) > 5 & xx(end)-xx(1) > 10		xx = round([xx(1):(xx(end) ./ (round(length(xx) ./ 2)-1)):xx(end)]);		set(gca, 'ytick', xx);	endendyticks = get(gca, 'ytick');set(gca, 'box', 'off');set(gca, 'tickdir', 'out');set(gca, 'ticklength', get(gca, 'ticklength') .* 3);set(gca, 'fontsize', 18 + (min_width-1) .* 6);set(gca, 'xcolor', pencolor);set(gca, 'ycolor', pencolor);set(gca, 'color', bkgcolor);