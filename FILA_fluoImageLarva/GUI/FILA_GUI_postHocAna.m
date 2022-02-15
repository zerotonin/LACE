function varargout = FILA_GUI_postHocAna(varargin)
% FILA_GUI_POSTHOCANA MATLAB code for FILA_GUI_postHocAna.fig
%      FILA_GUI_POSTHOCANA, by itself, creates a new FILA_GUI_POSTHOCANA or raises the existing
%      singleton*.
%
%      H = FILA_GUI_POSTHOCANA returns the handle to a new FILA_GUI_POSTHOCANA or the handle to
%      the existing singleton*.
%
%      FILA_GUI_POSTHOCANA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILA_GUI_POSTHOCANA.M with the given input arguments.
%
%      FILA_GUI_POSTHOCANA('Property','Value',...) creates a new FILA_GUI_POSTHOCANA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FILA_GUI_postHocAna_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FILA_GUI_postHocAna_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FILA_GUI_postHocAna

% Last Modified by GUIDE v2.5 25-Apr-2017 13:23:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FILA_GUI_postHocAna_OpeningFcn, ...
                   'gui_OutputFcn',  @FILA_GUI_postHocAna_OutputFcn, ...
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


% --- Executes just before FILA_GUI_postHocAna is made visible.
function FILA_GUI_postHocAna_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FILA_GUI_postHocAna (see VARARGIN)

% Choose default command line output for FILA_GUI_postHocAna
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FILA_GUI_postHocAna wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% user data
setappdata(handles.output,'strain','Drosophila');
setappdata(handles.output,'notes','');
setappdata(handles.output,'framePosMode','auto');
setappdata(handles.output,'dateMode','auto');
setappdata(handles.output,'dateNum',[]);
setappdata(handles.output,'anaResFpos','');
setappdata(handles.output,'workDir','');
setappdata(handles.output,'frameDir','');
setappdata(handles.output,'frameList',[]);
setappdata(handles.output,'frameExtension','*.tif')
setappdata(handles.output,'fps',50);
setappdata(handles.output,'mm2pix',0.005176);
setappdata(handles.output,'turnThresh',[]);
setappdata(handles.output,'wFthresh',0.2);
setappdata(handles.output,'anaRes',[]);
setappdata(handles.output,'anaMat',[]);
setappdata(handles.output,'resStr',[]);
setappdata(handles.output,'currentFrame',0);
setappdata(handles.output,'wFoffset',0);
setappdata(handles.output,'manWaves',[]);

% set editablility
set(handles.ed_date,'Enable','off');
set(handles.ed_fps,'Enable','on');
set(handles.ed_notes,'Enable','on');
set(handles.ed_turnThresh,'Enable','on');


% set strains PopMenu
strains = TMP_getStandardStrains;
strains = strains(:,1);
set(handles.pm_strains,'String',strains);
imshow(imread('FILA_GUI_splash.jpg'),'Parent',handles.axLarva)

%
clc

end

% --- Outputs from this function are returned to the command line.
function varargout = FILA_GUI_postHocAna_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%%%%%%%%%%%%
% FILE I/O %
%%%%%%%%%%%%

% --- Executes on button press in pb_loadAnaRes.
function pb_loadAnaRes_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadAnaRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
%get the mat file 
[filename, pathname] = ...
    uigetfile({'*.mat';'*.slx';'*.m';'*.*'},'Pick anaRes file');

if filename~= 0,
    
    %reset user data
    
    
    set(handles.txt_frameNum,'String',['found 0 frames'])
    setappdata(handles.output,'workDir','');
    setappdata(handles.output,'anaRes',[]);
    setappdata(handles.output,'anaMat',[]);
    setappdata(handles.output,'resStr',[]);
    setappdata(handles.output,'frameList',[]);
    setappdata(handles.output,'strain','Drosophila');
    setappdata(handles.output,'manWaves',[]);
   
    
    % save new user data
    setappdata(handles.output,'anaResFpos',[pathname filename]);
    setappdata(handles.output,'workDir',pathname);
    
    % auto mode of loading frames
    if strcmp(getappdata(handles.output,'framePosMode'),'auto'),
        
        setappdata(handles.output,'frameDir',[pathname 'Splits/']);
        frameList = getAllFilesLinux([pathname 'Splits/'],getappdata(handles.output,'frameExtension'));
        
    else % manual loading mode
        FILA_GUIphaSR_getFramesMan(handles)
    end
    
    anaRes = load2var(getappdata(handles.output,'anaResFpos'));
    if length(anaRes) < length(frameList),
        frameList = frameList(1:length(anaRes));
        set(handles.txt_frameNum,'String',['found ' num2str(size(frameList,1)) ' frames']);
    elseif length(anaRes) > length(frameList),
        anaRes = anaRes(1:length(frameList));
    else
 
        set(handles.txt_frameNum,'String',['found ' num2str(size(frameList,1)) ' frames']);
    end
        
    setappdata(handles.output,'anaRes',anaRes);
    setappdata(handles.output,'frameList',frameList);

    
    % set current frame
    if isempty(getappdata(handles.output,'frameList')),
        setappdata(handles.output,'currentFrame',0);
    else
        setappdata(handles.output,'currentFrame',length(frameList));
    end        
    
    
    % get date
    FILA_GUIphaSR_getDate(handles);
    % analyse new data
    FILA_GUIphaSR_analyseData(handles);
    %refresh plots
    FILA_GUIphaSR_refreshGUI(handles);
end

end

% --- Executes on selection change in pm_frameExt.
function pm_frameExt_Callback(hObject, eventdata, handles)
% hObject    handle to pm_frameExt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_frameExt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_frameExt
contents = cellstr(get(hObject,'String'));
setappdata(handles.output,'frameExtension', contents{get(hObject,'Value')});
end


% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

strain = getappdata(handles.output,'strain');
if strcmp(strain,'Drosophila') ||  strcmp(strain,'Strain Name'),
    errordlg('You forgot to choose a strain')
    
else
    notes = getappdata(handles.output,'notes');
    dateNum = getappdata(handles.output,'dateNum');
    anaResFpos = getappdata(handles.output,'anaResFpos');
    frameDir = getappdata(handles.output,'frameDir');
    fps = getappdata(handles.output,'fps');
    mm2pix = getappdata(handles.output,'mm2pix');
    turnThresh = getappdata(handles.output,'turnThresh');
    wFthresh = getappdata(handles.output,'wFthresh');
    frameData = getappdata(handles.output,'anaRes');
    anaMat = getappdata(handles.output,'anaMat');
    movieData = getappdata(handles.output,'resStr');
    
    metaData.strain = strain;
    metaData.notes = notes;
    metaData.dateNum = dateNum;
    metaData.anaResFpos = anaResFpos;
    metaData.frameDir = frameDir;
    daqData.fps = fps ;
    daqData.mm2pix = mm2pix;
    daqData.turnThresh = turnThresh;
    daqData.wFthresh = wFthresh;
    movieData.anaMat = anaMat;
    
    
    workDir=getappdata(handles.output,'workDir');
    
    [file,path] = uiputfile([ workDir 'larvaMotionAna.mat'],'Save file name');
    save([path file],'metaData','movieData','frameData')

end

end


% --- Executes when selected object is changed in uipanel8.
function uipanel8_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel8
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(eventdata.NewValue,'String'),'auto (../Splits)'),
    setappdata(handles.output,'framePosMode','auto');
else
    setappdata(handles.output,'framePosMode','man');
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%
% Region of Disinterest %
%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in pb_addROD.
function pb_addROD_Callback(hObject, eventdata, handles)
% hObject    handle to pb_addROD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,~] = ginput(2);
fps = getappdata(handles.output,'fps');
addIDX =round(x*fps);
resStr = getappdata(handles.output,'resStr');
turnSeq = resStr.turnSeq;
if addIDX(1) < addIDX(2),
    addage = addIDX(1) :addIDX(2);
else
    addage = addIDX(2) :addIDX(1);
end
turnSeq = [turnSeq;addage'];
turnSeq = sort(unique(turnSeq));
resStr.turnSeq=turnSeq;
setappdata(handles.output,'resStr',resStr);
% analyse again
FILA_GUIphaSR_reAnalyseData(handles)
% refresh plots
FILA_GUIphaSR_refreshGUI(handles)
    
end


% --- Executes on button press in pb_removeROD.
function pb_removeROD_Callback(hObject, eventdata, handles)
% hObject    handle to pb_removeROD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,~] = ginput(2);
fps = getappdata(handles.output,'fps');
remIDX =round(x*fps);
resStr = getappdata(handles.output,'resStr');
turnSeq = resStr.turnSeq;
if remIDX(1) < remIDX(2),
    IDX = turnSeq>=remIDX(1) &turnSeq<=remIDX(2);
else
    IDX = turnSeq>=remIDX(2) &turnSeq<=remIDX(1);
end
turnSeq(IDX) = [];
resStr.turnSeq=turnSeq;
setappdata(handles.output,'resStr',resStr);
% analyse again
FILA_GUIphaSR_reAnalyseData(handles)
% refresh plots
FILA_GUIphaSR_refreshGUI(handles)
    

end


% --- Executes on button press in pb_manWaveAdd.
function pb_manWaveAdd_Callback(hObject, eventdata, handles)
% hObject    handle to pb_manWaveAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
manWaves = getappdata(handles.output,'manWaves');
[x,~] = ginput(2);
fps = getappdata(handles.output,'fps');
remIDX =sort(round(x*fps))';
remIDX = [remIDX(:,1) round(mean(remIDX)) remIDX(:,2)];
setappdata(handles.output,'manWaves',[manWaves; remIDX]);
% analyse again
FILA_GUIphaSR_reAnalyseData(handles)
% refresh plots
FILA_GUIphaSR_refreshGUI(handles)


end

% --- Executes on button press in pb_manWaveRemLast.
function pb_manWaveRemLast_Callback(hObject, eventdata, handles)
% hObject    handle to pb_manWaveRemLast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
manWaves = getappdata(handles.output,'manWaves');
setappdata(handles.output,'manWaves',manWaves(1:end-1,:));
% analyse again
FILA_GUIphaSR_reAnalyseData(handles)
% refresh plots
FILA_GUIphaSR_refreshGUI(handles)
end

% --- Executes on button press in pb_manWaveReset.
function pb_manWaveReset_Callback(hObject, eventdata, handles)
% hObject    handle to pb_manWaveReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
manWaves = getappdata(handles.output,'manWaves');
setappdata(handles.output,'manWaves',[]);
% analyse again
FILA_GUIphaSR_reAnalyseData(handles)
% refresh plots
FILA_GUIphaSR_refreshGUI(handles)
end

% --- Executes on button press in pb_reana.
function pb_reana_Callback(hObject, eventdata, handles)
% hObject    handle to pb_reana (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FILA_GUIphaSR_analyseData(handles)
FILA_GUIphaSR_refreshGUI(handles)

end

% --- Executes on button press in pb_showFrame.
function pb_showFrame_Callback(hObject, eventdata, handles)
% hObject    handle to pb_showFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,~] = ginput(1);
fps = getappdata(handles.output,'fps');
setappdata(handles.output,'currentFrame',round(x*fps));
FILA_GUIphaSR_refreshLarva(handles)
end

function ed_turnThresh_Callback(hObject, eventdata, handles)
% hObject    handle to ed_turnThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_turnThresh as text
%        str2double(get(hObject,'String')) returns contents of ed_turnThresh as a double
if strcmp(get(hObject,'String'),'auto'),
    setappdata(handles.output,'turnThresh',[]);
else
    setappdata(handles.output,'turnThresh',str2double(get(hObject,'String')));
end
end

function ed_wFthresh_Callback(hObject, eventdata, handles)
% hObject    handle to ed_wFthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_wFthresh as text
%        str2double(get(hObject,'String')) returns contents of ed_wFthresh as a double
setappdata(handles.output,'wFthresh',str2double(get(hObject,'String')));
end


function ed_wFoffset_Callback(hObject, eventdata, handles)
% hObject    handle to ed_wFoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_wFoffset as text
%        str2double(get(hObject,'String')) returns contents of ed_wFoffset as a double
setappdata(handles.output,'wFoffset',str2double(get(hObject,'String')));
end

% --- Executes during object creation, after setting all properties.
function ed_wFoffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_wFoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function ed_mm2pix_Callback(hObject, eventdata, handles)
% hObject    handle to ed_mm2pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_mm2pix as text
%        str2double(get(hObject,'String')) returns contents of ed_mm2pix as a double
setappdata(handles.output,'mm2mpix',str2double(get(hObject,'String')));
end


function ed_fps_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fps as text
%        str2double(get(hObject,'String')) returns contents of ed_fps as a double
setappdata(handles.output,'fps',str2double(get(hObject,'String')));
end

%%%%%%%%%%%%%
% META DATA %
%%%%%%%%%%%%%

function ed_date_Callback(hObject, eventdata, handles) % Date Callback
% hObject    handle to ed_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_date as text
%        str2double(get(hObject,'String')) returns contents of ed_date as a double


% --- Executes during object creation, after setting all propertianaMates.
end


% --- Executes on selection change in pm_strains.
function pm_strains_Callback(hObject, eventdata, handles)
% hObject    handle to pm_strains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_strains contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_strains
contents = cellstr(get(hObject,'String'));
    setappdata(handles.output,'strain',contents{get(hObject,'Value')} );

end


function ed_notes_Callback(hObject, eventdata, handles)
% hObject    handle to ed_notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_notes as text
%        str2double(get(hObject,'String')) returns contents of ed_notes as a double
end

% --- Executes when selected object is changed in uipanel11.
function uipanel11_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel11 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(eventdata.NewValue,'String'),'auto (from filename)'),
    set(handles.ed_date,'Enable','off')
    setappdata(handles.output,'dateMode','auto');
else
    set(handles.ed_date,'Enable','on')
    setappdata(handles.output,'dateMode','man');
end
end


%%%%%%%%%%%%
% plotting %
%%%%%%%%%%%%

% --- Executes on button press in pb_movie.
function pb_movie_Callback(hObject, eventdata, handles)
% hObject    handle to pb_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in pb_refresh.
function pb_refresh_Callback(hObject, eventdata, handles)
% hObject    handle to pb_refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FILA_GUIphaSR_refreshGUI(handles)
end


% --- Executes on button press in pb_saveFig.
function pb_saveFig_Callback(hObject, eventdata, handles)
% hObject    handle to pb_saveFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
workDir=getappdata(handles.output,'workDir');

path = uigetdir(workDir,'figure folder');
str = {'*.jpg','*.eps','*.fig','all of them'};
[s,v] = listdlg('PromptString','Select a filetype:',...
    'SelectionMode','single',...
    'ListString',str);
if ishandle(100) && ishandle(101) && ishandle(102)
    if v==1,
        switch s,
            case 1
                for i = 100:102
                    saveas(i,[path filesep 'graphs_' num2str(i-99) '.jpg'])
                end
            case 3
                for i = 100:102
                    saveas(i,[path filesep 'graphs_' num2str(i-99) '.fig'])
                end
            case 2
                for i = 100:102
                    saveas(i,[path filesep 'graphs_' num2str(i-99) '.eps'])
                end
            case 4
                for i = 100:102
                    saveas(i,[path filesep 'graphs_' num2str(i-99) '.fig'])
                    saveas(i,[path filesep 'graphs_' num2str(i-99) '.eps'])
                    saveas(i,[path filesep 'graphs_' num2str(i-99) '.jpg'])
                end
        end
    else
        errordlg('make external figure first')
    end
end
end


% --- Executes on button press in pb_extFig.
function pb_extFig_Callback(hObject, eventdata, handles)
% hObject    handle to pb_extFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This function updates the plots of the GUI It does so in dependence of
% the different analysis states.

%get data
anaMat = getappdata(handles.output,'anaMat');
currentFrame  = getappdata(handles.output,'currentFrame');
anaRes = getappdata(handles.output,'anaRes');
resStr = getappdata(handles.output,'resStr');
fPos   = getappdata(handles.output,'frameList');
fps = getappdata(handles.output,'fps');
frameN = size(anaMat,1);
turnSeq = resStr.turnSeq;
completeWav = resStr.completeWaves;
waveT = getappdata(handles.output,'wFthresh');
thresholdTurning = getappdata(handles.output,'turnThresh');
if isempty(thresholdTurning),
     thresholdTurning = mean(anaMat(:,4)) +std(anaMat(:,4));
end


% create x-Axis for data plots
xAx = linspace(0,frameN/fps,frameN);

% the axis handles look swapped but this is not the plotted data but where
% it is plotted
axisHandles = [ handles.axWaveF handles.axTurn handles.axIbody handles.axObody];
dataN = [1 5 2 3];
ylabelStrs = {'waveFinder [aU]','turn Value [aU]','whole body [mm]','inner body [mm]'};
figure(100),clf
for i=1:4,
    hA = subaxis(4,1,i,'SpacingVert',0); 
    cla(hA)
    data=anaMat(:,dataN(i));
    if i ==1,
        data = zscore(data);
    end
    FILA_GUIphaSR_plotRODs(hA,xAx,turnSeq,frameN,data)
    hold(hA,'on')
    FILA_GUIphaSR_plotWavs(hA,completeWav,xAx,data)
    plot(hA,xAx,data,'Color',paletteKeiIto(i),'LineWidth',2)
    xlim(hA,[0 xAx(end)]);
    ylim(hA,[min(data) max(data)]);
    ylabel(hA,ylabelStrs{i})
    if mod(i,2) ~=1,
        set(hA,'YAxisLocation','right')
    else
        set(hA,'YAxisLocation','left')
    end
    if i ==2
        plot(hA,[0 xAx(end)],[thresholdTurning, thresholdTurning],'--','Color',paletteKeiIto(i))
        plot(hA,[0 xAx(end)],[thresholdTurning, thresholdTurning].*-1,'--','Color',paletteKeiIto(i))
    elseif i ==1,
        plot(hA,[0 xAx(end)],[waveT, waveT],'--','Color',paletteKeiIto(i))
        plot(hA,[0 xAx(end)],[waveT, waveT].*-1,'--','Color',paletteKeiIto(i))
    end
    if i ~=4,
        set(hA,'XTickLabel',[]);
    end
end
    xlabel(hA,'time [s]')

trigAve = resStr.trigAve;
trigAveN = resStr.trigAveN;
winSize = (((size(trigAve,2)-1)/2)/fps);
xAx2 = linspace(winSize.*-1,winSize,size(trigAve,2));

figure(101),clf
hA = subplot(2,2,1);
cla(hA)
errorareaTrans4GUI(xAx2,trigAve(1,:,1),trigAve(1,:,2),paletteKeiIto(3),paletteKeiIto(3),.25,hA)
set(hA,'XTickLabel',[])
title(hA,'whole body wave')
ylabel(hA,'mean length [mm]')

hA = subplot(2,2,2);
cla(hA)
errorareaTrans4GUI(xAx2,trigAve(2,:,1),trigAve(2,:,2),paletteKeiIto(4),paletteKeiIto(4),.25,hA)
set(hA,'XTickLabel',[])
title(hA,'inner body wave')
ylabel(hA,'mean length [mm]')
hA = subplot(2,2,3);
cla(hA)
errorareaTrans24GUI(xAx2,trigAveN(1,:,1),trigAveN(1,:,2),trigAveN(1,:,3),paletteKeiIto(3),paletteKeiIto(3),.25,hA)
title(hA,'whole body wave')
ylabel(hA,'median length [mm]')
xlabel(hA,'time [s]')

hA = subplot(2,2,4);
cla(hA)
errorareaTrans24GUI(xAx2,trigAveN(2,:,1),trigAveN(2,:,2),trigAveN(2,:,3),paletteKeiIto(4),paletteKeiIto(4),.25,hA)
title(hA,'inner body wave')
ylabel(hA,'median length [mm]')
xlabel(hA,'time [s]')

figure(102),clf
hA=gca;
FILA_GUIphaSR_refreshLarva(handles,hA)
end

%%%%%%%%%%%%%%%
% Subroutines %
%%%%%%%%%%%%%%%

function FILA_GUIphaSR_refreshGUI(handles),
% This function updates the plots of the GUI It does so in dependence of
% the different analysis states.
FILA_GUIphaSR_refreshLarva(handles)
%get data
anaMat = getappdata(handles.output,'anaMat');
anaRes = getappdata(handles.output,'anaRes');
resStr = getappdata(handles.output,'resStr');
fps    = getappdata(handles.output,'fps');
fPos   = getappdata(handles.output,'frameList');
frameN = size(anaMat,1);
turnSeq = resStr.turnSeq;
completeWav = resStr.completeWaves;
waveT = getappdata(handles.output,'wFthresh');
waveOS = getappdata(handles.output,'wFoffset');
thresholdTurning = getappdata(handles.output,'turnThresh');
if isempty(thresholdTurning),
     thresholdTurning = mean(anaMat(:,4)) +std(anaMat(:,4));
end


%FILA_plot_spineMovAna(anaRes,length(fPos),fps,fPos,figProps,currentframe,'Canton S')


% create x-Axis for data plots
xAx = linspace(0,frameN/fps,frameN);

% the axis handles look swapped but this is not the plotted data but where
% it is plotted
axisHandles = [ handles.axWaveF handles.axTurn handles.axIbody handles.axObody];
dataN = [1 5 2 3];
ylabelStrs = {'waveFinder [aU]','turn Value [aU]','whole body [mm]','inner body [mm]'};

for i=1:4,
    cla(axisHandles(i))
    data=anaMat(:,dataN(i));
    if i ==1,
        data = zscore(data);
    end
    FILA_GUIphaSR_plotRODs(axisHandles(i),xAx,turnSeq,frameN,data)
    hold(axisHandles(i),'on')
    FILA_GUIphaSR_plotWavs(axisHandles(i),completeWav,xAx,data)
    plot(axisHandles(i),xAx,data,'Color',paletteKeiIto(i),'LineWidth',2)
    xlim(axisHandles(i),[0 xAx(end)]);
    ylim(axisHandles(i),[min(data) max(data)]);
    ylabel(axisHandles(i),ylabelStrs{i})
    if mod(i,2) ~=1,
        set(axisHandles(i),'YAxisLocation','right')
    else
        set(axisHandles(i),'YAxisLocation','left')
    end
    if i ==2
        plot(axisHandles(i),[0 xAx(end)],[thresholdTurning, thresholdTurning],'--','Color',paletteKeiIto(i))
        plot(axisHandles(i),[0 xAx(end)],[thresholdTurning, thresholdTurning].*-1,'--','Color',paletteKeiIto(i))
    elseif i ==1,
        plot(axisHandles(i),[0 xAx(end)],[waveT, waveT]+waveOS,'--','Color',paletteKeiIto(i))
        plot(axisHandles(i),[0 xAx(end)],[waveT, waveT].*-1+waveOS,'--','Color',paletteKeiIto(i))
    end
    if i ~=4,
        set(axisHandles(i),'XTickLabel',[]);
    end
end

trigAve = resStr.trigAve;
trigAveN = resStr.trigAveN;
winSize = (((size(trigAve,2)-1)/2)/fps);
xAx2 = linspace(winSize.*-1,winSize,size(trigAve,2));

cla(handles.axOBTA1)
errorareaTrans4GUI(xAx2,trigAve(1,:,1),trigAve(1,:,2),paletteKeiIto(3),paletteKeiIto(3),.25,handles.axOBTA1);
set(handles.axOBTA1,'XTickLabel',[])
title(handles.axOBTA1,'whole body wave')
ylabel(handles.axOBTA1,'mean length [mm]')

cla(handles.axIBTA1)
errorareaTrans4GUI(xAx2,trigAve(2,:,1),trigAve(2,:,2),paletteKeiIto(4),paletteKeiIto(4),.25,handles.axIBTA1);
set(handles.axIBTA1,'XTickLabel',[])
title(handles.axIBTA1,'inner body wave')
ylabel(handles.axIBTA1,'mean length [mm]')

cla(handles.axOBTA2)
errorareaTrans24GUI(xAx2,trigAveN(1,:,1),trigAveN(1,:,2),trigAveN(1,:,3),paletteKeiIto(3),paletteKeiIto(3),.25,handles.axOBTA2);
set(handles.axOBTA2,'XTickLabel',[])
title(handles.axOBTA2,'whole body wave')
ylabel(handles.axOBTA2,'median length [mm]')

cla(handles.axIBTA2)
errorareaTrans24GUI(xAx2,trigAveN(2,:,1),trigAveN(2,:,2),trigAveN(2,:,3),paletteKeiIto(4),paletteKeiIto(4),.25,handles.axIBTA2);
title(handles.axIBTA2,'inner body wave')
ylabel(handles.axIBTA2,'median length [mm]')
xlabel(handles.axIBTA2,'time [s]')

FILA_GUIphaSR_updateTexts(handles);
FILA_GUIphaSR_updateTable(handles);

end

function FILA_GUIphaSR_updateTable(handles),
resStr = getappdata(handles.output,'resStr');

amp = flipud(resStr.bodyAmpValue');
amp = [amp(:,1) NaN(2,1) amp(:,2) NaN(2,1) amp(:,3) NaN(2,1)];
blen1 = resStr.bodyLen(:,1,2:-1:1);
blen1 = reshape(blen1,6,1);
blen1 = blen1([1 4 2 5 3 6])';
blen2 = resStr.bodyLen(:,2,2:-1:1);
blen2 = reshape(blen2,6,1);
blen2 = blen2([1 4 2 5 3 6])';
table = [blen1;blen2;amp];
set(handles.uitable1,'Data',num2cell(table))
end

function FILA_GUIphaSR_updateTexts(handles),
resStr = getappdata(handles.output,'resStr');
set(handles.txt_misPsec,'String',num2str(resStr.misWavNum))
set(handles.txt_turnPsec,'String',num2str(resStr.turnNum))
set(handles.txt_wavDur,'String',num2str(resStr.waveDur))
set(handles.txt_wavFreq,'String',num2str(resStr.waveFreq))
end

function FILA_GUIphaSR_plotWavs(axisHandle,completeWav,xAx,data),

       hold(axisHandle,'on')
       for k=1:size(completeWav,1)
           if mod(k,2) == 1,
           patch(xAx([completeWav(k,1) completeWav(k,3) completeWav(k,3) completeWav(k,1)]),...
                [min(data) min(data) max(data) max(data)],[.6 .6 .6],'Parent',axisHandle)
           else
           patch(xAx([completeWav(k,1) completeWav(k,3) completeWav(k,3) completeWav(k,1)]),...
                [min(data) min(data) max(data) max(data)],[.8 .8 .8],'Parent',axisHandle)
           end
       end
end

function FILA_GUIphaSR_plotRODs(axisHandle,xAx,turnSeq,frameN,data),
    if ~isempty(turnSeq),
        %make sequence of the temporary IDX
        
        temp = zeros(frameN,1);
        temp(turnSeq) =1;
        ind_diff   = diff(temp);
        ind_diff   = find(ind_diff);
        
        if temp(1) == 1,
            ind_diff=[1;ind_diff];
        end
        if temp(end) == 1,
            ind_diff=[ind_diff; length(temp)];
        end
       starts = ind_diff(1:2:end);
       stops = ind_diff(2:2:end);
       %find starts and stops of the RODS
       %draw a grey rectangle for every ROD
       hold(axisHandle,'on')
       for k=1:length(starts)
           patch(xAx([starts(k) stops(k) stops(k) starts(k)]),[min(data) min(data) max(data) max(data)],[0.2 0.2 0.8],'Parent',axisHandle)
       end
       hold(axisHandle,'off')
    end

end

function FILA_GUIphaSR_refreshLarva(handles,secondAxis),
% This function only updates the larva picture

% get the maximal values of the crop images
anaRes = getappdata(handles.output,'anaRes');
temp  = struct2cell(anaRes);
oB = cell2mat(temp(2,:)');
imExt = max(oB);
clear temp oB

% get needed data
fPos = getappdata(handles.output,'frameList');
frame = getappdata(handles.output,'currentFrame');
fps = getappdata(handles.output,'fps');
% image operations 
image = imread(fPos{frame});
bg = FILA_SR_normImage(image);


% create one struct that can be read by FILA_plot_spineAnalysis
temp = anaRes(frame);
temp.image = bg;
if exist('secondAxis','var'),
    FILA_plot_spineAnalysisHorizontal(temp,secondAxis,...
        ['frame #' num2str(frame) ' | second: ' num2str(round2digit(frame/fps,2))],...
        'WestOutside')
else
    
    FILA_plot_spineAnalysisHorizontal(temp,handles,...
        ['frame #' num2str(frame) ' | second: ' num2str(round2digit(frame/fps,2))],...
        'WestOutside')
end
end

function FILA_GUIphaSR_getDate(handles),
% This function tries to get the date from the path

% split working path in sub dirs
folders = strsplit(getappdata(handles.output,'workDir'),filesep);
% search in string for all possible digits
foundDigits = cellfun(@(x) strfind(folders,num2str(x)),num2cell(0:9),'UniformOutput',false);
% go from cell of cells to one giant cell and rearrange
foundDigits = [foundDigits{:}];
foundDigits = reshape(foundDigits,length(foundDigits)/10,10);
%now check howmany digits of one type were found in shich subfolder
foundDigits = cellfun(@length,foundDigits);
% sum the occurences of the different digits up
foundDigits = sum(foundDigits,2);
% one needs at least 6 digits for a scientific date!
dateFolder = find(foundDigits >= 6);

% if you find one folder with at least 6 digits all is fine
if length(dateFolder) ==1,
    dateStr = folders(dateFolder);
    try,
        dateNum = datenum(dateStr);
        set(handles.ed_date,'String',dateStr);
        setappdata(handles.output,'dateNum',dateNum);
    catch,
        warndlg('Date string was unidentifable, you have to add by hand');
        set(handles.ed_date,'Enable','on')
    end
    
else
    warndlg('Date string was unidentifable, you have to add by hand');
    set(handles.ed_date,'Enable','on')
end
end


function FILA_GUIphaSR_analyseData(handles),
clc
anaRes = getappdata(handles.output,'anaRes');
% make post hoc analysis

fps =getappdata(handles.output,'fps');
pix2mm  = getappdata(handles.output,'mm2pix');
thresholdWaves = getappdata(handles.output,'wFthresh');
offsetWaves = getappdata(handles.output,'wFoffset');
thresholdTurning = getappdata(handles.output,'turnThresh');
manWaves = getappdata(handles.output,'manWaves');


% do post hoc analysis
anaRes = FILA_ana_postAnalysis(anaRes,pix2mm);
% get data from struct
anaMat = FILA_ana_struct2mat(anaRes);
% get regions of disinterest
turnSeq = FILA_ana_getROD(anaMat,thresholdTurning);
% get compression and relaxtion peaks on wave Finder
[cLocs,sLocs,~,~] = FILA_ana_detectWave(anaMat(:,1),thresholdWaves,fps,offsetWaves);
% get complete waves
[completeWaves,~,misformedC,~] =FILA_ana_getCompleteWaves(cLocs,sLocs,turnSeq);

% add manualWaves
completeWaves =  [completeWaves; manWaves];

if isempty(completeWaves),
    errordlg('No complete waves found, you might want to change waveFinder offset or threshold!')
end

% analysis peristalsis
resStr = FILA_ana_peristalsis(anaMat,completeWaves,turnSeq,fps,misformedC);

%save data
setappdata(handles.output,'anaMat',anaMat);
setappdata(handles.output,'resStr',resStr);
setappdata(handles.output,'anaRes',anaRes);
end

function FILA_GUIphaSR_reAnalyseData(handles),
% make post hoc analysis

fps =getappdata(handles.output,'fps');
thresholdWaves = getappdata(handles.output,'wFthresh');
anaRes = getappdata(handles.output,'anaRes');
resStr = getappdata(handles.output,'resStr');
manWaves = getappdata(handles.output,'manWaves');

% get data from struct
anaMat = FILA_ana_struct2mat(anaRes);
% get regions of disinterest
turnSeq = resStr.turnSeq;
% get compression and relaxtion peaks on wave Finder
[cLocs,sLocs,~,~] = FILA_ana_detectWave(anaMat(:,1),thresholdWaves,fps);
% get complete waves
[completeWaves,~,misformedC,~] =FILA_ana_getCompleteWaves(cLocs,sLocs,turnSeq);

% add manualWaves
completeWaves =  [completeWaves; manWaves];

% analysis peristalsis
resStr = FILA_ana_peristalsis(anaMat,completeWaves,turnSeq,fps,misformedC);

%save data
setappdata(handles.output,'anaMat',anaMat);
setappdata(handles.output,'resStr',resStr);
setappdata(handles.output,'anaRes',anaRes);

end

function FILA_GUIphaSR_getFramesMan(handles),
% This function löoads the frame position manually

% Construct a questdl
choice = questdlg('Would you like to indicate the framefolder?', ...
    'Frames?', 'Yes','No thank you','Yes');
% Handle response
switch choice
    case 'Yes'
        % get frame directory
        dname = uigetdir(getappdata(handles.output,'workdir'));
        % get file format
        listString = get(handles.pm_frameExt,'String');
        [s,v] = listdlg('PromptString','Select a format:',...
            'SelectionMode','single',...
            'ListString',listString(2:end));
        % get frame positions
        if v ==1,
            frameList = getAllFilesLinux(dname,listString{s+1});
            setappdata(handles.output,'frameDir',dname);
            setappdata(handles.output,'frameList',frameList);
            set(handles.txt_frameNum,'String',['found ' num2str(size(frameList,1)) ' frames'])
            set(handles.pm_frameExt,'Value',s+1);
            setappdata(handles.output,'frameExtension', listString{s+1});
        end
    case 'No thank you'
        setappdata(handles.output,'frameList',[]);
end
end

%%%%%%%%%%%%%%%%%%%%
% CREATE Functions %
%%%%%%%%%%%%%%%%%%%%

function ed_date_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_date (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function pm_strains_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_strains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes during object creation, after setting all properties.
function ed_fDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function pm_frameExt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_frameExt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_turnThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_turnThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes during object creation, after setting all properties.
function ed_fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes during object creation, after setting all properties.
function ed_wFthresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_wFthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_mm2pix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_mm2pix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
