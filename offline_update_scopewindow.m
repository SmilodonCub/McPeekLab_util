% update_scopewindow.m% function update_scopewindow(h0)% update current scope window% h0 is desired window to update, or 0 to update all% NOTE: calls GAUSS.M from local libraries (DMFCMAT)% NOTE: calls nanmeanc.m from local libraries (GENMAT)% JBB 1/9/04function update_scopewindow(h0)if ~isempty(h0) & h0 ~= 0	udd = get(h0, 'UserData');	gvals = udd.gvals;	gpars = udd.gpars;endmaster_colorlist = {'b', 'g', 'r', 'c', 'm', 'y', 'k', [1 .7 0], [.78 .21 1]};		% length = 9general_flag = ~h0;if general_flag,	% general update mode	scope_list = findobj(get(0, 'children'), 'flat', 'tag', 'scope_window');	% all scopes	trials = length(gvals);		% current trialelse				% specific update mode	scope_list = h0;			% desired update scope only	trials = 1:length(gvals);	% all trialsendif isempty(trials) | trials == 0	return;endfor j = 1:length(scope_list),	% get first layer of figure handles	h0 = scope_list(j);	h0_children = get(h0, 'children');	% build control data for this window%%%	h = findobj(h0_children, 'flat', 'tag', 'xlim');				% range settings%%%	control_values.xrange = get(h, 'string');%%%	axis_list = get(h, 'UserData');									% axes this window	% get list of axes this window and arrange them in order for plotting consistency	axis_list = findobj(h0_children, 'flat', 'type', 'axes');		% axes this window	order = get(axis_list, 'tag');									% axis order numbers	if ~iscell(order), order = {order}; end	order = cat(1, order{:});	axis_list = axis_list(str2num(order));	% find other control objects and get their values	h = findobj(h0_children, 'flat', 'tag', 'ylim');	control_values.yrange = get(h, 'string')';	if ~iscell(control_values.yrange), control_values.yrange = {control_values.yrange'}; end	h = findobj(h0_children, 'flat', 'tag', 'align_state');			% alignment info	control_values.alignstate = get(h, 'value');	h = findobj(h0_children, 'flat', 'tag', 'align_time');	control_values.aligntime = get(h, 'string');	xrange = get(h, 'Value');		cp1_h = findobj(h0_children, 'flat', 'tag', 'color_params1');	% colorizing menus	cp2_h = findobj(h0_children, 'flat', 'tag', 'color_params2');	control_values.colorize = [get(cp1_h, 'value'), get(cp2_h, 'value')];		h = findobj(h0_children, 'flat', 'tag', 'downsample');			% display downsampling	control_values.downsample = get(h, 'value');	downstring = get(h, 'String');	downsample = str2num(downstring{control_values.downsample}(1:end-1));%	downsample = 2^(control_values.downsample - 1);					% compute divider: 1, 2, or 4	h = findobj(h0_children, 'flat', 'tag', 'included_trials');			% display downsampling	control_values.included_trials = get(h, 'value');	included_trials = get(h, 'String');	included_trials = included_trials{control_values.included_trials};	% propagate channel control data	allchannels = sort(findobj(h0_children, 'flat', 'tag', 'channel'));	control_values.channels = zeros(1, 21);							% initialize	tempvals = get(allchannels, 'value');							% cell array of selection vals	control_values.channels = cat(2, tempvals{:});					% convert to numeric array	% propagate selected spike density values	control_values.gausswidth = zeros(1, 21);						% initialize	control_values.gausswidth(end-4:end) = 4;						% default gaussian widths	tempstruct = get(allchannels, 'userdata');						% cell array of data structs	tempstruct = cat(1, tempstruct{:});								% convert to standard array	[tempvals{1:length(tempstruct)}] = deal(tempstruct.gauss_width);	% gaussians of channels	control_values.gausswidth = cat(2, tempvals{:});				% convert to numeric array	clear temp*	% get list of headerd of selected channels only	channel_list = findobj(allchannels, 'flat', 'value', 1);		% note: already sorted	% if #axes don't match #channels (up to 4), regenerate entire window (and RETURN)	if length(axis_list) ~= min(length(channel_list), 4),		offline_spawn_scopewindow(control_values, h0);		return	end	% Now get colorizing info	[p1 color_offset1 color_labels1 color_choices1] = get_colorize_info(cp1_h, gvals, gpars);	[p2 color_offset2 color_labels2 color_choices2] = get_colorize_info(cp2_h, gvals, gpars);	% for each axis or selected channel (whichever is smaller)	for i = 1:min(length(axis_list), length(channel_list)),		ax = axis_list(i); axes(ax);		uidata = get(channel_list(i), 'userdata');		to_msec = 1000 / uidata.sample_rate;	% i.e., msec per sample		to_samples = 1 / to_msec;				% i.e., samples per msec		timebase = (xrange(1)+to_msec : to_msec : xrange(2))';		timebase = timebase(1:downsample:end);	% downsample timebase		if ~general_flag,		% additional operations for specific update:			cla;				% clear scope and set axis title			set(ax, 'UserData', {});	% clear userdata (averages)			h = get(ax, 'title'); set(h, 'string', uidata.title_string);		else					% operations for general update:			h = findobj(get(gca, 'children'), 'flat', 'selected', 'on');	% find latest trace			set(h, 'linewidth', 0.5, 'selected', 'off');	% deselect and revert to old width		end		avg_matrices = get(gca, 'UserData');	% used for spikes only		ctr_flag = strcmp(uidata.field_name, 'Ctr');		% for each trial recorded so far		for tr = trials,				if include_trial_filter(gvals(tr), included_trials)				% get raw data vector for trial				data = getfield(gvals(tr), lower(uidata.field_name));				data = data{uidata.field_col};					% Notes on data alignment / start times:				% AI channels need to be adjusted by their start time, since state changes occur				%  at different positions in the array (even though the master clock is the same).				% Counter channels are simply spike occurrences. Who cares when they started? They				%  are just there. When spike times are converted to spikes / second, which is in				%  register with the low-speed AI channels, use the LS start time for both.					% get start times				if strcmp(uidata.field_name, 'Raw'),					start_time = gvals(tr).misc.hs_start;				elseif ctr_flag,	% OK for both eye and ctr channels	NOT ANYMORE! 3/4/04					if length(gvals(tr).misc.ctr_start) == 1	% Kludge for legacy data files.						start_time = gvals(tr).misc.ctr_start;					else						start_time = gvals(tr).misc.ctr_start(uidata.field_col);					end				else					start_time = gvals(tr).misc.ls_start;				end					% special processing for counter channels: convert to spikes versus time				if ctr_flag,	% 				spike_times = (data - start_time) * 1000;	% convert spike sample times to msec	% 				timebase_ratio = 1;							% Ctr and LS use same master clock	% 				data_length = round( (gvals(tr).misc.trial_end - start_time) * 1000);	% 				data = convert_spikes(spike_times, timebase_ratio, data_length);	% spikes vs time					data = double(data);						% convert spikes to spike density if desired					if uidata.gauss_width,		% i.e., not zero						data = gauss(uidata.gauss_width, uidata.sample_rate, data) * uidata.sample_rate;					end				end					% align data vector				states = [gvals(tr).disp_time; gvals(tr).state_time];				align_index = round((states(control_values.alignstate) - start_time) * 1000);				data = trial_align2( data, align_index*to_samples, xrange*to_samples);					% downsample data				data = data(1:downsample:end);					% get data trace color index				col1 = get_trial_color(p1, tr, gvals, gpars) + color_offset1;				col2 = get_trial_color(p2, tr, gvals, gpars) + color_offset2;				c = col1 + (col2 - 1) .* color_choices1;				ci = mod(c-1, length(master_colorlist)) + 1;	% color index accesses spden averages					% special processing for counter channels: average trials				if ctr_flag,					% update averages					% NOTE: will likely return error if alignment interval is not defined					if ci > length(avg_matrices), avg_matrices{ci} = []; end	% add item if necessary					avg_matrices{ci} = [avg_matrices{ci}, data];					else	% only plot data if it is not spikes!!!					h = plot(timebase, data, 'color', master_colorlist{ci});		% plot trace					if general_flag,		% highlight (width) new most recent trace						set(h, 'linewidth', 3, 'selected', 'on', 'SelectionHighlight', 'off');					end				end			end			end		% for each trial		% now plot counter data		if ctr_flag,			cla;									% clear old averages			set(gca, 'UserData', avg_matrices);		% refresh averaged matrices			for i = 1:length(avg_matrices),				if ~isempty(avg_matrices{i}),					plot(timebase, nanmeanc(avg_matrices{i}), 'color', master_colorlist{i});				end			end			line([0 0], get(gca, 'ylim'), 'color', 'k', 'linestyle', ':');	% refresh zero line		end			if ~general_flag 	% (specific update)						if ~ctr_flag,				line([0 0], get(gca, 'ylim'), 'color', 'k', 'linestyle', ':');			end						% plot labels			if ~isempty(color_labels1)				xl = get(gca, 'xlim');				yl = get(gca, 'ylim');				xr = xl(2) - xl(1);				yr = yl(2) - yl(1);				xl = xl(1);				yl = yl(2);				for jj = 1:color_choices2					for ii = 1:color_choices1						xpos = xl + xr * (.075 * (ii-1) + .025);						ypos = yl - yr .* (.1 .* (jj-1) + .05);						lab = num2str([color_labels1(ii)]);						text(xpos, ypos, lab, 'color', master_colorlist{mod(ii+(jj-1) .* color_choices1-1, length(master_colorlist))+1});					end					if ~isempty(color_labels2)						lab = ['@ ' num2str([color_labels2(jj)])];						text(xpos + xr .* .075, ypos, lab,  'color', 'k');					end				end			end				end								% already refreshed zero line if this is a counter axis		% Note on zero lines: when scopes are cleared and new data is plotted, zero lines can		%  become very small (old ylims). Click the update button to refresh them.		end		% for all axes on scopeend			% for all scopes