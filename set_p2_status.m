% set_p2_status.m% function set_p2_status(p1_h)% set enable / disable status of color parameter 2 control% based on value of color parameter 1 control% JBB 2/4/04function set_p2_status(p1_h)p1_select = get(p1_h, 'Value');p2_h = get(p1_h, 'UserData');if p1_select == 1,	set(p2_h, 'Enable', 'off', 'Value', 1);else	set(p2_h, 'Enable', 'on');end