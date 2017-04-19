function histot_gui(mv, which_field,from,to,sig, nolabs)
% function out = histot(mv, which_field, sig, nolabs)
%
% front end to histo function which assumes you want to look at histograms based on target.direction
%
% mv - structure with cell's data
% which_field - name of field to plot
% sig - (optional) gaussian sigma for spk density. defaults to 10ms
% nolabs - (optional) suppresses plotting spk den labels if true.
%

if nargin < 6
    nolabs = 0;
end

if nargin < 5
    sig = 10;
end

if nargin < 2
    which_field = 'a{1}(:,:,3)';
    from = -100;
    to = 500;
end

eval(['the_data = mv.' which_field ';']);
histo_gui(mv.target.direction, the_data, mv.resp.correct==1, sig, nolabs,from,to);
