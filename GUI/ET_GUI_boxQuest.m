function varargout = ET_GUI_boxQuest(varargin)
% ET_GUI_BOXQUEST MATLAB code for ET_GUI_boxQuest.fig
%      ET_GUI_BOXQUEST, by itself, creates a new ET_GUI_BOXQUEST or raises the existing
%      singleton*.
%
%      H = ET_GUI_BOXQUEST returns the handle to a new ET_GUI_BOXQUEST or the handle to
%      the existing singleton*.
%
%      ET_GUI_BOXQUEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ET_GUI_BOXQUEST.M with the given input arguments.
%
%      ET_GUI_BOXQUEST('Property','Value',...) creates a new ET_GUI_BOXQUEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ET_GUI_boxQuest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ET_GUI_boxQuest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ET_GUI_boxQuest

% Last Modified by GUIDE v2.5 01-Feb-2016 14:55:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ET_GUI_boxQuest_OpeningFcn, ...
                   'gui_OutputFcn',  @ET_GUI_boxQuest_OutputFcn, ...
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
end


% --- Executes just before ET_GUI_boxQuest is made visible.
function ET_GUI_boxQuest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ET_GUI_boxQuest (see VARARGIN)

% Choose default command line output for ET_GUI_boxQuest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%return variables
setappdata(handles.output,'currPos',[])
setappdata(handles.output,'corner','')
%custom coordinates
setappdata(handles.output,'cusLL',[])
setappdata(handles.output,'cusLR',[])
setappdata(handles.output,'cusUR',[])
setappdata(handles.output,'cusUL',[])


% UIWAIT makes ET_GUI_boxQuest wait for user response (see UIRESUME)
uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = ET_GUI_boxQuest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%%% OutputFCN
varargout{1} = { getappdata(handles.output,'currPos'), ...
                 getappdata(handles.output,'corner')};


% The figure can be deleted now
delete(handles.figure1);

end

%%%%%%%%%%%%%%%%%%%%%%%%%
% Push Button Functions %
%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pb_thermoLL.
function pb_thermoLL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_thermoLL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[0,0])
setappdata(handles.output,'corner','LL')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_thermoUR.
function pb_thermoUR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_thermoUR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[50,40])
setappdata(handles.output,'corner','UR')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_thermoLR.
function pb_thermoLR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_thermoLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[50,0])
setappdata(handles.output,'corner','LR')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_thermoUL.
function pb_thermoUL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_thermoUL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[0,40])
setappdata(handles.output,'corner','UL')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_BenzLL.
function pb_BenzLL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_BenzLL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[0,0])
setappdata(handles.output,'corner','LL')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_BenzUR.
function pb_BenzUR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_BenzUR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[87,74])
setappdata(handles.output,'corner','UR')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_BenzLR.
function pb_BenzLR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_BenzLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[87,0])
setappdata(handles.output,'corner','LR')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_BenzUL.
function pb_BenzUL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_BenzUL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[0,74])
setappdata(handles.output,'corner','UL')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_fishLL.
function pb_fishLL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fishLL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[0,0])
setappdata(handles.output,'corner','LL')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_fishUR.
function pb_fishUR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fishUR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[249 114]) %inner measures
setappdata(handles.output,'corner','UR')
uiresume(handles.figure1);
end

% --- Executes on button press in pb_fishLR.
function pb_fishLR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fishLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[249 0])
setappdata(handles.output,'corner','LR')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_fishUL.
function pb_fishUL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fishUL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'currPos',[0 114])
setappdata(handles.output,'corner','UL')
uiresume(handles.figure1);
end


% --- Executes on button press in pb_cusLL.
function pb_cusLL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cusLL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(getappdata(handles.output,'cusLL')),
    setappdata(handles.output,'currPos',getappdata(handles.output,'cusLL'))
    setappdata(handles.output,'corner','LL')
    uiresume(handles.figure1);
else
    errordlg('The string you enter above does not match the format  %f5.5 , %f5.5 !')
end
end


% --- Executes on button press in pb_cusUR.
function pb_cusUR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cusUR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(getappdata(handles.output,'cusUR')),
    setappdata(handles.output,'currPos',getappdata(handles.output,'cusUR'))
    setappdata(handles.output,'corner','UR')
    uiresume(handles.figure1);
else
    errordlg('The string you enter above does not match the format  %f5.5 , %f5.5 !')
end

end


% --- Executes on button press in pb_cusLR.
function pb_cusLR_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cusLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(getappdata(handles.output,'cusLR')),
    setappdata(handles.output,'currPos',getappdata(handles.output,'cusLR'))
    setappdata(handles.output,'corner','LR')
    uiresume(handles.figure1);
else
    errordlg('The string you enter above does not match the format  %f5.5 , %f5.5 !')
end
end


% --- Executes on button press in pb_cusUL.
function pb_cusUL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cusUL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(getappdata(handles.output,'cusUL')),
    setappdata(handles.output,'currPos',getappdata(handles.output,'cusUL'))
    setappdata(handles.output,'corner','UL')
    uiresume(handles.figure1);
else
    errordlg('The string you enter above does not match the format  %f5.5 , %f5.5 !')
end
end

%%%%%%%%%%%%%%%%%%
% EDIT FUNCTIONS %
%%%%%%%%%%%%%%%%%%

function ed_ll_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ll as text
%        str2double(get(hObject,'String')) returns contents of ed_ll as a double
pos = [];

try
    eval([ 'pos = [' get(hObject,'String') '];'])
catch
    errordlg('The string you enter above does not match the format  %f5.5 , %f5.5 !')
end
setappdata(handles.output,'cusLL',pos)
end



function ed_lr_Callback(hObject, eventdata, handles)
% hObject    handle to ed_lr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_lr as text
%        str2double(get(hObject,'String')) returns contents of ed_lr as a double

pos = [];

try
    eval([ 'pos = [' get(hObject,'String') '];'])
catch
    errordlg('The string you enter above does not match the format  %f5.5 , %f5.5 !')
end
setappdata(handles.output,'cusLR',pos)
end



function ed_ul_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ul as text
%        str2double(get(hObject,'String')) returns contents of ed_ul as a double
pos = [];

try
    eval([ 'pos = [' get(hObject,'String') '];'])
catch
    errordlg('The string you enter above does not match the format  %f5.5 , %f5.5 !')
end
setappdata(handles.output,'cusUL',pos)
end



function ed_ur_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ur as text
%        str2double(get(hObject,'String')) returns contents of ed_ur as a double
pos = [];

try
    eval([ 'pos = [' get(hObject,'String') '];'])
catch
    errordlg('The string you enter above does not match the format  %f5.5 , %f5.5 !')
end
setappdata(handles.output,'cusUR',pos)
end

%%%%%%%%%%%%%%%%%%%%%%
% CREATION FUNCTIONS %
%%%%%%%%%%%%%%%%%%%%%%


% --- Executes during object creation, after setting all properties.
function ed_ll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_lr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_lr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_ul_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ul (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_ur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
else
% The GUI is no longer waiting, just close it
delete(hObject);
end


end
