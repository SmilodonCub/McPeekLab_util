function varargout = Quickview(varargin)
% QUICKVIEW MATLAB code for Quickview.fig
%      QUICKVIEW, by itself, creates a new QUICKVIEW or raises the existing
%      singleton*.
%
%      H = QUICKVIEW returns the handle to a new QUICKVIEW or the handle to
%      the existing singleton*.
%
%      QUICKVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUICKVIEW.M with the given input arguments.
%
%      QUICKVIEW('Property','Value',...) creates a new QUICKVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Quickview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Quickview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Quickview

% Last Modified by GUIDE v2.5 18-Mar-2013 06:20:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Quickview_OpeningFcn, ...
                   'gui_OutputFcn',  @Quickview_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Quickview is made visible.
function Quickview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Quickview (see VARARGIN)

% Choose default command line output for Quickview
handles.output = hObject;

start = str2double(get(handles.BegTime, 'String'));
finish = str2double(get(handles.EndTime, 'String'));
% Save the new volume value
handles.timedata.beg = start;
handles.timedata.end = finish;
% Update handles structure
guidata(hObject, handles);


guidata(hObject,handles)

% UIWAIT makes Quickview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Quickview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Plot.
function Plot_Callback(hObject, eventdata, handles)
% hObject    handle to Plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Signal type
if get(handles.lfp,'value')
    which_field = 'plexlfp';
elseif get(handles.spikes,'value')
    which_field = 'plex';
end
%% Alignment event
if get(handles.targon,'value')
    align_event = {'target on'};
elseif get(handles.sacon,'value')
    align_event = {'saccade inflight'};
end
%% Time window
start = handles.timedata.beg;
finish = handles.timedata.end;

%% --- End of parameter setting.
if handles.filedata.processRequired == 1
    set(handles.wait,'enable','on');
    pause(0.5);
    Data = get_data_gui(handles.filedata.name,[],0,which_field,align_event,start, finish);
    pause(0.5);
    set(handles.wait,'enable','off');
    handles.data = Data;
    col = size(Data.align_index,2);
    A = cell2mat(Data.align_index');
    for i=1:size(A,1)
        if A(i,1) ~= 0 && A(i,2) == 1; set(handles.sc1,'Enable','on','UserData',i); end;
        if A(i,1) ~= 0 && A(i,2) == 2; set(handles.sc2,'Enable','on','UserData',i); end;
        if A(i,1) ~= 0 && A(i,2) == 9; set(handles.fef1,'Enable','on','UserData',i); end;
        if A(i,1) ~= 0 && A(i,2) == 10; set(handles.fef2,'Enable','on','UserData',i); end;
    end
    handles.filedata.processRequired = 0;
end

guidata(hObject,handles);
%% Channel selection
if get(handles.sc1,'value')
    channel = get(handles.sc1,'UserData');
elseif get(handles.sc2,'value')
    channel = get(handles.sc2,'UserData');
elseif get(handles.fef1,'value')
    channel = get(handles.fef1,'UserData');
elseif get(handles.fef2,'value')
    channel = get(handles.fef2,'UserData');
end
%% Plot data
axes(handles.axes1);
histot_gui(handles.data,strcat('a{1}(:,:,',num2str(channel),')'),start,finish);
set(gca,'XLim',[start finish],'Box','off');
set(get(gca,'Title'),'String','');

% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.OpenFile,'Enable','on');
set(handles.Plot,'Enable','off');
set(handles.Reset,'Enable','off');
set(handles.BegTime, 'String', -100);
set(handles.EndTime, 'String', 500);
set(handles.spikes, 'value', 1);
set(handles.sacon, 'value', 1);
set(handles.fef1, 'value', 1);
cla; legend off; 
handles.filedata.processRequired = 1;
guidata(hObject,handles)

% --- Executes on button press in OpenFile.
function OpenFile_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OpenFile
if ispc
    folder = 'C:\SUNY\Peanut\';
else
    folder = pwd;
end
[filename,pathname] = uigetfile('*.mat', 'Pick a MATLAB code file',folder);
index = findstr(filename,'_');
filename = filename(1:max(index));
handles.filedata.name = fullfile(pathname,filename);
handles.filedata.processRequired = 1;
%% Signal type
if get(handles.lfp,'value')
    which_field = 'plexlfp';
elseif get(handles.spikes,'value')
    which_field = 'plex';
end
%% Alignment event
if get(handles.targon,'value')
    align_event = {'target on'};
elseif get(handles.sacon,'value')
    align_event = {'saccade inflight'};
end
%% Time window
start = handles.timedata.beg;
finish = handles.timedata.end;
%% --- End of parameter setting.
if handles.filedata.processRequired == 1
    set(handles.wait,'enable','on');
    pause(0.5);
    Data = get_data_gui(handles.filedata.name,[],0,which_field,align_event,start, finish);
    pause(0.5)
    set(handles.wait,'enable','off');
    handles.data = Data;
    handles.filedata.processRequired = 0;
end
col = size(Data.align_index,2);
A = cell2mat(Data.align_index');
for i=1:size(A,1)
    if A(i,1) ~= 0 && A(i,2) == 1; set(handles.sc1,'Enable','on','UserData',i); end;
    if A(i,1) ~= 0 && A(i,2) == 2; set(handles.sc2,'Enable','on','UserData',i); end;
    if A(i,1) ~= 0 && A(i,2) == 9; set(handles.fef1,'Enable','on','UserData',i); end;
    if A(i,1) ~= 0 && A(i,2) == 10; set(handles.fef2,'Enable','on','UserData',i); end;
end
set(handles.OpenFile,'Enable','off');        
set(handles.Plot,'Enable','on');
set(handles.Reset,'Enable','on');
guidata(hObject,handles);




function BegTime_Callback(hObject, eventdata, handles)
% hObject    handle to BegTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BegTime as text
%        str2double(get(hObject,'String')) returns contents of BegTime as a double

start = str2double(get(hObject, 'String'));
if isnan(start)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
handles.filedata.processRequired = 1;
% Save the new volume value
handles.timedata.beg = start;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function BegTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BegTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndTime_Callback(hObject, eventdata, handles)
% hObject    handle to EndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndTime as text
%        str2double(get(hObject,'String')) returns contents of EndTime as a double

finish = str2double(get(hObject, 'String'));
if isnan(finish)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if finish < handles.timedata.beg
    set(hObject, 'String',handles.timedata.beg );
    errordlg('Finish time must be greater than start time','Error');
end
handles.filedata.processRequired = 1;
% Save the new volume value
handles.timedata.end = finish;
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function EndTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in signal.
function signal_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in signal 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


handles.filedata.processRequired = 1;
guidata(hObject,handles)


% --- Executes when selected object is changed in alignment.
function alignment_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in alignment 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

handles.filedata.processRequired = 1;
guidata(hObject,handles)
