function varargout = ivT_GUI_2Deccentricity(varargin)
% IVT_GUI_2DECCENTRICITY MATLAB code for ivT_GUI_2Deccentricity.fig
%      IVT_GUI_2DECCENTRICITY, by itself, creates a new IVT_GUI_2DECCENTRICITY or raises the existing
%      singleton*.
%
%      H = IVT_GUI_2DECCENTRICITY returns the handle to a new IVT_GUI_2DECCENTRICITY or the handle to
%      the existing singleton*.
%
%      IVT_GUI_2DECCENTRICITY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVT_GUI_2DECCENTRICITY.M with the given input arguments.
%
%      IVT_GUI_2DECCENTRICITY('Property','Value',...) creates a new IVT_GUI_2DECCENTRICITY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ivT_GUI_2Deccentricity_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ivT_GUI_2Deccentricity_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ivT_GUI_2Deccentricity

% Last Modified by GUIDE v2.5 15-May-2014 15:58:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ivT_GUI_2Deccentricity_OpeningFcn, ...
    'gui_OutputFcn',  @ivT_GUI_2Deccentricity_OutputFcn, ...
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

% --- Executes just before ivT_GUI_2Deccentricity is made visible.
function ivT_GUI_2Deccentricity_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ivT_GUI_2Deccentricity (see VARARGIN)

% Choose default command line output for ivT_GUI_2Deccentricity
handles.output = hObject;
setappdata(handles.output,'PixBox', []);
setappdata(handles.output,'PixFpos','');
setappdata(handles.output,'traceRaw', []);
setappdata(handles.output,'trace', []);
setappdata(handles.output,'tempDataRaw', []);
setappdata(handles.output,'tempData', []);
setappdata(handles.output,'tempTrace', []);
setappdata(handles.output,'filter', 0);
setappdata(handles.output,'workDir', pwd);
setappdata(handles.output,'strain',[]);
setappdata(handles.output,'notes',[]);
setappdata(handles.output,'dataSaved',1);
setappdata(handles.output,'mainCalcDone',0);
setappdata(handles.output,'RB_calcOptions','distance');
setappdata(handles.output,'RB_pixArena','rectangular arena');
setappdata(handles.output,'RB_plotType','yaw');
setappdata(handles.output,'RB_saveOption','struct-allTRAdata');
setappdata(handles.output,'CB_plotFilter',0);
setappdata(handles.output,'pixTable', []);
setappdata(handles.output,'analysisData', struct);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ivT_GUI_2Deccentricity wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = ivT_GUI_2Deccentricity_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end

%%%%%%%%%%%%%%%%%%%
% STEP 1: PIX BOX %
%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in PB_PixBox.
function PB_PixBox_Callback(hObject, eventdata, handles)
% hObject    handle to PB_PixBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fname,path]=uigetfile({'*.jpg';'*.png';'*.tif';'*.*'},'Pick trajectory frame');
% xompile abs. position
frameS = imread([path fname]);
setappdata(handles.output,'PixFpos',[path fname]);

pixArena = getappdata(handles.output,'RB_pixArena');
switch pixArena,
    case 'circular arena'
        pixBox =  ivT_pixCircleGUI(frameS,colormap('gray'));
    case 'rectangular arena'
        pixBox =  ivT_pixBoxGUI(frameS,colormap('gray'));
    case 'line calib.'
        pixBox = ivT_pixLineGUI(frameS,colormap('gray'));
end
%get data from table
if strcmp(pixArena,'line calib.')
    pixTable = num2cell(pixBox);
    pixTable = cellfun(@num2str,pixTable,'UniformOutput',false);
    pixTable = [pixTable(1:4,:)';pixTable(5:8,:)'];
    set(handles.uitable1,'Data',pixTable);
    setappdata(handles.output,'PixBox',pixBox);
    setappdata(handles.output,'workDir', path);
else
    pixTable = get(handles.uitable1,'Data')';
    for i=1:8,
        pixTable{i+8} = num2str(pixBox(i));
    end
    set(handles.uitable1,'Data',pixTable');
    setappdata(handles.output,'PixBox',pixBox);
    setappdata(handles.output,'workDir', path);
end
end

% --- Executes on button press in PB_pixLine.
function PB_pixLine_Callback(hObject, eventdata, handles)
% hObject    handle to PB_pixLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in PB_multiTempArena.
function PB_multiTempArena_Callback(hObject, eventdata, handles)
% hObject    handle to PB_multiTempArena (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pixTable ={'0','0' ,'100','100';...
           '0','75','75' ,'0';...
           'please'  ,'use','pix','box';...
           'on','back','ground'   ,'!'};
set(handles.uitable1,'Data',pixTable);
end

% --- Executes on button press in PB_PBdataLarvaLoc.
function PB_PBdataLarvaLoc_Callback(hObject, eventdata, handles)
% hObject    handle to PB_PBdataLarvaLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pixTable ={'0','0'    ,'107.73','107.73';...
           '0','88.76','88.76','0';...
           '0'  ,'0','1024','1024';...
           '768','0','0'   ,'768'};
set(handles.uitable1,'Data',pixTable);
end


% --- Executes on button press in PB_loadPixTable.
function PB_loadPixTable_Callback(hObject, eventdata, handles)
% hObject    handle to PB_loadPixTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,path]=uigetfile('*.mat','load pixBox-Matfile');
% xompile abs. position
pixTable = load2var([path fname]);
set(handles.uitable1,'Data',pixTable);
end

% --- Executes on button press in PB_savePixTable.
function PB_savePixTable_Callback(hObject, eventdata, handles)
% hObject    handle to PB_savePixTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pixTable = get(handles.uitable1,'Data');
cd(getappdata(handles.output,'workDir'));
[file,path] = uiputfile('pixTable.mat','Save pixBox');
save([path file],'pixTable')
end

% --- Executes when selected object is changed in PanelR_PixBox.
function PanelR_PixBox_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in PanelR_PixBox 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
pixArena = get(eventdata.NewValue,'String');
setappdata(handles.output,'RB_pixArena',pixArena);

end

%%%%%%%%%%%%%%%%%%%%
% STEP 2: LOAD TRA %
%%%%%%%%%%%%%%%%%%%%


% --- Executes on key press with focus on traNoE and none of its controls.
function traNoE_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to traNoE (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Background',[0.701961 0.701961 0.701961]);
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over traNoE.
function traNoE_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to traNoE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Background',[0.701961 0.701961 0.701961]);
end


function Edit_fps_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_fps as text
%        str2double(get(hObject,'String')) returns contents of Edit_fps as a double

end

% --- Executes during object creation, after setting all properties.
function Edit_fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    
end
end


% --- Executes on key press with focus on Edit_fps and none of its controls.
function Edit_fps_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Edit_fps (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Background',[0.701961 0.701961 0.701961]);
end

% --- Executes on button press in PB_loadTRA.
function PB_loadTRA_Callback(hObject, eventdata, handles)
% hObject    handle to PB_loadTRA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

goOn = 1;


% old data 
SR_check4oldData(handles);

% Filter Check 
%update the trajectory date
SR_getFilter(hObject, eventdata, handles);
% get saved trajectory start date
fchoiceNum = getappdata(handles.output,'filter');
% this is compared to the default value when no trajectory was ever
% recorded
if fchoiceNum == 0  && goOn ==1,
    goOn = 0;
    errordlg(['You did not pick a filter setting' ...
        'Please correct and try again'],'Filter Error');
end

% PixBox Check
if SR_checkTable(handles) == 0;
    goOn =0;
end

% Check Strain Name
if isempty(SR_checkStrainName(handles));
    goOn =0;
end

%get frame rate
frameRate = str2double(get(handles.Edit_fps,'String'));


if goOn,
    % get the PixBox from handles
    pixTable = cell2mat(cellfun(@(x) str2double(x),get(handles.uitable1,'Data'),'UniformOutput',false));
    
    % get the animal traces from the MatLabCode in the edit field (see GUI)
    traceID = get(handles.traNoE,'String');
    if ~strcmp(traceID,'all'),
        eval(['traceID = ' get(handles.traNoE,'String') ';']);
    end
    
    %get file position of trajectory
    [fname,path]=uigetfile('*.tra','Pick ivTrace trajectory');
    % xompile abs. position
    traceFP = [path fname];
    
    % read data
    trace = ivT_IO_readMultFullIVtrace(traceFP,traceID);
    [r,c,p] = size(trace);
    traceA = NaN(r,c+3,p);
    %interpolate from pixels to milimeter
    mmTRA = ivT_pix2mm(pixTable(3:4,:)',pixTable(1:2,:)',trace(:,1:2,:));
    %unwrap yaw angle
    for i =1:size(mmTRA,3)
        yaw = ivT_unwrapAtan2(trace(:,3,i));
        temp = filter3DTrace([mmTRA(:,:,i),yaw],fchoiceNum);
        temp = [ temp filter2DTrace(trace(:,4:5,i),fchoiceNum) [IV_2Dtrace_calcAnimalSpeed(temp(:,1:3)) [diff(rad2deg(temp(:,3)));NaN]].*frameRate];
        traceA(:,:,i) = temp;
    end
    
    
    % save data to figure memory
    setappdata(handles.output,'traceRaw', trace);
    setappdata(handles.output,'trace', traceA);
    setappdata(handles.output,'pixTable', pixTable);
    setappdata(handles.output,'dataSaved',0);
    setappdata(handles.output,'mainCalcDone',0);
    set(handles.uitable2,'Data',NaN(6,2));
    % set flag variable to new unsaved data
end
end

% --- Executes on selection change in popupmenuFilter.
function popupmenuFilter_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuFilter contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuFilter

end

% --- Executes during object creation, after setting all properties.1
function popupmenuFilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function traNoE_Callback(hObject, eventdata, handles)
% hObject    handle to traNoE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of traNoE as text
%        str2double(get(hObject,'String')) returns contents of traNoE as a double
end

% --- Executes during object creation, after setting all properties.
function traNoE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to traNoE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
contents = cellstr(get(hObject,'String'));
setappdata(handles.output,'strain',contents{get(hObject,'Value')});

end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function commentE_Callback(hObject, eventdata, handles)
% hObject    handle to commentE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of commentE as text
%        str2double(get(hObject,'String')) returns contents of commentE as a double
end

% --- Executes during object creation, after setting all properties.
function commentE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to commentE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%%%%%%%%%%%%%%%%%%%%
% STEP 3: ANALYSIS %
%%%%%%%%%%%%%%%%%%%%

% SAVE ALL DATA IN setappdata(handles.output,'analysisData',struct)

% --- Executes on button press in PB_ROI1.
function PB_ROI1_Callback(hObject, eventdata, handles)
% hObject    handle to PB_ROI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SR_getROI(handles,1)
end

% --- Executes on button press in PB_ROI2.
function PB_ROI2_Callback(hObject, eventdata, handles)
% hObject    handle to PB_ROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SR_getROI(handles,2)
end


% --- Executes on button press in PB_ROI3.
function PB_ROI3_Callback(hObject, eventdata, handles)
% hObject    handle to PB_ROI3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SR_getROI(handles,3)
end


% --- Executes on button press in PB_ROI4.
function PB_ROI4_Callback(hObject, eventdata, handles)
% hObject    handle to PB_ROI4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SR_getROI(handles,4)
end


% --- Executes on button press in PB_ROI5.
function PB_ROI5_Callback(hObject, eventdata, handles)
% hObject    handle to PB_ROI5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SR_getROI(handles,5)
end


% --- Executes on button press in PB_ROI6.
function PB_ROI6_Callback(hObject, eventdata, handles)
% hObject    handle to PB_ROI6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SR_getROI(handles,6)
end


% --- Executes on button press in PB_calculate.
function PB_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to PB_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% calculation part
if getappdata(handles.output,'mainCalcDone') == 0,
    
    % get data
    trace = getappdata(handles.output,'trace');
    frameRate = str2double(get(handles.Edit_fps,'String'));
    [startsNends,checkRes] = SR_checkSETable(handles);
    if checkRes == 0,
        startsNends = [0 size(trace,1)./frameRate];
    end
    
    % define eccentricity measure
    xVal = bsxfun(@minus, trace(:,1,2),trace(:,1,3));
    yVal = bsxfun(@minus, trace(:,2,2),trace(:,2,3));
    sumVal = bsxfun(@plus,xVal.^2,yVal.^2);
    bodyLength = sqrt(sumVal);
    
    
    
    
    %get idx from sec
    xAxis = (1:size(trace,1))/frameRate;
    for i =1:numel(startsNends);
        diffFunc = abs(xAxis-startsNends(i));
        [~,startsNends(i)] = min(diffFunc);
    end
    
    pks = [];
    los = [];
    speed = [];
    distance = [];
    
    for i =1:size(startsNends,1),
        %get peaks and lows
        eccTemp = trace(startsNends(i,1):startsNends(i,2),5);
        minHeight = median(eccTemp);
        [losTemp,pksTemp] = DLM_ana_excenPeaks(eccTemp,2,minHeight,0);
        losTemp(:,1) = losTemp(:,1)+startsNends(i,1);
        pksTemp(:,1) = pksTemp(:,1)+startsNends(i,1);
        pks = [pks;pksTemp];
        los = [los;losTemp];
        %get speeds
        speed =[speed; sum(abs(trace(startsNends(i,1):startsNends(i,2),6:7)),2)];
        %get distance traveled
        distance = [distance; diff(trace(:,1:2))];
        
    end
    % get frequency
    periode = DLM_ana_excenPeriod(pks,frameRate);
    frequency = periode.^-1;
    
    %get wave
    win = round(median(frequency))*frameRate;
    rythmn = DLM_ana_excenRythmn(trace(:,5),pks,win/2);
    meanRythmn = mean(rythmn);
    steRythmn = ste(rythmn,[],1);
    
    %sum up distance
    distance = sum(sum(distance));
    
    %amplitude
    amp = NaN(size(pks,1),2);
    for i =1:size(pks,1)
        
        diffFunc = abs(los(:,1)-pks(i,1));
        [~,idx] = min(diffFunc);
        amp(i,:) = [pks(i,2)-los(idx(1),2) bodyLength(pks(i,1))-bodyLength(los(idx(1),1))];
    end
    
    
    dataResults.pks = pks;
    dataResults.los = los;
    dataResults.amp = amp;
    dataResults.frequency = frequency;
    dataResults.fps = frameRate;
    dataResults.rythmn    = rythmn;
    dataResults.rythmnM   = meanRythmn;
    dataResults.rythmnSTE = steRythmn;
    dataResults.distance = distance;
    dataResults.speed = speed;
    dataResults.bodyLength = bodyLength;
    dataResults.bodyLExtremes = [min(bodyLength) max(bodyLength)];
    dataResults.bodyLmean = [mean(bodyLength(pks(:,1))) mean(bodyLength(los(:,1)));...
        ste(bodyLength(pks(:,1)),[],1) ste(bodyLength(los(:,1)),[],1)];
    dataResults.time = xAxis;
    
    setappdata(handles.output,'analysisData',dataResults)
    setappdata(handles.output,'mainCalcDone',1);
end
% plotting
SR_plotAnalysisData(handles)
end


% --- Executes when selected object is changed in PanelCalculateOptions.
function PanelCalculateOptions_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in PanelCalculateOptions 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

calcOption = get(eventdata.NewValue,'String');
setappdata(handles.output,'RB_calcOptions',calcOption);
end
%%%%%%%%%%%%%%%%%%%%%
% STEP 4: SAVE DATA %
%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in PB_saveData.
function PB_saveData_Callback(hObject, eventdata, handles)
% hObject    handle to PB_saveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('data.mat','Save file name');

switch getappdata(handles.output,'RB_saveOption')
        case 'only pixel TRA'
            trace = getappdata(handles.output,'traceRaq');
            strain = getappdata(handles.output,'strain');
            notes = get(handles.commentE,'String');
            save([path file],'trace','strain','notes');
        case 'struct-pix-mm'
            data.pixTra = getappdata(handles.output,'traceRaw');
            data.strain = getappdata(handles.output,'strain');
            data.comment =get(handles.commentE,'String'); 
            data.anaTRA = getappdata(handles.output,'trace');
            data.pixTable = getappdata(handles.output,'pixTable');
            save([path file],'data');
            
        case 'struct-allTRAdata'
            data.pixTra = getappdata(handles.output,'traceRaw');
            data.strain = getappdata(handles.output,'strain');
            data.comment = get(handles.commentE,'String');
            data.anaTRA = getappdata(handles.output,'trace');
            data.pixTable = getappdata(handles.output,'pixTable');
            data.analysisResult = getappdata(handles.output,'analysisData');
            save([path file],'data');
            
        case 'struct-all+pixImage'
            
            fPos= getappdata(handles.output,'PixFpos');
            if isempty(fPos)
                frameS = [];
                warndlg('No image was used to determine pixBox so no image can be saved!')
            else
            frameS = imread(fPos);
            end
            data.pixTra = getappdata(handles.output,'traceRaw');
            data.strain = getappdata(handles.output,'strain');
            data.comment = get(handles.commentE,'String');
            data.anaTRA = getappdata(handles.output,'trace');
            data.pixTable = getappdata(handles.output,'pixTable');
            data.analysisResult = getappdata(handles.output,'analysisData');
            data.backGroundImg = frameS;
            save([path file],'data');
            
end


setappdata(handles.output,'dataSaved',1);

end

% --- Executes when selected object is changed in Panel_SaveOptions.
function Panel_SaveOptions_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Panel_SaveOptions 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
saveChoice = get(eventdata.NewValue,'String');
setappdata(handles.output,'RB_saveOption',saveChoice);
end

%%%%%%%%%%%%%%%%%%%%
% PLOTTING OPTIONS %
%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in CB_filterPlot.
function CB_filterPlot_Callback(hObject, eventdata, handles)
% hObject    handle to CB_filterPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_filterPlot

setappdata(handles.output,'CB_plotFilter',get(hObject,'Value'));
end



% --- Executes on button press in PB_plot.
function PB_plot_Callback(hObject, eventdata, handles)
% hObject    handle to PB_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%1st PlotSR_check4oldData
axes(handles.axes1);
traceA = getappdata(handles.output,'trace');
plotAnimal = get(handles.edit_plotArea,'String');
step  = round(size(traceA,1)/50);
tailLen = 2; % 2mm is a real Drosophila
pixTable = getappdata(handles.output,'pixTable');

if strcmp(plotAnimal,'all')
    animalNo = size(traceA,3);
    if getappdata(handles.output,'CB_plotFilter')==1,
        traceR = getappdata(handles.output,'traceRaw');
        mmTRA = ivT_pix2mm(pixTable(3:4,:)',pixTable(1:2,:)',traceR(:,1:2,:));
        cla(handles.axes1)
        for i =1:animalNo,
            hold on
            IV_plot_2Dlolipop(traceA(:,1:3,i),step,tailLen,1,'darkgray')
            hold on
            plot(mmTRA(:,1,i),mmTRA(:,2,i),'g--')
        end
        hold off
    else
        cla(handles.axes1)
        for i =1:animalNo,
            hold on
            IV_plot_2Dlolipop(traceA(:,1:3,i),step,tailLen,1,'darkgray')
            hold on
        end
        hold off
    end
    
else
    plotAnimal = str2double(plotAnimal);
    cla(handles.axes1)
    IV_plot_2Dlolipop(traceA(:,1:3,plotAnimal),step,tailLen,1,'darkgray')

    if getappdata(handles.output,'CB_plotFilter')==1,
        traceR = getappdata(handles.output,'traceRaw');
        mmTRA = ivT_pix2mm(pixTable(3:4,:)',pixTable(1:2,:)',traceR(:,1:2,plotAnimal));
        hold on
        plot(handles.axes1,mmTRA(:,1),mmTRA(:,2),'g--')
        hold off
    end
end




% 2nd plot
axes(handles.axes2);
cla(handles.axes2);
plotType = getappdata(handles.output,'RB_plotType');
frameRate = str2double(get(handles.Edit_fps,'String'));
xAxis = (1:size(traceA,1))/frameRate;

if strcmp(plotAnimal,'all')
    cMap = jet(size(traceA,3));
    switch plotType
        case 'yaw'
            for i =1:animalNo,
                hold on
                plot(xAxis,traceA(:,end,i) ,'color',cMap(i,:))
                hold off
            end
            ylabel('yaw velocity [deg*s^-^1]')
        case 'thrust'
            for i =1:animalNo,
                hold on
                plot(xAxis,traceA(:,end-2,i) ,'color',cMap(i,:))
                hold off
            end
            ylabel('thrust [mm*s^-^1]')
        case 'slip'
            for i =1:animalNo,
                hold on
                plot(xAxis,traceA(:,end-1,i) ,'color',cMap(i,:))
                hold off
            end
            ylabel('slip [mm*s^-^1]')
        case 'eccentricity'
            for i =1:animalNo,
                hold on
                plot(xAxis,traceA(:,5,i) ,'color',cMap(i,:))
                hold off
            end
            ylabel('eccentricity [aU]')
    end
    

else

    switch plotType
        case 'yaw'
            plot(xAxis,traceA(:,end,plotAnimal))
            ylabel('yaw velocity [deg*s^-^1]')
        case 'thrust'
            plot(xAxis,traceA(:,end-2,plotAnimal) )
            ylabel('thrust [mm*s^-^1]')
        case 'slip'
            plot(xAxis,traceA(:,end-1,plotAnimal) )
            ylabel('slip [mm*s^-^1]')
        case 'eccentricity'
            plot(xAxis,traceA(:,5,plotAnimal) )
            ylabel('eccentricity [aU]')
    end
end
xlabel('time [s]')



end

% --- Executes when selected object is changed in RB_secondaryPlot.
function RB_secondaryPlot_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in RB_secondaryPlot 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
plotChoice = get(eventdata.NewValue,'String');
setappdata(handles.output,'RB_plotType',plotChoice);
end

function edit_plotArea_Callback(hObject, eventdata, handles)
% hObject    handle to edit_plotArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_plotArea as text
%        str2double(get(hObject,'String')) returns contents of edit_plotArea as a double

end

% --- Executes during object creation, after setting all properties.
function edit_plotArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_plotArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


%%%%%%%%%%%%%%%%
% CLOSE Figure %
%%%%%%%%%%%%%%%%

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);

end

%%%%%%%%%%%%%%%%%%%%%%
% Shortcut functions %
%%%%%%%%%%%%%%%%%%%%%%

function SR_check4oldData(handles)
% This  function checks if there is old data and what to do with it before
% loading new data or closing the figure.

goOn = 1;
if ~getappdata(handles.output,'dataSaved'),
    % Construct a questdlg with three options
    choice = questdlg('There are calculated results! Save Before Closing?', ...
        'Save old data', ...
        'Abort Closing','Save Data','Abort old Data','Abort Closing');
    % Handle response
    switch choice
        case 'Abort Closing'
            goOn = 0;
        case 'Save Data'
            PB_saveData_Callback(hObject, eventdata, handles);
        case 'Abort old Data'
            goOn = 1;
    end
end


end

function SR_getFilter(hObject, eventdata, handles),
% This function gets filter choice from the popdown menu filterPM and
% converts them to the number code used by filter3DTrace
contents = cellstr(get(handles.popupmenuFilter,'String'));
choice = contents{get(handles.popupmenuFilter,'Value')} ;

switch choice
    case 'Filter Menu'
        choiceNum = 0;
    case 'Butterworth (2nd deg | 0.1 CO)'
        choiceNum = 3;
    case 'Butterworth (2nd deg | 0.05 CO)'
        choiceNum = 4;
    case 'Butterworth (3nd deg | 0.1 CO)'
        choiceNum = 5;
    case 'Savitzky-Golay (3,21)'
        choiceNum = 1;
    case 'Savitzky-Golay (3,31)'
        choiceNum = 2;
    case 'Gauss (50 frame win | 3 sigma)'
        choiceNum = 6;
    case 'none'
        choiceNum = 666;
end

setappdata(handles.output,'filter', choiceNum);

end

function checkRes = SR_checkTable(handles),
% This function checks if the pix table is in correct order and only holds
% numbers as well as no emtpy fields.

% variable declaration
checkRes = 1;
% get table Data
pixTable = get(handles.uitable1,'Data');
% check empty fields
empty16 = cellfun(@isempty,pixTable);
% check if all fields are Numbers 
NaNmat = cellfun(@(x) all(ismember(x, '0123456789+-.')),pixTable );

% check empties and NaNs
if sum(sum(empty16)) ~= 0,
    checkRes = 0;
    emptyFields =find(empty16' == 1)';
    errorStr = ['The following cells in the pix table are empty: ' ...
                num2str(emptyFields) ' !'];
    errordlg(errorStr,'Empty fields in pix-Table');
elseif sum(sum(NaNmat)) ~= 16
    checkRes = 0;
    nanFields =find(NaNmat' == 0)';
    errorStr = ['The following cells in the pix table are not numbers: ' ...
                num2str(nanFields) ' !'];
    errordlg(errorStr,'NaN fields in pix-Table');

end

end

function checkRes = SR_checkStrainName(handles),
% This function checks if the pix table is in correct order and only holds
% numbers as well as no emtpy fields.
checkRes = 1;
strainSTR = getappdata(handles.output,'strain');

if strcmp(strainSTR,'') || strcmp(strainSTR,'Standard Strains'),
    checkRes = 0;
end
end


function [startsNends,checkRes] = SR_checkSETable(handles)
% variable declaration
startsNends = get(handles.uitable2,'Data');
%check if empty
if sum(sum(isnan(startsNends))) ==  12,
    startsNends = [];
else
    %check if uneven
        
         % get all non NAN fields
        startsNends = startsNends(~isnan(startsNends));
        % reshape to original form
        startsNends = reshape(startsNends,length(startsNends)/2,2);

end
checkRes =1;
end

function SR_plot_eccentricityROIs(handles,axesH)

[startsNends,checkRes] = SR_checkSETable(handles);


if checkRes ==1,
    %activate axes
    axes(axesH)
    %clear axes
    cla(axesH);
    %get data
frameRate = str2double(get(handles.Edit_fps,'String'));
    traceA = getappdata(handles.output,'trace');
    xAxis = (1:size(traceA,1))/frameRate;
    setappdata(handles.output,'time',xAxis)
    %plot eccentricity
    plot(xAxis,traceA(:,5) )
    ylabel('eccentricity [aU]')
    xlabel('time [s]')
    
    % Now add ROIs
    if ~isempty(startsNends)
        ymax = max(traceA(:,5));
        ymin = min(traceA(:,5));
        height = ymax-ymin;
        ROI_num = size(startsNends,1);
        cmap = jet(6);
        hold on
        for i = 1:ROI_num,
            h1 = fill([startsNends(i,1) startsNends(i,1) startsNends(i,2) startsNends(i,2)],...
                      [ymin ymax ymax ymin],cmap(i,:),'LineStyle','none','facealpha',.25);
            
        end
        hold off
    end
end


end


function SR_getROI(handles,ROI_nb)
%plot eccentricity in main windows
SR_plot_eccentricityROIs(handles,handles.axes1)
cla(handles.axes2)
% get new Roi1 coordinates
axes(handles.axes1)
[x,~] = ginput(2);
if x(2) < x(1)
    x = flipud(x);
end
time = getappdata(handles.output,'time');

if x(1) <time(1),
    x(1) = time(1);
end
if x(2) < time(2),
    x(2) = time(2)+1;
end

if x(2) > time(end),
    x(2) = time(end);
end
if x(1) > time(end),
    x(1) = time(end)-1;
end

% send to table
startsNends = get(handles.uitable2,'Data');
startsNends(ROI_nb,:) =x;
set(handles.uitable2,'Data',startsNends);

% plot new version
SR_plot_eccentricityROIs(handles,handles.axes1)

setappdata(handles.output,'mainCalcDone',0);
end


function SR_plotAnalysisData(handles)
% plotting lower axis
SR_plot_eccentricityROIs(handles,handles.axes2)
data = getappdata(handles.output,'analysisData');
% plot peak starts n ends
axes(handles.axes2)
hold on
plot(data.time(data.pks(:,1)),data.pks(:,2),'g*')
plot(data.time(data.los(:,1)),data.los(:,2),'r*')
hold off

% plotting upper axis
axes(handles.axes1)
cla(handles.axes1)

switch getappdata(handles.output,'RB_calcOptions')
    case 'velocity'
        hist(data.speed)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','b','EdgeColor','k')
        xlabel('frequency [Hz]')
        ylabel('count')
        
    case 'body length'
        plot(data.time,data.bodyLength,'k')
        ylabel('time [s]')
        ylabel('body length [mm]')
    case 'body Ex!'
        bodyEx  = data.bodyLExtremes;
        bodyM = fliplr(data.bodyLmean);
        bar([bodyEx(1) bodyM(1,:) bodyEx(2)])
        hold on
        h =errorbar(2:3,bodyM(1,:),bodyM(2,:),'k','Linewidth',1);
        hold off
        set(h,'LineStyle','none')
        set(gca,'XTickLabel',{'min. bodylength','mean peristaltic comp','mean peristaltic dial', 'max bodylength'})
        ylabel('body length [mm]')
        
        
    case 'distance'
        bar(data.distance)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','b','EdgeColor','k')
        xlim([0 2])
        ylabel('distance [mm]')
    case 'amplitude'
        axes(handles.axes1)
        cla(handles.axes1)
        hist(data.amp(:,2))
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','b','EdgeColor','k')
        ylabel('count')
        xlabel('bodylength amplitude [mm]')
        
        axes(handles.axes2)
        cla(handles.axes2)
        hist(data.amp(:,2))
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','b','EdgeColor','k')
        ylabel('count')
        xlabel('eccentricity amplitude [aU]')
    case 'mean Wave'
       errorareaTrans((1:length(data.rythmnM))./data.fps,data.rythmnM,data.rythmnSTE,'k','k',.25)
        ylabel('time [s]')
        ylabel('eccentricity [aU]')
       
    case 'frequency'
        hist(data.frequency)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','b','EdgeColor','k')
        xlabel('frequency [Hz]')
        ylabel('count')
end

end
