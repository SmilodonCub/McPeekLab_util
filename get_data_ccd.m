function mv = get_data(files, nums, nodata, which_fields)% function mv = get_data(files, nums, nodata, which_fields)%% (formerly called fconvert_set)% This is just a front-end to get_aligned_data.m that pre-specifies % alignment events and windows. It returns a struct array of trials.%% It concatenates multiple data files for the same task and the same cell(s).% Data are aligned on specified events. Plexon data from .px files in the same % directory are used if specified.%% files - (required) cell array of filename prefixes% nums - (optional) cell array of filename suffix numbers. If not specified, %           all files matching <files> prefix are used.% nodata - (optional) if this flag is set to 1, then only experiment parameters %           are extracted; no aligned data are extracted.% which_fields - (optional) specifies the data types to extract -- h_eye, v_eye, plex (units), plexlfp (LFPs), plexwf (unit waveforms)%% examples:% files = {'fr12_objd_'};% nums = {[5:8 11]};%% this combination would matches .mat files starting with fr12_objd_ and ending with 05, 06, 07, 08, 11.%% New version to correct "dissimilar structs" error message.% Note: when combining multiple data files, the first file determines%	which fields will be present in the final struct.% rmm Feb 9, 2005%% Added wildcard expansion to filenames - rmm April 22, 2005.%if nargin < 4	which_fields = {'h_eye', 'v_eye', 'plex', 'plexlfp'};endif nargin < 3	nodata = 0;endif nargin < 2	nums = [];endif nargin > 1 & ~isempty(nums) & ~iscell(nums)	nums = {nums};endif ~iscell(files)	files = {files};end%mv = get_aligned_data(files, nums, nodata, which_fields, {'target on', 'saccade inflight', 'cue on'}, {[-100 1500], [-1500 500], [-500 1200]});mv = get_aligned_data(files, nums, nodata, which_fields, {'cue on', 'saccade inflight'}, {[-500 1500], [-1200 300]});% mv = get_aligned_data(files, nums, nodata, which_fields, {'target on', 'fixspot off', 'saccade inflight'}, {[-100 500], [-300 300], [-400 200]});%mv = get_aligned_data(files, nums, nodata, which_fields, {'target on', 'saccade inflight', 'cue on'}, {[-100 500], [-500 300], [-800 800]});%mv = get_aligned_data(files, nums, nodata, which_fields, {'target on', 'reach inflight'}, {[-100 500], [-500 300]});%mv = get_aligned_data(files, nums, nodata, which_fields, {'target on'}, {[-100 400]});