function varargout = ET_GUI_Benzer(varargin)
% ET_GUI_BENZER MATLAB code for ET_GUI_Benzer.fig
%      ET_GUI_BENZER, by itself, creates a new ET_GUI_BENZER or raises the existing
%      singleton*.
%
%      H = ET_GUI_BENZER returns the handle to a new ET_GUI_BENZER or the handle to
%      the existing singleton*.
%
%      ET_GUI_BENZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ET_GUI_BENZER.M with the given input arguments.
%
%      ET_GUI_BENZER('Property','Value',...) creates a new ET_GUI_BENZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ET_GUI_Benzer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ET_GUI_Benzer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ET_GUI_Benzer

% Last Modified by GUIDE v2.5 21-Jul-2016 17:17:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ET_GUI_Benzer_OpeningFcn, ...
                   'gui_OutputFcn',  @ET_GUI_Benzer_OutputFcn, ...
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


% --- Executes just before ET_GUI_Benzer is made visible.
function ET_GUI_Benzer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ET_GUI_Benzer (see VARARGIN)

% Choose default command line output for ET_GUI_Benzer
handles.output = hObject;
% Image I/O
setappdata(handles.output,'movieIOtype', '');
setappdata(handles.output,'sortNorpix', 0);
setappdata(handles.output,'movieFilePos', '');
setappdata(handles.output,'minBG', []);
setappdata(handles.output,'maxBG', []);
setappdata(handles.output,'meanBG', []);
setappdata(handles.output,'plotFrameStart', NaN);
setappdata(handles.output,'plotFrameStop', NaN);
setappdata(handles.output,'plotFrameNum',10);
setappdata(handles.output,'allFramesFlag', 1);
setappdata(handles.output,'oldIDX', []);
% ROI
setappdata(handles.output,'useROI', 1);
setappdata(handles.output,'ROI', []);
setappdata(handles.output,'bgDirection', 'min BG');
% Image Manipulation
setappdata(handles.output,'differenceDir', '')
setappdata(handles.output,'bgDiff','max BG' );
setappdata(handles.output,'angleCorr', 0);
setappdata(handles.output,'conThresh', 0.15);
setappdata(handles.output,'eroderR', 1);
setappdata(handles.output,'numTestImg', 1);
setappdata(handles.output,'pix2mm', NaN);
setappdata(handles.output,'undistort', 0);
setappdata(handles.output,'distortParams',struct('fx',0,'fy',0,'cx',0,'cy',0,...
        'k1',0,'k2',0,'k3',0,'p1',0,'p2',0));
% Detection Variables
setappdata(handles.output,'minMajorAxis', 10);
setappdata(handles.output,'maxMajorAxis', 60);
setappdata(handles.output,'minAspRatio', 0.2);
setappdata(handles.output,'maxAspRatio', 0.4);
setappdata(handles.output,'numBestFits', 10);
setappdata(handles.output,'detCenLine', 1);
setappdata(handles.output,'useContourFilter', 1);
% auto correction
setappdata(handles.output,'useMultDet', 0);
setappdata(handles.output,'usePrevPos', 1);
setappdata(handles.output,'expAnimalNum', 1);
setappdata(handles.output,'expAnimalLen', 60);
setappdata(handles.output,'animalArea', NaN);
setappdata(handles.output,'voteWeights', [0.75 0.75 1 1]);
% test plotting
setappdata(handles.output,'plotLinFlagManip', 1);
setappdata(handles.output,'plotImgManNum', [1 100 10]);
setappdata(handles.output,'numLinSpaced', 10);
setappdata(handles.output,'numLinSpacedImgMan', 10);
setappdata(handles.output,'specFrames2plot', [1:10 100]);
setappdata(handles.output,'plotLinFlag', 1);
% script building
setappdata(handles.output,'detScriptPath', '~/ET_DetectionScript/');
setappdata(handles.output,'remMovSource', '');
setappdata(handles.output,'remBGSource', '');
setappdata(handles.output,'remROISource', '');
setappdata(handles.output,'remScriptSource', '');
setappdata(handles.output,'remVarSource', '');
setappdata(handles.output,'remResultSource', '');
setappdata(handles.output,'detScriptTag', '');
setappdata(handles.output,'scriptAutoNaming', 1);
setappdata(handles.output,'calcDur',[]);
% flag variable
setappdata(handles.output,'f_ROI', 0);
setappdata(handles.output,'f_Movie', 0);
setappdata(handles.output,'f_BG', 0);
setappdata(handles.output,'f_Pix', 0);
setappdata(handles.output,'f_Test', 0);
setappdata(handles.output,'f_scriptWritten', 0);
setappdata(handles.output,'infoText','fIO:  ROI:  BG:  Test:  Pix:  Script: ');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ET_GUI_Benzer wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = ET_GUI_Benzer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%%%%%%%%%%%%%%%%%%%%%%%
% PushButons Function %
%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pb_loadROI.
function pb_loadROI_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get file position

[FileName,PathName] = uigetfile('*.mat','Select ROI file');
maskIDX = load2var([PathName FileName]);
setappdata(handles.output,'ROI', maskIDX);
setappdata(handles.output,'f_ROI', 1);
ET_GUI_spline_SR_updateInfo(handles,11);
end



% --- Executes on button press in pb_imgSeq.
function pb_imgSeq_Callback(hObject, eventdata, handles)
% hObject    handle to pb_imgSeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
goOn =1;
f_Movie = getappdata(handles.output,'f_Movie');
f_scriptWritten = getappdata(handles.output,'f_scriptWritten');
if f_Movie == 0,
    goOn =1;
elseif f_Movie == 1 && f_scriptWritten ==1,
    goOn =1;
else
    answer = questdlg('You started making a script, but did not finish. Opening a new movie file deletes progress!',...
        'Overwrite Script?','Continue','Abort','Abort');
    if strcmp(answer,'Abort')
        goOn = 0;
    else
        goOn =1;
    end
end

if goOn ==1;
    %Initialise old variables
    ET_GUI_Benzer_SR_clearHandles(handles),
    
    readModus = 'onlyHeader'; %read modus
    
    if getappdata(handles.output,'sortNorpix') ==1,
        sortModus = 'sort'; %sort modus
    else
        sortModus = ''; %no sorting
    end
    % get file position
    [FileName,PathName] = uigetfile('*.seq','Select the norpix sequence file');
    % file dialogue
    [fid, endianType,headerInfo,~, IDX] = ivT_norpix_openSeq([PathName FileName],readModus,sortModus);
    %set to struct
    movieFpos.fid = fid;
    movieFpos.endianType = endianType;
    movieFpos.headerInfo = headerInfo;
    movieFpos.IDX = IDX;
    movieFpos.fPos = [PathName FileName];
    setappdata(handles.output,'movieFilePos',movieFpos);
    setappdata(handles.output,'movieIOtype','norpix');
    ET_GUI_spline_SR_updateInfo(handles,5)
    set(handles.ed_startFrame,'String',1)
    set(handles.ed_stopFrame,'String',headerInfo.AllocatedFrames)
    setappdata(handles.output,'plotFrameStart', 1);
    setappdata(handles.output,'plotFrameStop', headerInfo.AllocatedFrames);
    
    setappdata(handles.output,'f_Movie', 1);
end
end


% --- Executes on button press in pb_ROI.
function pb_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get info from GUI
bgDir = getappdata(handles.output,'bgDirection');
bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
angleCorrection = getappdata(handles.output,'angleCorr');
bg = ET_im_rotate(bg,angleCorrection);
bg = ET_GUI_SR_undistort(handles,bg);
ROI = ET_im_getROI(bg,handles.axes1);
setappdata(handles.output,'ROI', ROI);
setappdata(handles.output,'f_ROI', 1);
ET_GUI_spline_SR_updateInfo(handles,11);

end


% --- Executes on button press in pb_autoROI.
function pb_autoROI_Callback(hObject, eventdata, handles)
% hObject    handle to pb_autoROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load variables
bgDir = getappdata(handles.output,'differenceDir');
movieIOtype = getappdata(handles.output,'movieIOtype');
movieFpos = getappdata(handles.output,'movieFilePos');
angleCorrection = getappdata(handles.output,'angleCorr');
bgMin = getappdata(handles.output,'minBG');
bgMax = getappdata(handles.output,'maxBG');
numBG = 0;
% check if the difference direction is chosen
if ~strcmp(bgDir,'difference direction'),
    % check if there are allready  backgrounds
    if ~isempty(bgMin),
        numBG = numBG+1;
    end
    if ~isempty(bgMax),
        numBG = numBG+1;
    end
    
    switch numBG,
        case 0, % both backgrounds are missing!
            switch movieIOtype,
                % Norpix File Seq
                case 'norpix',
                    [diffBg,bgMax,bgMin] =  ET_bg_calcForNorPixSeq(movieFpos.fid,movieFpos.headerInfo,movieFpos.endianType,movieFpos.IDX,'max-min',1);
                    
                    % Video Reader
                case 'videoReader'
                    [diffBg,IDX,bgMax,bgMin] = ET_bg_calcForVRobj(movieFpos.movObj,movieFpos.IDX,'max-min',1);
                    movieFpos.IDX = IDX;
                    setappdata(handles.output,'movieFilePos',movieFpos );
                    
                    % Image Stack
                case 'imageStack'
                     [diffBg,bgMax,bgMin] = ET_bg_calcForImgStack(movieFpos.fPos,movieFpos.IDX,'max-min',1);
                    
                otherwise
                    errordlg('Not implemented yet!');
            end
        case 1,% 1 background is missing
            if isempty(bgMin),
                bgMin = ET_GUI_spline_SR_getOrCalcBG(handles,'minBG');
            else
                bgMax = ET_GUI_spline_SR_getOrCalcBG(handles,'maxBG');
            end
            diffBg = bsxfun(@minus,bgMax,bgMin);
                
        case 2,
            diffBg = bsxfun(@minus,bgMax,bgMin);
            
    end
    
    diffBg = ET_im_normImage(double(ET_im_rotate(diffBg,angleCorrection)));
    diffBg = ET_GUI_SR_undistort(handles,diffBg);
    
    if strcmp(bgDir,'bg-image'),
        maskIDX = diffBg >0.2;
        ET_GUI_spline_SR_plotImg(handles,double(bgMin),'auto ROI',1)
    else
        maskIDX = diffBg < 0.2;
        ET_GUI_spline_SR_plotImg(handles,double(bgMax),'auto ROI',1)
    end
    maskIDXinv = ~maskIDX;
    maskIDX = ET_im_dilate(maskIDX,1);
    maskIDXinv = ET_im_dilate(maskIDXinv,1);
    maskContours = ET_HTD_detectObjectContours(maskIDX);
    
    hold on
    cellfun(@(x) patch(x(:,2),x(:,1),paletteKeiIto(2),'Parent',handles.axes1,'FaceAlpha',0.5),maskContours) ;
    hold off
    
    setappdata(handles.output,'minBG', double(bgMin));
    setappdata(handles.output,'maxBG', double(bgMax));
    setappdata(handles.output,'ROI', maskIDXinv);
    setappdata(handles.output,'f_ROI', 1);
    ET_GUI_spline_SR_updateInfo(handles,11);
    
    if  ~strcmp(getappdata(handles.output,'bgDiff'),'mean'),
        ET_GUI_spline_SR_updateInfo(handles,16);
        setappdata(handles.output,'f_BG', 1);
        
    end
else
    errordlg('You have to pick a substraction mode first')
    
end

end

% --- Executes on button press in pb_calcBG.
function pb_calcBG_Callback(hObject, eventdata, handles)
% hObject    handle to pb_calcBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get background mode
bgDir = getappdata(handles.output,'bgDiff');
%get background
ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
%update status
ET_GUI_spline_SR_updateInfo(handles,16);
setappdata(handles.output,'f_BG', 1);

end

% --- Executes on button press in pb_loadImgStack.
function pb_loadImgStack_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadImgStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
goOn =1;
f_Movie = getappdata(handles.output,'f_Movie');
f_scriptWritten = getappdata(handles.output,'f_scriptWritten');
if f_Movie == 0,
    goOn =1;
elseif f_Movie == 1 && f_scriptWritten ==1,
    goOn =1;
else
    answer = questdlg('You started making a script, but did not finish. Opening a new movie file deletes progress!',...
        'Overwrite Script?','Continue','Abort','Abort');
    if strcmp(answer,'Abort')
        goOn = 0;
    else
        goOn =1;
    end
end

if goOn ==1;
    %Initialise old variables
    ET_GUI_Benzer_SR_clearHandles(handles);
    % get file position
    [FileName,PathName] = uigetfile({'*.jpg';'*.tiff';'*.png';'*.bmp''*.*'},...
                          'Select the images','MultiSelect','on');
    FileName = sort_nat(FileName);
    %                  
    movieFpos.fPos = cellfun(@(x) [PathName x],FileName,'UniformOutput',false);
    movieFpos.IDX = 1:length(FileName);
    
    
    setappdata(handles.output,'movieFilePos',movieFpos);
    setappdata(handles.output,'movieIOtype','imageStack');
    ET_GUI_spline_SR_updateInfo(handles,5);
    set(handles.ed_startFrame,'String',1);
    set(handles.ed_stopFrame,'String',length(FileName));
    setappdata(handles.output,'plotFrameStart', 1);
    setappdata(handles.output,'plotFrameStop', length(FileName));
    
    setappdata(handles.output,'f_Movie', 1);
end
end

% --- Executes on button press in pb_loadMovie.
function pb_loadMovie_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
goOn =1;
f_Movie = getappdata(handles.output,'f_Movie');
f_scriptWritten = getappdata(handles.output,'f_scriptWritten');
if f_Movie == 0,
    goOn =1;
elseif f_Movie == 1 && f_scriptWritten ==1,
    goOn =1;
else
    answer = questdlg('You started making a script, but did not finish. Opening a new movie file deletes progress!',...
        'Overwrite Script?','Continue','Abort','Abort');
    if strcmp(answer,'Abort')
        goOn = 0;
    else
        goOn =1;
    end
end

if goOn ==1;
    %Initialise old variables
    ET_GUI_Benzer_SR_clearHandles(handles);
     
    readModus = 'onlyHeader'; %read modus
    
    if getappdata(handles.output,'sortNorpix') ==1,
        sortModus = 'sort'; %sort modus
    else
        sortModus = ''; %no sorting
    end
    % get file position
    [FileName,PathName] = uigetfile({'*.avi';'*.mkv';'*.mp4';'*.ogg''*.*'},...
                          'Select the norpix sequence file');
    
    %                  
    movieFpos.fPos = [PathName FileName];
    movObj= VideoReader(movieFpos.fPos);
    movieFpos.movObj = movObj;
    movieFpos.IDX = 1:movObj.NumberOfFrames;
    
    
    setappdata(handles.output,'movieFilePos',movieFpos);
    setappdata(handles.output,'movieIOtype','videoReader');
    ET_GUI_spline_SR_updateInfo(handles,5)
    set(handles.ed_startFrame,'String',1)
    set(handles.ed_stopFrame,'String',movObj.NumberOfFrames)
    setappdata(handles.output,'plotFrameStart', 1);
    setappdata(handles.output,'plotFrameStop', movObj.NumberOfFrames);
    
    setappdata(handles.output,'f_Movie', 1);
end

end

% --- Executes on button press in pb_pickDir.
function pb_pickDir_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pickDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get new folder name
folder_name = uigetdir(pwd,'pick new scriptDir');

% make needed folders
warning('off', 'MATLAB:MKDIR:DirectoryExists')
mkdir([folder_name filesep 'backGrounds']);
mkdir([folder_name filesep 'ROIs']);
mkdir([folder_name filesep 'scripts']);
mkdir([folder_name filesep 'variables']);
mkdir([folder_name filesep 'traceResults']);
warning('on', 'MATLAB:MKDIR:DirectoryExists')

%check if the script manager is allready there
files = dir(folder_name);
files = struct2cell(files);
IDX = sum(cellfun(@length,strfind(files(1,:),'ET_Script_Manger_todo.mat')));

% make new one if needed
if IDX == 0,
    toDo = {};
    save([folder_name filesep 'ET_Script_Manger_todo.mat'],'toDo')
end

%check if the preference manager is allready there
IDX = sum(cellfun(@length,strfind(files(1,:),'ET_Pref_Manger.mat')));
% make new one if needed
if IDX == 0,
    preferences = {};
    save([folder_name filesep 'ET_Script_Manager_todo.mat'],'preferences')
end


end

% --- Executes on button press in pb_plotImgMan.
function pb_plotImgMan_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plotImgMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

frameIDX =ET_GUI_spline_SR_getFramesIM(handles);
total = length(frameIDX);
counter = 0;
for frameNumber = frameIDX
    counter=counter+1;
    testimg = ET_GUI_spline_SR_imageManip(handles,frameNumber);
    oldUDflag = getappdata(handles.output,'undistort');
    setappdata(handles.output,'undistort', 0);
    ET_GUI_spline_SR_plotImg(handles,testimg,['frameNumber: ' num2str(frameNumber) ' | ' num2str(counter) ' of ' num2str(total) ' | press space bar to see next'],0)
    setappdata(handles.output,'undistort', oldUDflag);
    pause()
end
ET_GUI_spline_SR_updateInfo(handles,16);
setappdata(handles.output,'f_BG', 1);

end


% --- Executes on button press in pb_saveScript.
function pb_saveScript_Callback(hObject, eventdata, handles)
% hObject    handle to pb_saveScript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get chek flags  
f_ROI = getappdata(handles.output,'f_ROI');
f_Movie = getappdata(handles.output,'f_Movie');
f_BG = getappdata(handles.output,'f_BG');
f_Test = getappdata(handles.output,'f_Test');
f_Pix = getappdata(handles.output,'f_Pix');
useROI = getappdata(handles.output,'useROI');
% continuation flag
goOn=1;

%check if everything is done
if f_Movie == 0,
    errordlg('load movie first!')
    goOn = 0;
end
if f_BG == 0,
    errordlg('calculate backround first!')
    goOn = 0;
end
if f_ROI == 0 && useROI ==1,
    errordlg('You selected to use ROI without defining one!')
    goOn = 0;
end
if f_Test == 0,
    errordlg('test your script first! Its needed for workload approximation.')
    goOn = 0;
end
if f_Pix == 0,
    errordlg('test your script first! Its needed for workload approximation.')
    goOn = 0;
end
% if everything was done write script!
if goOn ==1,
    switch getappdata(handles.output,'movieIOtype'),
        case 'norpix'
            ET_GUI_Benzer_SR_writeScript(handles);
        case 'videoReader'
            ET_GUI_Benzer_SR_writeScriptMov(handles);
        otherwise
            errordlg(['Movie IO type unknown: ' getappdata(handles.output,'movieIOtype')]);
            
    end
    
    % show that you have written the script
    setappdata(handles.output,'f_scriptWritten', 1);
    ET_GUI_spline_SR_updateInfo(handles,38)
end
end



% --- Executes on button press in pb_plot.
function pb_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
frameIDX =ET_GUI_spline_SR_getFramesDet(handles);
movieFpos = getappdata(handles.output,'movieFilePos');
total = length(frameIDX);
counter = 0;
calcDur = zeros(length(frameIDX),1);
for i =frameIDX,
    counter=counter+1;
    tic;
    traceResult = ET_GUI_spline_SR_trace(handles,i);
    calcDur(counter) = toc;
    frame = ET_GUI_SR_loadFrame(handles,i);
    ET_GUI_Benzer_SR_plotTraceResult(handles,frame,traceResult,['frame: ' num2str(i) ...
        ' | ' num2str(counter) ' of ' num2str(total) ' | calc. dur. :'...
        num2str( round2digit(calcDur(counter),2))  ' s | press space bar to see next']);
    
    if i ~= frameIDX(end)
        pause()
    end
end
setappdata(handles.output,'calcDur',calcDur);
setappdata(handles.output,'f_Test', 1);
ET_GUI_spline_SR_updateInfo(handles,23)
end


% --- Executes on button press in pb_plotBG.
function pb_plotBG_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plotBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get background mode
bgDir = getappdata(handles.output,'bgDiff');...
        
%get backGround
bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
% plot
ET_GUI_spline_SR_plotImg(handles,bg,['backGround: ' bgDir])
    ET_GUI_spline_SR_updateInfo(handles,16);
    setappdata(handles.output,'f_BG', 1);


end


% --- Executes on button press in pb_plotFrame.
function pb_plotFrame_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plotFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
movieFpos = getappdata(handles.output,'movieFilePos');
frameNumber = getappdata(handles.output,'plotFrameNum');
frame = ET_GUI_SR_loadFrame(handles,frameNumber);
ET_GUI_spline_SR_plotImg(handles,frame,['frame: ' num2str(frameNumber)])

end


% --- Executes on button press in pb_clearMinBG.
function pb_clearMinBG_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clearMinBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'minBG', []);
end


% --- Executes on button press in pb_clearMeanBG.
function pb_clearMeanBG_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clearMeanBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'meanBG', []);
end


% --- Executes on button press in pb_clearMaxBG.
function pb_clearMaxBG_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clearMaxBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'maxBG', []);
end

% --- Executes on button press in set_remSource.
function set_remSource_Callback(hObject, eventdata, handles)
% hObject    handle to set_remSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
[FileName,PathName] = uigetfile('*.seq','Select the norpix file');

setappdata(handles.output,'remMovSource', [PathName FileName]);
end


% --- Executes on button press in pb_setRemScript.
function pb_setRemScript_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setRemScript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetdir(pwd,'Select the MATLAB Script position');
setappdata(handles.output,'remScriptSource', [PathName FileName]);
end


% --- Executes on button press in pb_setremBG.
function pb_setremBG_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setremBG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB background file');
setappdata(handles.output,'remBGSource', [PathName FileName]);
end


% --- Executes on button press in pb_setRemROI.
function pb_setRemROI_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setRemROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB ROI file');
setappdata(handles.output,'remROISource', [PathName FileName]);
end


% --- Executes on button press in pb_setRemVar.
function pb_setRemVar_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setRemVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB variables file');
setappdata(handles.output,'remVarSource', [PathName FileName]);
end


% --- Executes on button press in pb_remResultTarget.
function pb_remResultTarget_Callback(hObject, eventdata, handles)
% hObject    handle to pb_remResultTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB result file');
setappdata(handles.output,'remResultSource', [PathName FileName]);
end


% --- Executes on button press in pb_pix2mmCircle.
function pb_pix2mmCircle_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pix2mmCircle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get background
bgDir = getappdata(handles.output,'bgDiff');
bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
angleCorrection = getappdata(handles.output,'angleCorr');
bg = ET_im_rotate(bg,angleCorrection);
bg = ET_GUI_SR_undistort(handles,bg);


pix2mm = ivT_GUI_circleArena(bg);
setappdata(handles.output,'pix2mm', pix2mm);

setappdata(handles.output,'f_Pix', 1);
ET_GUI_spline_SR_updateInfo(handles,29);

end


% --- Executes on button press in pb_pix2mmBox.
function pb_pix2mmBox_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pix2mmBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get background
bgDir = getappdata(handles.output,'bgDiff');
bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
angleCorrection = getappdata(handles.output,'angleCorr');
bg = ET_im_rotate(bg,angleCorrection);
bg = ET_GUI_SR_undistort(handles,bg);
pixBox =  ET_p2mm_box(handles.axes1,bg);
setappdata(handles.output,'pix2mm', pixBox);

setappdata(handles.output,'f_Pix', 1);
ET_GUI_spline_SR_updateInfo(handles,29);
end


% --- Executes on button press in pb_pix2mmLine.
function pb_pix2mmLine_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pix2mmLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get background
bgDir = getappdata(handles.output,'bgDiff');
bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
angleCorrection = getappdata(handles.output,'angleCorr');
bg = ET_im_rotate(bg,angleCorrection);
bg = ET_GUI_SR_undistort(handles,bg);
pix2mm = ET_p2mm_line(bg,handles.axes1);
setappdata(handles.output,'pix2mm', pix2mm);

setappdata(handles.output,'f_Pix', 1);
ET_GUI_spline_SR_updateInfo(handles,29);
end


% --- Executes on button press in pb_plotAniSub.
function pb_plotAniSub_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plotAniSub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


clc
figureH = figure();
Nb = 100;


frameIDX =ET_GUI_spline_SR_getFramesDet(handles);
movieFpos = getappdata(handles.output,'movieFilePos');
total = length(frameIDX);
counter = 0;
calcDur = zeros(length(frameIDX),1);
for i =frameIDX,
    counter=counter+1;
    tic;
    traceResult = ET_GUI_spline_SR_trace(handles,i);
    calcDur(counter) = toc;
    frame = ET_GUI_SR_loadFrame(handles,i);
    angleCorrection = getappdata(handles.output,'angleCorr');
    frame= ET_im_rotate(frame,angleCorrection);
    frame = ET_GUI_SR_undistort(handles,frame);
    
    centralLine = traceResult{1,4};
    head = reshape_2Dto3D(traceResult{1,5}(2,:,:));
    ET_plot_animals2subplots(frame,1,traceResult,Nb,figureH,centralLine,head );
    
    
    if i ~= frameIDX(end)
        pause()
    else
        pause()
        close(figureH)
    end
end
setappdata(handles.output,'calcDur',calcDur);
setappdata(handles.output,'f_Test', 1);
ET_GUI_spline_SR_updateInfo(handles,23)

end

%%%%%%%%%%%%%%%
% SUBROUTINES %
%%%%%%%%%%%%%%%

function ET_GUI_Benzer_SR_clearHandles(handles),
    %Initialise old variables
    % Image I/O
    setappdata(handles.output,'movieIOtype', '');
    setappdata(handles.output,'sortNorpix', 0);
    setappdata(handles.output,'movieFilePos', '');
    setappdata(handles.output,'minBG', []);
    setappdata(handles.output,'maxBG', []);
    setappdata(handles.output,'meanBG', []);
    setappdata(handles.output,'plotFrameStart', NaN);
    setappdata(handles.output,'plotFrameStop', NaN);
    setappdata(handles.output,'plotFrameNum',10);
    setappdata(handles.output,'allFramesFlag', 1);
    setappdata(handles.output,'oldIDX', []);
    % ROI
    setappdata(handles.output,'useROI', 1);
    setappdata(handles.output,'ROI', []);
    % Image Manipulation
    setappdata(handles.output,'pix2mm', NaN);
    % test plotting
    % script building
    setappdata(handles.output,'detScriptPath', '~/ET_DetectionScript/');
    setappdata(handles.output,'remMovSource', '');
    setappdata(handles.output,'remBGSource', '');
    setappdata(handles.output,'remROISource', '');
    setappdata(handles.output,'remScriptSource', '');
    setappdata(handles.output,'remVarSource', '');
    setappdata(handles.output,'remResultSource', '');
    setappdata(handles.output,'detScriptTag', '');
    setappdata(handles.output,'calcDur',[]);
    % flag variable
    setappdata(handles.output,'f_ROI', 0);
    setappdata(handles.output,'f_Movie', 0);
    setappdata(handles.output,'f_BG', 0);
    setappdata(handles.output,'f_Pix', 0);
    setappdata(handles.output,'f_Test', 0);
    setappdata(handles.output,'f_scriptWritten', 0);
    setappdata(handles.output,'infoText','fIO:  ROI:  BG:  Test:  Pix:  Script: ');
end


function ET_GUI_Benzer_SR_plotTraceResult(handles,img,traceResult,titleStr)
oc = traceResult{1,2};
centralLine = traceResult{1,4};
head = reshape_2Dto3D(traceResult{1,5}(2,:,:));
ET_GUI_spline_SR_plotImg(handles,img,titleStr)
hold on
cellfun(@(x) plot(handles.axes1,x(:,2),x(:,1),'b','LineWidth',2),centralLine);
cellfun(@(x) plot(handles.axes1,x(:,2),x(:,1),'g','LineWidth',2),oc);
for i =1:size(head,1)
plot(handles.axes1,head(i,2),head(i,1),'bo','MarkerSize',5,'LineWidth',2)
end
hold off
end


function frameIDX =ET_GUI_spline_SR_getFramesIM(handles)
% get infos from gui
linFlag = getappdata(handles.output,'plotLinFlagManip');
manNum = getappdata(handles.output,'plotImgManNum');
linSpacNum = getappdata(handles.output,'numLinSpacedImgMan');
movieFpos = getappdata(handles.output,'movieFilePos');

if linFlag ==1,
    frameIDX = round(linspace(1, length(movieFpos.IDX),linSpacNum));
else
    frameIDX = manNum;   
end
end

function frameIDX =ET_GUI_spline_SR_getFramesDet(handles)
% get infos from gui
linFlag = getappdata(handles.output,'plotLinFlag');
manNum = getappdata(handles.output,'specFrames2plot');
linSpacNum = getappdata(handles.output,'numLinSpaced');
movieFpos = getappdata(handles.output,'movieFilePos');

if linFlag ==1,
    frameIDX = round(linspace(1, length(movieFpos.IDX),linSpacNum));
else
    frameIDX = manNum;   
end
end



function traceResult = ET_GUI_spline_SR_trace(handles,frameNumber)
movieFpos = getappdata(handles.output,'movieFilePos');
bgDir = getappdata(handles.output,'bgDiff');
bgSubModus = getappdata(handles.output,'differenceDir');
angleCorrection = getappdata(handles.output,'angleCorr');
contrastThresh = getappdata(handles.output,'conThresh');
eroderR = getappdata(handles.output,'eroderR');
ellipseParams.minMajorAxis = getappdata(handles.output,'minMajorAxis'); %ellipse parameter minimal major axis length
ellipseParams.maxMajorAxis = getappdata(handles.output,'maxMajorAxis'); %ellipse parameter maximal major axis length
ellipseParams.minAspectRatio = getappdata(handles.output,'minAspRatio');%ellipse parameter minimal aspect ratio
ellipse.maxAspectRatio = getappdata(handles.output,'maxAspRatio'); %ellipse parameter maximal aspect ratio
bestEllipsesN = getappdata(handles.output,'numBestFits');
prevDetection= [];%getappdata(handles.output,'usePrevPos'); In a single test we cannot use prev position
expetedLength= getappdata(handles.output,'expAnimalLen');
expetedSize= getappdata(handles.output,'animalArea');
voteWeights= getappdata(handles.output,'voteWeights');
expectedAnimals= getappdata(handles.output,'expAnimalNum');
multiDetectionPossible= getappdata(handles.output,'useMultDet');
useConFilter = getappdata(handles.output,'useContourFilter');
distortParams = getappdata(handles.output,'distortParams');
if  getappdata(handles.output,'useROI') ==1,
    maskIDX = getappdata(handles.output,'ROI');
else
    maskIDX = [];
end
%get background
backGround = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);

if isempty(bgSubModus) || strcmp(bgSubModus,'difference direction'),
    errordlg('You have to pick a substraction mode first')
else    
    
switch getappdata(handles.output,'movieIOtype'),
    case 'videoReader'
    traceResult = ET_anaS_basic4BenzerMov(movieFpos.movObj,...
        movieFpos.IDX,frameNumber,angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...
        ellipseParams,bestEllipsesN,prevDetection,expetedLength,expetedSize,voteWeights,...
        expectedAnimals,multiDetectionPossible,maskIDX,useConFilter,distortParams);
    case 'norpix'
    traceResult = ET_anaS_basic4Benzer(movieFpos.fid,movieFpos.headerInfo,movieFpos.endianType,...
        movieFpos.IDX,frameNumber,angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...
        ellipseParams,bestEllipsesN,prevDetection,expetedLength,expetedSize,voteWeights,...
        expectedAnimals,multiDetectionPossible,maskIDX,useConFilter,distortParams);
    case 'imageStack'
    traceResult = ET_anaS_basic4BenzerFrame(movieFpos.fPos,movieFpos.IDX,frameNumber,...
        angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...
        ellipseParams,bestEllipsesN,prevDetection,expetedLength,expetedSize,voteWeights,...
        expectedAnimals,multiDetectionPossible,maskIDX,useConFilter,distortParams);
end
    
    
end
end



function  ET_GUI_spline_SR_updateInfo(handles,idx)
% This updates the staus text box 
% for    fIO : idx == 5
% for    ROI : idx == 11
% for     BG : idx == 16
% for   Test : idx == 23
% for    Pix : idx == 29
% for Script : idx == 38
% fIO:  ROI:  BG:  Test:  Pix:  Script: 
% 12345678901234567890123456789012345678

infoText = getappdata(handles.output,'infoText');
infoText(idx)='✓';
setappdata(handles.output,'infoText',infoText);
set(handles.txt_status,'String',infoText)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CheckBox & RadioButton Function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in cb_usePrevPos.
function cb_usePrevPos_Callback(hObject, eventdata, handles)
% hObject    handle to cb_usePrevPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_usePrevPos
setappdata(handles.output,'usePrevPos',get(hObject,'Value'));
set(handles.cb_usePrevPos2,'Value',get(hObject,'Value'));
end


% --- Executes on button press in cb_multDetect.
function cb_multDetect_Callback(hObject, eventdata, handles)
% hObject    handle to cb_multDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_usePrevPos
setappdata(handles.output,'multDetect2', get(hObject,'Value'));
set(handles.cb_useMultDetPos2,'Value',get(hObject,'Value'));
end


% --- Executes on button press in cb_useROI.
function cb_useROI_Callback(hObject, eventdata, handles)
% hObject    handle to cb_useROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_useROI
setappdata(handles.output,'useROI', get(hObject,'Value'));
set(handles.cb_useROI2,'Value',get(hObject,'Value'));
end


% --- Executes on selection change in pm_differenceDir.
function pm_differenceDir_Callback(hObject, eventdata, handles)
% hObject    handle to pm_differenceDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_differenceDir contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_differenceDir
contents = cellstr(get(hObject,'String'));
setappdata(handles.output,'differenceDir',contents{get(hObject,'Value')} );
end


% --- Executes on button press in cb_usePrevPos2.
function cb_usePrevPos2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_usePrevPos2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_usePrevPos2
setappdata(handles.output,'usePrevPosDet', get(hObject,'Value'));
set(handles.cb_usePrevPos,'Value',get(hObject,'Value'));
end


% --- Executes on button press in cb_useMultDetPos2.
function cb_useMultDetPos2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_useMultDetPos2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_useMultDetPos2
setappdata(handles.output,'useMultDet', get(hObject,'Value'));
set(handles.cb_multDetect,'Value',get(hObject,'Value'));
end


% --- Executes on button press in cb_useROI2.
function cb_useROI2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_useROI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_useROI2
setappdata(handles.output,'useROI', get(hObject,'Value'));
set(handles.cb_useROI,'Value',get(hObject,'Value'));
end


% --- Executes on button press in cb_spline.
function cb_spline_Callback(hObject, eventdata, handles)
% hObject    handle to cb_spline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_spline
setappdata(handles.output,'detCenLine',get(hObject,'Value') );
end


% --- Executes on button press in cb_plotLinFrame.
function cb_plotLinFrame_Callback(hObject, eventdata, handles)
% hObject    handle to cb_plotLinFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_plotLinFrame
setappdata(handles.output,'plotLinFlag', get(hObject,'Value'));
if get(hObject,'Value') == 0,
    set(handles.ed_specFrames2plot,'Enable','on');
else
    set(handles.ed_specFrames2plot,'Enable','off');
end
end

% --- Executes when selected object is changed in rb_ROIbg.
function rb_ROIbg_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in rb_ROIbg 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'bgDirection',get(eventdata.NewValue,'String') );
end


% --- Executes on button press in cb_norpixSort.
function cb_norpixSort_Callback(hObject, eventdata, handles)
% hObject    handle to cb_norpixSort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_norpixSort
setappdata(handles.output,'sortNorpix', get(hObject,'Value'));
end


% --- Executes when selected object is changed in rb_bgDiff.
function rb_bgDiff_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in rb_bgDiff 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
setappdata(handles.output,'bgDiff',get(eventdata.NewValue,'String') );
end


% --- Executes on button press in cb_linSpacedFramesImgMan.
function cb_linSpacedFramesImgMan_Callback(hObject, eventdata, handles)
% hObject    handle to cb_linSpacedFramesImgMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_linSpacedFramesImgMan
setappdata(handles.output,'plotLinFlagManip', get(hObject,'Value'));
if get(hObject,'Value') == 0,
    set(handles.ed_numPlotImg,'Enable','on');
else
    set(handles.ed_numPlotImg,'Enable','off');
end
end


% --- Executes on button press in cb_allFrames.
function cb_allFrames_Callback(hObject, eventdata, handles)
% hObject    handle to cb_allFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_allFrames
setappdata(handles.output,'allFramesFlag', get(hObject,'Value'));
if get(hObject,'Value') == 0,
    set(handles.ed_startFrame,'Enable','on');
    set(handles.ed_stopFrame,'Enable','on');
    movieFpos = getappdata(handles.output,'movieFilePos');
    
    setappdata(handles.output,'oldIDX', movieFpos.IDX);
else
    set(handles.ed_startFrame,'Enable','off');
    set(handles.ed_stopFrame,'Enable','off');
    oldIDX = getappdata(handles.output,'oldIDX');
    movieFpos = getappdata(handles.output,'movieFilePos');
    movieFpos.IDX = oldIDX;
    setappdata(handles.output,'movieFilePos',movieFpos);
    
    
end

end


% --- Executes on button press in cb_scriptAutoNaming.
function cb_scriptAutoNaming_Callback(hObject, eventdata, handles)
% hObject    handle to cb_scriptAutoNaming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_scriptAutoNaming
setappdata(handles.output,'scriptAutoNaming', get(hObject,'Value'));
end


% --- Executes on button press in cb_filterContours.
function cb_filterContours_Callback(hObject, eventdata, handles)
% hObject    handle to cb_filterContours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_filterContours
setappdata(handles.output,'useContourFilter', get(hObject,'Value'));
end


% --- Executes on button press in cb_undistort.
function cb_undistort_Callback(hObject, eventdata, handles)
% hObject    handle to cb_undistort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_undistort
setappdata(handles.output,'undistort', get(hObject,'Value'));
if get(hObject,'Value') == 1,
    movFpos = getappdata(handles.output,'movieFilePos');
    ImageHeight = movFpos.headerInfo.ImageHeight;
    ImageWidth = movFpos.headerInfo.ImageWidth;
    params = struct('fx',ImageWidth/2, ...
        'fy',ImageHeight/2,...
        'cx',ImageWidth/2 ,...
        'cy',ImageHeight/2 ,...
        'k1', -0.015,...
        'k2', -0.015,...
        'k3', 0,...
        'p1', -0.0075,...
        'p2', 0);
    setappdata(handles.output,'distortParams', params);
else
    params = struct('fx',0, ...
        'fy',0,...
        'cx',0 ,...
        'cy',0,...
        'k1',0,...
        'k2',0,...
        'k3',0,...
        'p1',0,...
        'p2',0);
    setappdata(handles.output,'distortParams', params);
    
end

end


%%%%%%%%%%%%%%%%%
% Edit Function %
%%%%%%%%%%%%%%%%%



function ed_angleCor_Callback(hObject, eventdata, handles)
% hObject    handle to ed_angleCor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_angleCor as text
%        str2double(get(hObject,'String')) returns contents of ed_angleCor as a double
setappdata(handles.output,'angleCorr',str2double(get(hObject,'String')));
end



function ed_conThresh_Callback(hObject, eventdata, handles)
% hObject    handle to ed_conThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_conThresh as text
%        str2double(get(hObject,'String')) returns contents of ed_conThresh as a double
setappdata(handles.output,'conThresh',str2double(get(hObject,'String')));
end


function ed_eroderR_Callback(hObject, eventdata, handles)
% hObject    handle to ed_eroderR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_eroderR as text
%        str2double(get(hObject,'String')) returns contents of ed_eroderR as a double
setappdata(handles.output,'eroderR', str2double(get(hObject,'String')));
end



function ed_minMajorAxis_Callback(hObject, eventdata, handles)
% hObject    handle to ed_minMajorAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_minMajorAxis as text
%        str2double(get(hObject,'String')) returns contents of ed_minMajorAxis as a double
setappdata(handles.output,'minMajorAxis',str2double(get(hObject,'String')));
end


function ed_maxMajorAxis_Callback(hObject, eventdata, handles)
% hObject    handle to ed_maxMajorAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_maxMajorAxis as text
%        str2double(get(hObject,'String')) returns contents of ed_maxMajorAxis as a double
setappdata(handles.output,'maxMajorAxis',str2double(get(hObject,'String')) );
end



function ed_minAspRatio_Callback(hObject, eventdata, handles)
% hObject    handle to ed_minAspRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_minAspRatio as text
%        str2double(get(hObject,'String')) returns contents of ed_minAspRatio as a double
setappdata(handles.output,'minAspRatio', str2double(get(hObject,'String')));
end



function ed_maxAspRatio_Callback(hObject, eventdata, handles)
% hObject    handle to ed_maxAspRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_maxAspRatio as text
%        str2double(get(hObject,'String')) returns contents of ed_maxAspRatio as a double
setappdata(handles.output,'maxAspRatio', str2double(get(hObject,'String')));
end



function ed_numBestFits_Callback(hObject, eventdata, handles)
% hObject    handle to ed_numBestFits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_numBestFits as text
%        str2double(get(hObject,'String')) returns contents of ed_numBestFits as a double
setappdata(handles.output,'numBestFits',str2double(get(hObject,'String')) );
end



function ed_expAnimalNum_Callback(hObject, eventdata, handles)
% hObject    handle to ed_expAnimalNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_expAnimalNum as text
%        str2double(get(hObject,'String')) returns contents of ed_expAnimalNum as a double
setappdata(handles.output,'expAnimalNum', str2double(get(hObject,'String')));
end



function ed_expAnimalLen_Callback(hObject, eventdata, handles)
% hObject    handle to ed_expAnimalLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_expAnimalLen as text
%        str2double(get(hObject,'String')) returns contents of ed_expAnimalLen as a double
setappdata(handles.output,'expAnimalLen',str2double(get(hObject,'String')));
end



function ed_expAnimalArea_Callback(hObject, eventdata, handles)
% hObject    handle to ed_expAnimalArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_expAnimalArea as text
%        str2double(get(hObject,'String')) returns contents of ed_expAnimalArea as a double
setappdata(handles.output,'animalArea',str2double(get(hObject,'String')));
end



function ed_voteWeights_Callback(hObject, eventdata, handles)
% hObject    handle to ed_voteWeights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_voteWeights as text
%        str2double(get(hObject,'String')) returns contents of ed_voteWeights as a double
setappdata(handles.output,'voteWeights',eval(get(hObject,'String')));
end



function ed_detScriptPath_Callback(hObject, eventdata, handles)
% hObject    handle to ed_detScriptPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_detScriptPath as text
%        str2double(get(hObject,'String')) returns contents of ed_detScriptPath as a double
setappdata(handles.output,'detScriptPath', get(hObject,'String'));
end



function ed_numPlotImg_Callback(hObject, eventdata, handles)
% hObject    handle to ed_numPlotImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_numPlotImg as text
%        str2double(get(hObject,'String')) returns contents of ed_numPlotImg as a double
setappdata(handles.output,'plotImgManNum', eval(get(hObject,'String')));
end




function ed_numLinSpaced_Callback(hObject, eventdata, handles)
% hObject    handle to ed_numLinSpaced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_numLinSpaced as text
%        str2double(get(hObject,'String')) returns contents of ed_numLinSpaced as a double
setappdata(handles.output,'numLinSpaced',str2double(get(hObject,'String')) );
end





function ed_specFrames2plot_Callback(hObject, eventdata, handles)
% hObject    handle to ed_specFrames2plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_specFrames2plot as text
%        str2double(get(hObject,'String')) returns contents of ed_specFrames2plot as a double
setappdata(handles.output,'specFrames2plot', eval(get(hObject,'String')) );
end



function ed_detScriptTag_Callback(hObject, eventdata, handles)
% hObject    handle to ed_detScriptTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_detScriptTag as text
%        str2double(get(hObject,'String')) returns contents of ed_detScriptTag as a double
setappdata(handles.output,'detScriptTag', get(hObject,'String'));
end



function ed_linSpacedImgMan_Callback(hObject, eventdata, handles)
% hObject    handle to ed_linSpacedImgMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_linSpacedImgMan as text
%        str2double(get(hObject,'String')) returns contents of ed_linSpacedImgMan as a double
setappdata(handles.output,'numLinSpacedImgMan', eval(get(hObject,'String')));
end



function ed_startFrame_Callback(hObject, eventdata, handles)
% hObject    handle to ed_startFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_startFrame as text
%        str2double(get(hObject,'String')) returns contents of ed_startFrame as a double
setappdata(handles.output,'plotFrameStart', str2double(get(hObject,'String')));
movieFpos = getappdata(handles.output,'movieFilePos');
stopFrame = getappdata(handles.output,'plotFrameStop');
newIDX = str2double(get(hObject,'String')):stopFrame;
movieFpos.IDX = newIDX;
setappdata(handles.output,'movieFilePos', movieFpos);
end




function ed_stopFrame_Callback(hObject, eventdata, handles)
% hObject    handle to ed_stopFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_stopFrame as text
%        str2double(get(hObject,'String')) returns contents of ed_stopFrame as a double
setappdata(handles.output,'plotFrameStop', str2double(get(hObject,'String')));
movieFpos = getappdata(handles.output,'movieFilePos');
startFrame = getappdata(handles.output,'plotFrameStart');
newIDX = startFrame:str2double(get(hObject,'String'));
movieFpos.IDX = newIDX;
setappdata(handles.output,'movieFilePos', movieFpos);
        
end



function ed_plotFrameNum_Callback(hObject, eventdata, handles)
% hObject    handle to ed_plotFrameNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_plotFrameNum as text
%        str2double(get(hObject,'String')) returns contents of ed_plotFrameNum as a double
setappdata(handles.output,'plotFrameNum', eval(get(hObject,'String')));
        movieFpos = getappdata(handles.output,'movieFilePos');
        
end



%%%%%%%%%%%%%%%%%%%%%
% Creation Function %
%%%%%%%%%%%%%%%%%%%%%


% --- Executes during object creation, after setting all properties.
function ed_angleCor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_angleCor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_conThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_conThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_eroderR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_eroderR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function pm_differenceDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_differenceDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_minMajorAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_minMajorAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes during object creation, after setting all properties.
function ed_maxMajorAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_maxMajorAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_minAspRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_minAspRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_maxAspRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_maxAspRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function ed_numBestFits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_numBestFits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function ed_expAnimalNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_expAnimalNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_expAnimalLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_expAnimalLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_expAnimalArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_expAnimalArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_voteWeights_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_voteWeights (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes during object creation, after setting all properties.
function ed_detScriptPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_detScriptPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_numPlotImg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_numPlotImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes during object creation, after setting all properties.
function ed_numLinSpaced_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_numLinSpaced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end



% --- Executes during object creation, after setting all properties.
function ed_specFrames2plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_specFrames2plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_detScriptTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_detScriptTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_linSpacedImgMan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_linSpacedImgMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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
function ed_stopFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_stopFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_plotFrameNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_plotFrameNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
