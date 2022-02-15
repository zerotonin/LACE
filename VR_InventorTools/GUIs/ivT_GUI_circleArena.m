function varargout = ivT_GUI_circleArena(varargin)
% IVT_GUI_CIRCLEARENA MATLAB code for ivT_GUI_circleArena.fig
%      IVT_GUI_CIRCLEARENA, by itself, creates a new IVT_GUI_CIRCLEARENA or raises the existing
%      singleton*.
%
%      H = IVT_GUI_CIRCLEARENA returns the handle to a new IVT_GUI_CIRCLEARENA or the handle to
%      the existing singleton*.
%
%      IVT_GUI_CIRCLEARENA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVT_GUI_CIRCLEARENA.M with the given input arguments.
%
%      IVT_GUI_CIRCLEARENA('Property','Value',...) creates a new IVT_GUI_CIRCLEARENA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ivT_GUI_circleArena_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ivT_GUI_circleArena_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ivT_GUI_circleArena
clc
% Last Modified by GUIDE v2.5 01-Feb-2016 15:46:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ivT_GUI_circleArena_OpeningFcn, ...
    'gui_OutputFcn',  @ivT_GUI_circleArena_OutputFcn, ...
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

% --- Executes just before ivT_GUI_circleArena is made visible.
function ivT_GUI_circleArena_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ivT_GUI_circleArena (see VARARGIN)



% Choose default command line output for ivT_GUI_circleArena
handles.output = hObject;
setappdata(handles.output,'picPos', '');
setappdata(handles.output,'center', NaN(1,2));
setappdata(handles.output,'step', 1);
if ~isempty(varargin),
    setappdata(handles.output,'pic', varargin{1});
else
    setappdata(handles.output,'pic',[]);
end
setappdata(handles.output,'radius', 0);
setappdata(handles.output,'circleChoice', 'rb_innerC');
setappdata(handles.output,'saveChoice', 0);
setappdata(handles.output,'pixTable',{});



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ivT_GUI_circleArena wait for user response (see UIRESUME)
if ~isempty(varargin),
    imagesc(varargin{1},'Parent',handles.axes1)
else
    imagesc(imread('theRingGUI.jpg'),'Parent',handles.axes1)
end
colormap gray
axis image
uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = ivT_GUI_circleArena_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = getappdata(handles.output,'pixTable');
% The figure can be deleted now
delete(handles.figure1);
end

% --- Executes on button press in pb_up.
function pb_up_Callback(hObject, eventdata, handles)
% hObject    handle to pb_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center = getappdata(handles.output,'center');
center(:,2) = center(:,2)-getappdata(handles.output,'step');
setappdata(handles.output,'center', center);
plotStuff(hObject, eventdata, handles)
end


% --- Executes on button press in pb_left.
function pb_left_Callback(hObject, eventdata, handles)
% hObject    handle to pb_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center = getappdata(handles.output,'center');
center(:,1) = center(:,1)-getappdata(handles.output,'step');
setappdata(handles.output,'center', center);
plotStuff(hObject, eventdata, handles)
end


% --- Executes on button press in pb_right.
function pb_right_Callback(hObject, eventdata, handles)
% hObject    handle to pb_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center = getappdata(handles.output,'center');
center(:,1) = center(:,1)+getappdata(handles.output,'step');
setappdata(handles.output,'center', center);
plotStuff(hObject, eventdata, handles)
end


% --- Executes on button press in pb_down.
function pb_down_Callback(hObject, eventdata, handles)
% hObject    handle to pb_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center = getappdata(handles.output,'center');
center(:,2) = center(:,2)+getappdata(handles.output,'step');
setappdata(handles.output,'center', center);
plotStuff(hObject, eventdata, handles)
end


% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fPos,pName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },'pick a frame');
cd(pName)
pic = imread([pName fPos]);
setappdata(handles.output,'picPos', [pName fPos]);
setappdata(handles.output,'pic', pic);
plotStuff(hObject, eventdata, handles)
end


% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

center = getappdata(handles.output,'center');
r = getappdata(handles.output,'radius');

    
pixBox= [center(1,:)-r;...%lower left
    center(1,1)-r center(1,2)+r;... %upper left
    center(1,:)+r;...%upper right
    center(1,1)+r center(1,2)-r];%  lower right

if strcmp(getappdata(handles.output,'circleChoice'),'rb_innerC')
    % inner
    mBox = [0    0;...
            0    77.8;...
            77.8 77.8;
            77.8 0];
elseif strcmp(getappdata(handles.output,'circleChoice'),'rb_outterC')
    % outter
    mBox = [0  0;...
            0  86;...
            86 86;
            86 0];
end
pixTable = num2cell([mBox';pixBox']);
pixTable = cellfun(@num2str,pixTable,'UniformOutput',false);
[file,path] = uiputfile('*.mat','Save pix table As');
if getappdata(handles.output,'saveChoice');
save([path file],'r','center')
else
save([path file],'pixTable')

end
uiresume(handles.figure1)

end


% --- Executes on button press in pb_mouse.
function pb_mouse_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotStuff(hObject, eventdata, handles)
[x,y] = ginput(2);
r= sqrt((x(2)-x(1))^2+(y(2)-y(1))^2);
setappdata(handles.output,'center', [x y]);
setappdata(handles.output,'radius', r);
plotStuff(hObject, eventdata, handles)
end

function plotStuff(hObject, eventdata, handles)
center = getappdata(handles.output,'center');
r = getappdata(handles.output,'radius');
pic = getappdata(handles.output,'pic');
axis(handles.axes1)
imagesc(pic,'Parent',handles.axes1)
colormap gray
axis image
if ~isnan(r),
    
    
    ang=0:0.01:2*pi;
    xp=r*cos(ang);
    yp=r*sin(ang);
    hold on
    plot(handles.axes1,center(:,1),center(:,2),'g')
    plot(handles.axes1,center(1,1)+xp,center(1,2)+yp,'g')
    plot(handles.axes1,center(:,1),center(:,2),'rx')
end

end


% --- Executes on button press in pb_r_bigger.
function pb_r_bigger_Callback(hObject, eventdata, handles)
% hObject    handle to pb_r_bigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

r1 = getappdata(handles.output,'radius');
r =r1+getappdata(handles.output,'step');
center = getappdata(handles.output,'center');
vec =diff((center),1).*(r/r1);
center(2,:)=bsxfun(@plus,center(1,:),vec);
setappdata(handles.output,'radius', r);
setappdata(handles.output,'center', center);
plotStuff(hObject, eventdata, handles)
end

% --- Executes on button press in pb_r_smaller.
function pb_r_smaller_Callback(hObject, eventdata, handles)
% hObject    handle to pb_r_smaller (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r1 = getappdata(handles.output,'radius');
r =r1-getappdata(handles.output,'step');
center = getappdata(handles.output,'center');
vec =diff((center),1).*(r/r1);
center(2,:)=bsxfun(@plus,center(1,:),vec);
setappdata(handles.output,'radius', r);
setappdata(handles.output,'center', center);
plotStuff(hObject, eventdata, handles)
end



% --- Executes when selected object is changed in rb_circle.
function rb_circle_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in rb_circle
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
newChoice= get(eventdata.NewValue,'Tag');
setappdata(handles.output,'circleChoice', newChoice);
end


% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
newChoice= get(eventdata.NewValue,'Tag');
switch newChoice,
    case 'rb_step_1'
        setappdata(handles.output,'step', 1);
    case 'rb_step_10'
        setappdata(handles.output,'step', 10);
end

end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
setappdata(handles.output,'saveChoice', get(hObject,'Value'));
end


% --- Executes on button press in pb_return.
function pb_return_Callback(hObject, eventdata, handles)
% hObject    handle to pb_return (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center = getappdata(handles.output,'center');
r = getappdata(handles.output,'radius');

    
pixBox= [center(1,:)-r;...%lower left
    center(1,1)-r center(1,2)+r;... %upper left
    center(1,:)+r;...%upper right
    center(1,1)+r center(1,2)-r];%  lower right

if strcmp(getappdata(handles.output,'circleChoice'),'rb_innerC')
    % inner
    mBox = [0    0;...
            0    77.8;...
            77.8 77.8;
            77.8 0];
elseif strcmp(getappdata(handles.output,'circleChoice'),'rb_outterC')
    % outter
    mBox = [0  0;...
            0  86;...
            86 86;
            86 0];
end
pixTable = num2cell([mBox';pixBox']);
pixTable = cellfun(@num2str,pixTable,'UniformOutput',false);
setappdata(handles.output,'pixTable',pixTable);
uiresume(handles.figure1)
end


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
