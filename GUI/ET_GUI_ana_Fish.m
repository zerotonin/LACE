function varargout = ET_GUI_ana_Fish(varargin)
% ET_GUI_ANA_FISH MATLAB code for ET_GUI_ana_Fish.fig
%      ET_GUI_ANA_FISH, by itself, creates a new ET_GUI_ANA_FISH or raises the existing
%      singleton*.
%
%      H = ET_GUI_ANA_FISH returns the handle to a new ET_GUI_ANA_FISH or the handle to
%      the existing singleton*.
%
%      ET_GUI_ANA_FISH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ET_GUI_ANA_FISH.M with the given input arguments.
%
%      ET_GUI_ANA_FISH('Property','Value',...) creates a new ET_GUI_ANA_FISH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ET_GUI_ana_Fish_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ET_GUI_ana_Fish_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ET_GUI_ana_Fish

% Last Modified by GUIDE v2.5 01-Nov-2021 16:19:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ET_GUI_ana_Fish_OpeningFcn, ...
                   'gui_OutputFcn',  @ET_GUI_ana_Fish_OutputFcn, ...
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


% --- Executes just before ET_GUI_ana_Fish is made visible.
function ET_GUI_ana_Fish_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ET_GUI_ana_Fish (see VARARGIN)

% Choose default command line output for ET_GUI_ana_Fish
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ET_GUI_ana_Fish wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%axis initialisation
set([handles.axes1,handles.axes2, handles.axes3, handles.axes4,...
    handles.axes5,handles.axes6 ],'XTickLabel','','YTickLabel','');
% user data

setappdata(handles.output,'traceResult',{});
setappdata(handles.output,'pix2mm',[]);
setappdata(handles.output,'movieFilePos',[]);
setappdata(handles.output,'matFilePos',[]);
setappdata(handles.output,'currentFrame',1);
setappdata(handles.output,'sliderPos', 0);
setappdata(handles.output,'butter_CO',0.05);
setappdata(handles.output,'butter_DEG',2);
setappdata(handles.output,'fps',200);
setappdata(handles.output,'expectedAnimals',1);
setappdata(handles.output,'saccThresh',500);
setappdata(handles.output,'saccs',[]);
setappdata(handles.output,'trigAveSacc',[]);
setappdata(handles.output,'trace',[]);
setappdata(handles.output,'minQual',[]);
setappdata(handles.output,'autoCorr',[]);
setappdata(handles.output,'strain',[]);
setappdata(handles.output,'experiment',[]);
setappdata(handles.output,'gender',[]);
setappdata(handles.output,'velocities',[]);
setappdata(handles.output,'bendability',[]);
setappdata(handles.output,'binnedBend',[]);
setappdata(handles.output,'saved',0);
setappdata(handles.output,'startFrame','start');
setappdata(handles.output,'lastFrame','end');
setappdata(handles.output,'headerSize',1024);
clc;
end


% --- Outputs from this function are returned to the command line.
function varargout = ET_GUI_ana_Fish_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB ROUTINES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ET_GUI_anaFish_SR_clearVar(handles)

    setappdata(handles.output,'traceResult',{});
    setappdata(handles.output,'movieFilePos',[]);
    setappdata(handles.output,'matFilePos',[]);
    setappdata(handles.output,'currentFrame',1);
    setappdata(handles.output,'sliderPos', 0);
    set(handles.slider4frames,'Value',0)
    setappdata(handles.output,'saccs',[]);
    setappdata(handles.output,'trigAveSacc',[]);
    setappdata(handles.output,'trace',[]);
    setappdata(handles.output,'minQual',[]);
    setappdata(handles.output,'autoCorr',[]);
    setappdata(handles.output,'strain',[]);
    setappdata(handles.output,'experiment',[]);
    setappdata(handles.output,'gender',[]);
    setappdata(handles.output,'velocities',[]);
    setappdata(handles.output,'bendability',[]);
    setappdata(handles.output,'binnedBend',[]);
    setappdata(handles.output,'saved',0);
    setappdata(handles.output,'startFrame','start');
    setappdata(handles.output,'lastFrame','end');
    setappdata(handles.output,'wholeTrace',1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PUSH BUTTONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in pb_loadTraceResult.
function pb_loadTraceResult_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadTraceResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(getappdata(handles.output,'movieFilePos')),
    errordlg('load movie first')
else
    [FileName,PathName] = uigetfile('*.mat','Select tracing result');
    if FileName ~=0,
        fps = getappdata(handles.output,'fps');
        load([PathName FileName]);
        setappdata(handles.output,'matFilePos',[PathName FileName]);
        
        setappdata(handles.output,'traceResult',traceResult);
        setappdata(handles.output,'pix2mm',pix2mm);
        title(handles.axes5,FileName);
        analyseTraceResult(hObject, eventdata, handles);
        refreshPlots(hObject, eventdata, handles);
    end
end
end


% --- Executes on button press in pb_loadSEQ.
function pb_loadSEQ_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadSEQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get file position
goOn = 1;
if ~isempty(getappdata(handles.output,'matFilePos')) && getappdata(handles.output,'saved') == 0,
    % Construct a questdlg with three options
    choice = questdlg('You analyed data and did not save it!', ...
        'Discard Data?', ...
        'Discard Data','Save Data','Abort','Abort');
    % Handle response
    switch choice
        case 'Discard Data'
            goOn = 1;
        case 'Save Data'
            pb_saveAnalsysis_Callback(hObject, eventdata, handles)
            goOn = 0;
        case 'Abort'
            disp('I''ll bring you your check.')
            goOn = 0;
    end
end
if goOn ==1,
    ET_GUI_anaFish_SR_clearVar(handles)
    [FileName,PathName] = uigetfile('*.seq','Select the norpix sequence file');
    if FileName ~=0,
        % file dialogue
        [fid, endianType,headerInfo,~, IDX] = ivT_norpix_openSeq([PathName FileName],'onlyHeader','');
        movieFpos.fid = fid;
        movieFpos.endianType = endianType;
        movieFpos.headerInfo = headerInfo;
        movieFPos.AllocatedFrames = headerInfo.AllocatedFrames;
        movieFpos.IDX = IDX;
        movieFpos.fPos = [PathName FileName];
        setappdata(handles.output,'movieFilePos',movieFpos);
        setappdata(handles.output,'movieIOtype','norpix');
        title(handles.axes5,FileName)
    end
end

end

% --- Executes on button press in pb_loadMov.
function pb_loadMov_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
goOn = 1;
if ~isempty(getappdata(handles.output,'matFilePos')) && getappdata(handles.output,'saved') == 0,
    % Construct a questdlg with three options
    choice = questdlg('You analyed data and did not save it!', ...
        'Discard Data?', ...
        'Discard Data','Save Data','Abort','Abort');
    % Handle response
    switch choice
        case 'Discard Data'
            goOn = 1;
        case 'Save Data'
            pb_saveAnalsysis_Callback(hObject, eventdata, handles)
            goOn = 0;
        case 'Abort'
            disp('I''ll bring you your check.')
            goOn = 0;
    end
end
if goOn ==1,
    ET_GUI_anaFish_SR_clearVar(handles)
    
    % get file position
    [FileName,PathName] = uigetfile({'*.avi';'*.mkv';'*.mp4';'*.ogg''*.*'},...
        'Select the norpix sequence file');
    if FileName ~=0,
        % file dialogue
        movieFpos.fPos = [PathName FileName];
        movObj= VideoReader(movieFpos.fPos);
        movieFpos.movObj = movObj;
        movieFpos.IDX = 1:movObj.NumberOfFrames;
        movieFpos.AllocatedFrames = movObj.NumberOfFrames;
        
        
        setappdata(handles.output,'movieFilePos',movieFpos);
        setappdata(handles.output,'movieIOtype','videoReader');
        set(handles.ed_startFrame,'String',1)
        set(handles.ed_lastFrame,'String',movObj.NumberOfFrames)
        setappdata(handles.output,'plotFrameStart', 1);
        setappdata(handles.output,'plotFrameStop', movObj.NumberOfFrames);
    end
end
end


% --- Executes on button press in pb_saveAnalsysis.
function pb_saveAnalsysis_Callback(hObject, eventdata, handles)
% hObject    handle to pb_saveAnalsysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
traceResult = getappdata(handles.output,'traceResult');
pix2mm = getappdata(handles.output,'pix2mm');
movieFilePos = getappdata(handles.output,'movieFilePos');
butter_CO = getappdata(handles.output,'butter_CO');
butter_DEG = getappdata(handles.output,'butter_DEG');
fps = getappdata(handles.output,'fps');
saccThresh = getappdata(handles.output,'saccThresh');
saccs = getappdata(handles.output,'saccs');
trigAveSacc = getappdata(handles.output,'trigAveSacc');
trace = getappdata(handles.output,'trace');
minQual = getappdata(handles.output,'minQual');
autoCorr = getappdata(handles.output,'autoCorr');
strain = getappdata(handles.output,'strain');
experiment = getappdata(handles.output,'experiment');
gender = getappdata(handles.output,'gender');
bendability = getappdata(handles.output,'bendability');
binnedBend = getappdata(handles.output,'binnedBend');
matFilePos = getappdata(handles.output,'matFilePos');
velocities = getappdata(handles.output,'velocities');

% make check List
checkList = zeros(1,5);
if isempty(matFilePos),
    checkList(1) =1;
end
if isempty(gender),
    checkList(2) =1;
end
if isempty(strain),
    checkList(3) =1;
end
if isempty(experiment),
    checkList(4) =1;
end
if isempty(trace),
    checkList(5) =1;
end

%decide if we are ready to save

if sum(checkList) == 0,
    defaultPos = [matFilePos(1:end-4) '_ana.mat' ];
    [file,path] = uiputfile('*.mat','Save Results As',defaultPos);
    if file ~=0,
        metaData.movieFilePos =movieFilePos;
        metaData.matFilePos   =matFilePos;
        metaData.strain =strain;
        metaData.gender =gender;
        metaData.experiment =experiment;
        metaData.pix2mm =pix2mm;
        metaData.butterworthFilter =[butter_CO butter_DEG];
        metaData.fps =fps;
        metaData.saccThresh =saccThresh;
        metaData.minQual =minQual;
        metaData.autoCorr =autoCorr;
        
        analysedData.traceResult =traceResult;
        analysedData.trace = trace;
        analysedData.bendability = bendability;
        analysedData.binnedBend = binnedBend;
        analysedData.saccs = saccs;
        analysedData.trigAveSacc = trigAveSacc;
        analysedData.medMaxVelocities = velocities;
        
        save([path file],'metaData','analysedData')
        setappdata(handles.output,'saved',1);
    else
        errordlg('User terminated saving process.')
    end
else
    errString = {'to load traceResult.mat' 'to choose a gender' ...
      'to choose a strain' 'to choose an experiment','there was an error'};
    errMessage = 'You forgot:';
    for i = 1:length(checkList),
        if checkList(i) == 1,
            errMessage = [errMessage ' ' errString{i} ','];
        end
    end
    errordlg(errMessage(1:end-1))
end


end

% --- Executes on button press in pb_pickFrame.
function pb_pickFrame_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pickFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = ginput(1);
axH = gca;
movieFPos = getappdata(handles.output,'movieFilePos');
fps = getappdata(handles.output,'fps');

hAxis = [handles.axes1 handles.axes2 handles.axes3 handles.axes6 handles.axes7];
handleMatch = hAxis == axH;

if sum(handleMatch)>0,
    newSliderPos = x(1)/(movieFPos.AllocatedFrames/fps);
    set(handles.slider4frames,'Value',newSliderPos)
    setappdata(handles.output,'sliderPos', newSliderPos);
    updateSlider(hObject, eventdata, handles)
else
    errordlg('Please click into the plots: Det Qual, Yaw, Thrust, Slip or Yaw Velocity');
end


end


% --- Executes on button press in pbframeMinusMinus.
function pbframeMinusMinus_Callback(hObject, eventdata, handles)
% hObject    handle to pbframeMinusMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frameNumber = sliderPos2frameNumber(hObject, eventdata, handles);
frameNumber = frameNumber-10;
sliderPos = frameNumber2sliderPos(hObject, eventdata, handles,frameNumber);
setappdata(handles.output,'sliderPos',sliderPos);
set(handles.slider4frames,'Value',sliderPos);
updateSlider(hObject, eventdata, handles)

end


% --- Executes on button press in pb_frameMinus.
function pb_frameMinus_Callback(hObject, eventdata, handles)
% hObject    handle to pb_frameMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frameNumber = sliderPos2frameNumber(hObject, eventdata, handles);
frameNumber = frameNumber-2;
sliderPos = frameNumber2sliderPos(hObject, eventdata, handles,frameNumber);
setappdata(handles.output,'sliderPos',sliderPos);
set(handles.slider4frames,'Value',sliderPos);
updateSlider(hObject, eventdata, handles)
end


% --- Executes on button press in pbFramePlus.
function pbFramePlus_Callback(hObject, eventdata, handles)
% hObject    handle to pbFramePlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frameNumber = sliderPos2frameNumber(hObject, eventdata, handles);
frameNumber = frameNumber+2;
sliderPos = frameNumber2sliderPos(hObject, eventdata, handles,frameNumber);
setappdata(handles.output,'sliderPos',sliderPos);
set(handles.slider4frames,'Value',sliderPos);
updateSlider(hObject, eventdata, handles)
end


% --- Executes on button press in pbFramePlusPlus.
function pbFramePlusPlus_Callback(hObject, eventdata, handles)
% hObject    handle to pbFramePlusPlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frameNumber = sliderPos2frameNumber(hObject, eventdata, handles);
frameNumber = frameNumber+10;
sliderPos = frameNumber2sliderPos(hObject, eventdata, handles,frameNumber);
setappdata(handles.output,'sliderPos',sliderPos);
set(handles.slider4frames,'Value',sliderPos);
updateSlider(hObject, eventdata, handles)
end


% --- Executes on button press in pb_worstFrames.
function pb_worstFrames_Callback(hObject, eventdata, handles)
% hObject    handle to pb_worstFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
minQual = getappdata(handles.output,'minQual');
minQualS = sort(minQual);
idx = find(minQual <= minQualS(10));
idx = idx(1:10);
oldTitle = get(get(handles.axes10,'Title'),'String');
for i =1:10,
    sliderPos = frameNumber2sliderPos(hObject, eventdata, handles,idx(i));
    setappdata(handles.output,'sliderPos',sliderPos);
    set(handles.slider4frames,'Value',sliderPos);
    updateSlider(hObject, eventdata, handles)
    set(get(handles.axes10,'Title'),'String',['10 worst frames ' num2str(i) ' of 10'])
    pause()
    
end
set(get(handles.axes10,'Title'),'String',oldTitle)

end

% --- Executes on button press in pb_reanalyse.
function pb_reanalyse_Callback(hObject, eventdata, handles)
% hObject    handle to pb_reanalyse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        analyseTraceResult(hObject, eventdata, handles);
        refreshPlots(hObject, eventdata, handles);
        updateSlider(hObject, eventdata, handles);
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% SUB ROUTINES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotNorpixFrame(hObject, eventdata, handles)
% get data
frameNumber = sliderPos2frameNumber(hObject, eventdata, handles);
trace= getappdata(handles.output,'trace');
sliderPos  = getappdata(handles.output,'sliderPos');
movieFpos = getappdata(handles.output,'movieFilePos');
traceResult = getappdata(handles.output,'traceResult');
traceR = traceResult{frameNumber,1};
tailLength= round((abs(diff(get(handles.axes10,'XLim')))+abs(diff(get(handles.axes10,'YLim'))))/20);
setappdata(handles.output,'currentFrame',frameNumber);
movieFPos = getappdata(handles.output,'movieFilePos');
titleStr = ['frame # ' num2str(frameNumber) ' | ' movieFPos.fPos];

frame = ET_GUI_SR_loadFrame(handles,frameNumber);
frame = ET_im_normImage(double(frame));
imagesc(frame,'Parent',handles.axes5)
colormap(handles.axes5,'gray')
axis(handles.axes5,'image')
title(handles.axes5,titleStr)
plotTracing(handles.axes5,traceResult,frameNumber)


imagesc(frame,'Parent',handles.axes10)
contour =traceResult{frameNumber,2}{:};
minLim =min(contour);
maxLim =max(contour);
colormap(handles.axes10,'gray')
axis(handles.axes10,'image')
xlim(handles.axes10,[minLim(2) maxLim(2)])
ylim(handles.axes10,[minLim(1) maxLim(1) ])
title(handles.axes10,'close up')
plotTracing(handles.axes10,traceResult,frameNumber)
hold(handles.axes10,'on')
ET_plot_lollipop(traceR(1,1,1),traceR(1,2,1),trace(frameNumber,3,1),tailLength,[1 0 0],handles.axes10);
hold(handles.axes10,'off')

end

function frameNumber = sliderPos2frameNumber(hObject, eventdata, handles)
sliderPos  = getappdata(handles.output,'sliderPos');
movieFpos = getappdata(handles.output,'movieFilePos');
AllocatedFrames = movieFpos.AllocatedFrames;
frameNumber = ceil(sliderPos*length(movieFpos.IDX));
if frameNumber > AllocatedFrames
    frameNumber = AllocatedFrames;
end
if frameNumber <1
    frameNumber = 1;
end

end

function sliderPos = frameNumber2sliderPos(hObject, eventdata, handles,frameNumber)
movieFpos = getappdata(handles.output,'movieFilePos');
AllocatedFrames = movieFpos.AllocatedFrames;
if frameNumber > AllocatedFrames
    frameNumber = AllocatedFrames;
end
if frameNumber <1
    frameNumber = 1;
end

sliderPos = frameNumber/AllocatedFrames;
end


function [hL,hM] = plotStackedData(axH,xAx,data,color,yStr,lastFlag,frameNumber)
%plot thrust velocity
hL = plot(axH,xAx,data,'Color',color,'LineWidth',1);
axis(axH,[xAx(1) xAx(end), min(data),max(data)]);
if lastFlag == 1,
    
    ylabel(axH,yStr)
    xlabel(axH,'time  [s]')
else
    set(axH,'XTickLabel',[])
    yTicks = get(axH,'YTick');
    set(axH,'YTick',yTicks(2:end));
    ylabel(axH,yStr)
end
hM = plotFrameMarker(axH,xAx,frameNumber,data);
end

function h = plotFrameMarker(axH,xAx,frameNumber,data)
hold(axH,'on')
h = plot(axH,xAx([frameNumber frameNumber]),[min(data) ,max(data)],'k--','LineWidth',1.3);
hold(axH,'off')
end

function plotTracing(axH,traceResult,frameNumber)
fishContour = traceResult{frameNumber,2};
fishContour = [fishContour{:}];
fishLine = traceResult{frameNumber,3};
fishLine = [fishLine{:}];
fishHead = traceResult{frameNumber,4};
hold(axH,'on')
plot(axH,fishContour(:,2),fishContour(:,1),'g');
plot(axH,fishLine(:,2),fishLine(:,1),'b--');
plot(axH,fishHead(:,2),fishHead(:,1),'bo','MarkerSize',6);

hold(axH,'off')

end

function refreshPlots(hObject, eventdata, handles)
%load data
trace = getappdata(handles.output,'trace');
fps = getappdata(handles.output,'fps');
taSaccs = getappdata(handles.output,'trigAveSacc');
saccs = getappdata(handles.output,'saccs');
minQual = getappdata(handles.output,'minQual');
autoCorr = getappdata(handles.output,'autoCorr');
bendability = getappdata(handles.output,'bendability');
binnedBend = getappdata(handles.output,'binnedBend');

%calculate framenumber and x-axis
frameNumber = sliderPos2frameNumber(hObject, eventdata, handles);
xAx = linspace(0,size(trace,1)/fps,size(trace,1));
%plot yaw

[hL(5),hM(5)] = plotStackedData(handles.axes6,xAx,minQual,[.5 .5 .5],'det qual [aU]',1,frameNumber);
hold(handles.axes6,'on')
plot(handles.axes6,xAx(autoCorr == 1),minQual(autoCorr ==1),'r.')
hold(handles.axes6,'off')


% plot frame
plotNorpixFrame(hObject, eventdata, handles)

%plot thrust velocitybinnedBend
[hL(1),hM(1)] = plotStackedData(handles.axes1,xAx,trace(:,4),paletteKeiIto(2),'thrust [m/s]',0,frameNumber);
%plot slip velocity
[hL(2),hM(2)] = plotStackedData(handles.axes2,xAx,trace(:,5),paletteKeiIto(4),'slip [m/s]',0,frameNumber);
%plot yaw velocity
[hL(3),hM(3)] = plotStackedData(handles.axes3,xAx,trace(:,6),paletteKeiIto(3),'yaw vel [deg/s]',1,frameNumber);
if ~isempty(saccs),
    hold(handles.axes3,'on')
    plot(handles.axes3,xAx(saccs(:,2)),trace(saccs(:,2),6),'bo')
    hold(handles.axes3,'off')
end
%plot yaw
[hL(4),hM(4)] = plotStackedData(handles.axes7,xAx,rad2deg(trace(:,3)),paletteKeiIto(6),'yaw [deg]',0,frameNumber);
if ~isempty(saccs),
    hold(handles.axes7,'on')
    plot(handles.axes7,xAx(saccs(:,2)),rad2deg(trace(saccs(:,2),3)),'b.')
    hold(handles.axes7,'off')
end
%plot yaw
setappdata(handles.output,'plotHandles',[hL hM]);

%plot saccade
xAx = ((size(taSaccs,2)-1)/-2:(size(taSaccs,2)-1)/2)./fps;
% angular change
axH = handles.axes4;
cla(axH)
if ~isempty(saccs),
errorareaTrans(xAx',taSaccs(1,:,1,1)',taSaccs(1,:,2,1)',paletteKeiIto(6),paletteKeiIto(6),.25,axH);
hold(axH,'on')
errorareaTrans(xAx',taSaccs(1,:,1,2)',taSaccs(1,:,2,2)',paletteKeiIto(6),paletteKeiIto(6),.25,axH);
xlim(axH,[xAx(1) xAx(end)]);
    set(axH,'XTickLabel',[])
    ylabel(axH,'saccadic angle change [deg]')
% velocity profile
end
axH = handles.axes8;
cla(axH)
if ~isempty(saccs),
errorareaTrans(xAx',taSaccs(2,:,1,1)',taSaccs(2,:,2,1)',paletteKeiIto(6),paletteKeiIto(6),.25,axH);
hold(axH,'on')
errorareaTrans(xAx',taSaccs(2,:,1,2)',taSaccs(2,:,2,2)',paletteKeiIto(6),paletteKeiIto(6),.25,axH);
xlim(axH,[xAx(1) xAx(end)]);
    ylabel(axH,'saccadic angle velocity [deg/s]')
    xlabel(axH,'saccadic angle velocity [s]')
end
% bendability
bendFrame =bendability{frameNumber};
bendFrame = [bendFrame(:,1) abs(bendFrame(:,2)).*-1+180];
axH = handles.axes9;
cla(axH);
xAx = linspace(0,1,10);
plot(axH,binnedBend(1,:),xAx,'r.--')
hold(axH,'on')
plot(axH,binnedBend(2,:),xAx,'g.--')
plot(axH,binnedBend(3,:),xAx,'k.--')
plot(axH,bendFrame(:,2),bendFrame(:,1),'b.-')
legend(axH,'max.bend','median bend','min. bend','current frame','Location','NorthEast');
hold(axH,'off')
xlabel(axH,'bending angle')
ylabel(axH,'normalised body length ')

end

function updateSlider(hObject, eventdata, handles)
velo = getappdata(handles.output,'velocities');
refreshPlots(hObject, eventdata, handles)
infoText{1,1} = ['Speed            median     max'];
infoText{2,1} = ['thrust [m/s]:   ' num2str(round2digit(velo(1,1),2)) '       ' num2str(round2digit(velo(2,1),2))];
infoText{3,1} = ['slip     [m/s]:   ' num2str(round2digit(velo(1,2),2)) '       ' num2str(round2digit(velo(2,2),2))];
infoText{4,1} = ['yaw  [deg/s]:   ' num2str(round2digit(velo(1,3),2)) '       ' num2str(round2digit(velo(2,3),2))];
set(handles.txt_Info,'String',infoText)

end

function analyseTraceResult(hObject, eventdata, handles)
clc
traceResult = getappdata(handles.output,'traceResult');
butterCo = getappdata(handles.output,'butter_CO');
butterDeg = getappdata(handles.output,'butter_DEG');
movieFpos = getappdata(handles.output,'movieFilePos');
saccThresh = getappdata(handles.output,'saccThresh');
startF = getappdata(handles.output,'startFrame');
lastF = getappdata(handles.output,'lastFrame');
if strcmp(startF,'start'),
    startF = 1;
end
if strcmp(lastF,'end'),
    lastF = size(traceResult,1);
end

fps = getappdata(handles.output,'fps');
expectedAnimals = getappdata(handles.output,'expectedAnimals');
pix2mm = getappdata(handles.output,'pix2mm');
[trace,traceResult,newIDX] = ET_anaS_phAnaFish(traceResult,fps,expectedAnimals,butterDeg,butterCo,pix2mm);
[saccs, ~] = get_saccades(trace(startF:lastF,6),saccThresh);
if ~isempty(saccs),
    saccs(:,1:3)=saccs(:,1:3)+startF-1;
    trigAveL = triggeredAverage([rad2deg(trace(:,3)),trace(:,6)],saccs(saccs(:,4) == 1,2),ceil(fps/4),[],10);
    trigAveR = triggeredAverage([rad2deg(trace(:,3)),trace(:,6)],saccs(saccs(:,4) == -1,2),ceil(fps/4),[],10);
    taSacc = cat(4,trigAveL,trigAveR);
    saccI = arrayfun(@(start,stop) start:stop,saccs(:,1),saccs(:,3),'UniformOutput',false);
    saccI =cell2mat(saccI');
else
    trigAveL = [];
    trigAveR = [];
    taSacc   = [];
    saccI    = [];
end
minQual = cellfun(@(x) min(x(:,12)),traceResult(:,1));
autoCorr = cellfun(@(x) max(x(:,13)),traceResult(:,1));
velocities = [median(abs(trace(startF:lastF-1,4:6)));max(abs(trace(startF:lastF-1,4:6)))];

if length(pix2mm) == 1
    pix2mmScalar = pix2mm;
else
    vecNorms = sqrt(sum(diff(pix2mm,1).^2,2));
    pix2mmScalar = geomean(rdivide(vecNorms(:,:,2),vecNorms(:,:,1)));
end

bendability2 = FMA_BA_getBendebility(traceResult(:,3),pix2mmScalar);
bendability2 = cellfun(@(x) [x(:,1)-min(x(:,1)) x(:,2)],bendability2,'UniformOutput',false );
bendability2 = cellfun(@(x) [x(:,1)./max(x(:,1)) x(:,2)],bendability2,'UniformOutput',false );
bendability = repmat({NaN(10,2)},size(bendability2));
bendability(startF:lastF) = bendability2(startF:lastF);
bendability2 = bendability;
bendability = cell2mat(bendability(startF:lastF));
% normalise bodylength
edges = 0:0.1:1;
binnedBend = NaN(3,10);
for i =1:length(edges)-1
    temp = abs(bendability(bendability(:,1)>=edges(i) & bendability(:,1)<edges(i+1),2));
    binnedBend(:,i) = [min(temp); mean(temp); max(temp)];
end
binnedBend = binnedBend.*-1 + 180;
trace2 = NaN(size(trace));
trace2(startF:lastF,:) = trace(startF:lastF,:);
trace = trace2;
movieFpos.IDX = newIDX;
setappdata(handles.output,'movieFilePos',movieFpos);
setappdata(handles.output,'trace',trace);
setappdata(handles.output,'traceResult',traceResult);
setappdata(handles.output,'saccs',saccs);
setappdata(handles.output,'trigAveSacc',taSacc);
setappdata(handles.output,'minQual',minQual);
setappdata(handles.output,'autoCorr',autoCorr);
setappdata(handles.output,'velocities',velocities);
setappdata(handles.output,'bendability',bendability2);
setappdata(handles.output,'binnedBend',binnedBend);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EDIT FIELDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





function ed_headerSize_Callback(hObject, eventdata, handles)
% hObject    handle to ed_headerSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_headerSize as text
%        str2double(get(hObject,'String')) returns contents of ed_headerSize as a double
setappdata(handles.output,'headerSize',str2double(get(hObject,'String')));
end

function ed_fps_Callback(hObject, eventdata, handles)
% hObject    handle to ed_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_fps as text
%        str2double(get(hObject,'String')) returns contents of ed_fps as a double
setappdata(handles.output,'fps',str2double(get(hObject,'String')));
end



function ed_expectedAnimals_Callback(hObject, eventdata, handles)
% hObject    handle to ed_expectedAnimals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_expectedAnimals as text
%        str2double(get(hObject,'String')) returns contents of ed_expectedAnimals as a double
setappdata(handles.output,'expectedAnimals',str2double(get(hObject,'String')));
end



function ed_butterDeg_Callback(hObject, eventdata, handles)
% hObject    handle to ed_butterDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_butterDeg as text
%        str2double(get(hObject,'String')) returns contents of ed_butterDeg as a double
setappdata(handles.output,'butter_DEG',str2double(get(hObject,'String')));
end



function ed_butterCO_Callback(hObject, eventdata, handles)
% hObject    handle to ed_butterCO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_butterCO as text
%        str2double(get(hObject,'String')) returns contents of ed_butterCO as a double
setappdata(handles.output,'butter_CO',str2double(get(hObject,'String')));
end



function ed_saccThresh_Callback(hObject, eventdata, handles)
% hObject    handle to ed_saccThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_saccThresh as text
%        str2double(get(hObject,'String')) returns contents of ed_saccThresh as a double
setappdata(handles.output,'saccThresh',str2double(get(hObject,'String')));

end



function ed_startFrame_Callback(hObject, eventdata, handles)
% hObject    handle to ed_startFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_startFrame as text
%        str2double(get(hObject,'String')) returns contents of ed_startFrame as a double
if strcmp(get(hObject,'String'),'start')
    setappdata(handles.output,'startFrame',1);
else
    num =str2double(get(hObject,'String'));
    if num < 1,
        setappdata(handles.output,'startFrame',1);
        set(handles.ed_startFrame,'String','1');
    else
        setappdata(handles.output,'startFrame',num);
    end
end
end




function ed_lastFrame_Callback(hObject, eventdata, handles)
% hObject    handle to ed_lastFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_lastFrame as text
%        str2double(get(hObject,'String')) returns contents of ed_lastFrame as a double
if strcmp(get(hObject,'String'),'last')
    setappdata(handles.output,'lastFrame',size(getappdata(handles.output,'traceResult'),1));
else
    num =str2double(get(hObject,'String'));
    if num > size(getappdata(handles.output,'traceResult'),1),
        setappdata(handles.output,'lastFrame',size(getappdata(handles.output,'traceResult'),1));
        set(handles.ed_lastFrame,'String',num2str(size(getappdata(handles.output,'traceResult'),1)));
    else
        setappdata(handles.output,'lastFrame',str2double(get(hObject,'String')));
    end
end
end



%%%%%%%%%%%%%%%%%%%%% PULL DOWNS & RADIO BUTTONS %%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in cb_wholeTrace.
function cb_wholeTrace_Callback(hObject, eventdata, handles)
% hObject    handle to cb_wholeTrace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_wholeTrace

setappdata(handles.output,'wholeTrace',get(hObject,'Value'));

if get(hObject,'Value') ==1,
    set(handles.ed_startFrame,'Enable','off')
    set(handles.ed_lastFrame,'Enable','off')
else
    set(handles.ed_startFrame,'Enable','on')
    set(handles.ed_lastFrame,'Enable','on')
end
end


% --- Executes on selection change in pm_strains.
function pm_strains_Callback(hObject, eventdata, handles)
% hObject    handle to pm_strains (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_strains contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_strains
contents = cellstr(get(hObject,'String'));
setappdata(handles.output,'strain',contents{get(hObject,'Value')});
end


% --- Executes when selected object is changed in rb_gender.
function rb_gender_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in rb_gender 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'gender', get(eventdata.NewValue,'String'));
end


% --- Executes on slider movement.
function slider4frames_Callback(hObject, eventdata, handles)
% hObject    handle to slider4frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
setappdata(handles.output,'sliderPos', get(hObject,'Value'));
updateSlider(hObject, eventdata, handles)
end



% --- Executes on selection change in pm_experiment.
function pm_experiment_Callback(hObject, eventdata, handles)
% hObject    handle to pm_experiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_experiment contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_experiment
contents = cellstr(get(hObject,'String'));
setappdata(handles.output,'experiment',contents{get(hObject,'Value')});
end


%%%%%%%%%%%%%%%%%%%%%%%%%%% CREATE FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
function ed_expectedAnimals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_expectedAnimals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_butterDeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_butterDeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_butterCO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_butterCO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes during object creation, after setting all properties.
function slider4frames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end



% --- Executes during object creation, after setting all properties.
function ed_saccThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_saccThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function pm_experiment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_experiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_startFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_startFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_lastFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_lastFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_headerSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_headerSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NEW FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
