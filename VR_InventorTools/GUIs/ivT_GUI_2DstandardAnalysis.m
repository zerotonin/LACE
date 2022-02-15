function varargout = ivT_GUI_2DstandardAnalysis(varargin)
% IVT_GUI_2DSTANDARDANALYSIS MATLAB code for ivT_GUI_2DstandardAnalysis.fig
%      IVT_GUI_2DSTANDARDANALYSIS, by itself, creates a new IVT_GUI_2DSTANDARDANALYSIS or raises the existing
%      singleton*.
%
%      H = IVT_GUI_2DSTANDARDANALYSIS returns the handle to a new IVT_GUI_2DSTANDARDANALYSIS or the handle to
%      the existing singleton*.
%
%      IVT_GUI_2DSTANDARDANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IVT_GUI_2DSTANDARDANALYSIS.M with the given input arguments.
%
%      IVT_GUI_2DSTANDARDANALYSIS('Property','Value',...) creates a new IVT_GUI_2DSTANDARDANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ivT_GUI_2DstandardAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ivT_GUI_2DstandardAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ivT_GUI_2DstandardAnalysis

% Last Modified by GUIDE v2.5 12-Mar-2014 13:06:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ivT_GUI_2DstandardAnalysis_OpeningFcn, ...
    'gui_OutputFcn',  @ivT_GUI_2DstandardAnalysis_OutputFcn, ...
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

% --- Executes just before ivT_GUI_2DstandardAnalysis is made visible.
function ivT_GUI_2DstandardAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ivT_GUI_2DstandardAnalysis (see VARARGIN)

% Choose default command line output for ivT_GUI_2DstandardAnalysis
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
setappdata(handles.output,'RB_pixArena','rectangular arena');
setappdata(handles.output,'RB_plotType','yaw');
setappdata(handles.output,'RB_saveOption','struct-allTRAdata');
setappdata(handles.output,'CB_plotFilter',0);
setappdata(handles.output,'pixTable', []);
setappdata(handles.output,'analysisData', struct);
setappdata(handles.output,'mainCalcDone', 0);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ivT_GUI_2DstandardAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end

% --- Outputs from this function are returned to the command line.
function varargout = ivT_GUI_2DstandardAnalysis_OutputFcn(hObject, eventdata, handles)
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
end
pixBox =  ivT_pixBoxGUI(frameS,colormap('gray'));
%get data from table
pixTable = get(handles.uitable1,'Data')';
for i=1:8,
    pixTable{i+8} = num2str(pixBox(i));
end
set(handles.uitable1,'Data',pixTable');
setappdata(handles.output,'PixBox',pixBox);
setappdata(handles.output,'workDir', path);
setappdata(handles.output,'mainCalcDone', 0);

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
    
    % show that system is busy
    axes(handles.axes1)
    cla(handles.axes1)
    text(0.5,0.5,'trajectory loading ...','HorizontalAlignment','center','FontSize',20)
    axes(handles.axes2)
    cla(handles.axes2)
    text(0.5,0.5,'trajectory loading ...','HorizontalAlignment','center','FontSize',20)
    
    
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
        temp = [ temp trace(:,4:5,i) [IV_2Dtrace_calcAnimalSpeed(temp(:,1:3)) [diff(rad2deg(temp(:,3)));NaN]].*frameRate];
        traceA(:,:,i) = temp;
    end
    
    % show that system is available
    axes(handles.axes1)
    cla(handles.axes1)
    text(0.5,0.5,'trajectory available for analysis','HorizontalAlignment','center','FontSize',20)
    axes(handles.axes2)
    cla(handles.axes2)
    text(0.5,0.5,'trajectory available for analysis','HorizontalAlignment','center','FontSize',20)
    
    % save data to figure memory
    setappdata(handles.output,'traceRaw', trace);
    setappdata(handles.output,'trace', traceA);
    setappdata(handles.output,'pixTable', pixTable);
    setappdata(handles.output,'dataSaved',0);
    setappdata(handles.output,'mainCalcDone', 0);
    
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
    errorStr = ['The following cells in the pix Table are empty: ' ...
                num2str(emptyFields) ' !'];
    errordlg(errorStr,'Empty fields in pix-Table');
elseif sum(sum(NaNmat)) ~= 16
    checkRes = 0;
    nanFields =find(NaNmat' == 0)';
    errorStr = ['The following cells in the pix Table are not numbers: ' ...
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



function startTE_Callback(hObject, eventdata, handles)
% hObject    handle to startTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startTE as text
%        str2double(get(hObject,'String')) returns contents of startTE as a double
end



% --- Executes during object creation, after setting all properties.
function startTE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end




function endTE_Callback(hObject, eventdata, handles)
% hObject    handle to endTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endTE as text
%        str2double(get(hObject,'String')) returns contents of endTE as a double
end



% --- Executes during object creation, after setting all properties.
function endTE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end




function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double
end



% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes on button press in PB_defineSpeedThresh.
function PB_defineSpeedThresh_Callback(hObject, eventdata, handles)
% hObject    handle to PB_defineSpeedThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
