function nxy(fgv, col, which)if nargin < 2	col = 'r';endif nargin < 3	which = [1:size(fgv.sa, 2)];endplot(fgv.sa(1:550,which,1), fgv.sa(1:550,which,2), col);hold onplot(fgv.target.position(1,which), fgv.target.position(2,which), 'o');x1 = max(abs(get(gca, 'xlim')));x2 = max(abs(get(gca, 'ylim')));x3 = max([x1 x2]);set(gca, 'xlim', [-x3 x3]);set(gca, 'ylim', [-x3 x3]);