function outs = catpct(cat, corr)zz = unique(cat);for i = 1:length(zz)	z1 = find(cat == zz(i) & corr ~= 0);	pcts(i) = sum(corr(z1) == 1) ./ length(z1) .* 100;endouts = [zz; pcts];