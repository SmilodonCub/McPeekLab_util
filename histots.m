function out = histots(mv, cell1, which_field, sig, nolabs)
% function out = histot(mv, cell1, which_field, sig, nolabs)
%
% front end to histo function which assumes you want to look at histograms based on target.direction
%
% mv - structure with cell's data
% which_field - name of field to plot
% sig - (optional) gaussian sigma for spk density. defaults to 10ms
% nolabs - (optional) suppresses plotting spk den labels if true.
%

if nargin < 5
    nolabs = 0;
end

if nargin < 4
    sig = 10;
end

if nargin < 3
    which_field = 'a{1}(:,:,3)';
end

eval(['the_data = mv.' which_field ';']);
s1 = getcellspk(mv, the_data, cell1(1), cell1(2));

out = histo(mv.target.direction, s1, mv.resp.correct==1, sig, nolabs);
