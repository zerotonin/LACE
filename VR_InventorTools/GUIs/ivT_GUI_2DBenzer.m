function varargout = ivT_GUI_2DBenzer(varargin)
% IVT_GUI_2DBENZER MATLAB code for ivT_GUI_2DBenzer.fig
%      IVT_GUI_2DBENZER, by itself, creates a new IVT_GUI_2DBENZER or raises the existing
%      singleton*.
%
%      H = IVT_GUI_2DBENZER returns the handle to a new IVT_GUI_2DBENZER or the handle to
%      the existing singleton*.
%
%      IVT_GUI_2DBENZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVT_GUI_2DBENZER.M with the given input arguments.
%
%      IVT_GUI_2DBENZER('Property','Value',...) creates a new IVT_GUI_2DBENZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ivT_GUI_2DBenzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ivT_GUI_2DBenzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ivT_GUI_2DBenzer

% Last Modified by GUIDE v2.5 16-Jul-2014 12:20:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ivT_GUI_2DBenzer_OpeningFcn, ...
                   'gui_OutputFcn',  @ivT_GUI_2DBenzer_OutputFcn, ...
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

% --- Executes just before ivT_GUI_2DBenzer is made visible.
function ivT_GUI_2DBenzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ivT_GUI_2DBenzer (see VARARGIN)

% Choose default command line output for ivT_GUI_2DBenzer
handles.output = hObject;
setappdata(handles.output,'mmTable', [0 0 89 89; 0 75 0 75]);
setappdata(handles.output,'repetitions', 5);
setappdata(handles.output,'fps', 30);
setappdata(handles.output,'arenaHeight', 75);
setappdata(handles.output,'butterDeg', 2);
setappdata(handles.output,'butterCutOff', 0.25);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ivT_GUI_2DBenzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = ivT_GUI_2DBenzer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%%%%%%%%%%%%%%%%%%%%%
% mmTable Functions %
%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pix2mmStandardPB.
function pix2mmStandardPB_Callback(hObject, eventdata, handles)
% hObject    handle to pix2mmStandardPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mmTable = [0 0 89 89; 0 75 0 75];
set(handles.pix2mmTable,'Data',mmTable);
setappdata(handles.output,'mmTable',mmTable);
end

% --- Executes on button press in pix2mmClearPB.
function pix2mmClearPB_Callback(hObject, eventdata, handles)
% hObject    handle to pix2mmClearPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mmTable = zeros(2,4);
set(handles.pix2mmTable,'Data',mmTable);
setappdata(handles.output,'mmTable',mmTable);
end

% --- Executes when entered data in editable cell(s) in pix2mmTable.
function pix2mmTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to pix2mmTable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
mmTable = getappdata(handles.output,'mmTable');
mmTable(eventdata.Indices(1),eventdata.Indices(2)) =eventdata.NewData;
setappdata(handles.output,'mmTable',mmTable);
end



function traRepNoEdit_Callback(hObject, eventdata, handles)
% hObject    handle to traRepNoEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of traRepNoEdit as text
%        str2double(get(hObject,'String')) returns contents of traRepNoEdit as a double
setappdata(handles.output,'repetitions',  str2double(get(hObject,'String')));
end


% --- Executes during object creation, after setting all properties.
function traRepNoEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to traRepNoEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function traFpsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to traFpsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of traFpsEdit as text
%        str2double(get(hObject,'String')) returns contents of traFpsEdit as a double
setappdata(handles.output,'fps', str2double(get(hObject,'String')));

end

% --- Executes during object creation, after setting all properties.
function traFpsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to traFpsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function arenaHeightEdit_Callback(hObject, eventdata, handles)
% hObject    handle to arenaHeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of arenaHeightEdit as text
%        str2double(get(hObject,'String')) returns contents of arenaHeightEdit as a double
setappdata(handles.output,'arenaHeight',  str2double(get(hObject,'String')));
end


% --- Executes during object creation, after setting all properties.
function arenaHeightEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arenaHeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function butterDeg_Callback(hObject, eventdata, handles)
% hObject    handle to butterDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of butterDeg as text
%        str2double(get(hObject,'String')) returns contents of butterDeg as a double
setappdata(handles.output,'butterDeg', str2double(get(hObject,'String')) );
end


% --- Executes during object creation, after setting all properties.
function butterDeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to butterDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



function butterCOEdit_Callback(hObject, eventdata, handles)
% hObject    handle to butterCOEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of butterCOEdit as text
%        str2double(get(hObject,'String')) returns contents of butterCOEdit as a double
setappdata(handles.output,'butterCutOff',  str2double(get(hObject,'String')));
end


% --- Executes during object creation, after setting all properties.
function butterCOEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to butterCOEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in sepLoadDlg.
function sepLoadDlg_Callback(hObject, eventdata, handles)
% hObject    handle to sepLoadDlg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in multLoadPB.
function multLoadPB_Callback(hObject, eventdata, handles)
% hObject    handle to multLoadPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end