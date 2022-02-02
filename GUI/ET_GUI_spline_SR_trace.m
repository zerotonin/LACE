
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
headSize= getappdata(handles.output,'headSize');
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
    traceResult = ET_anaS_basic4spline(movieFpos.fid,movieFpos.headerInfo,movieFpos.endianType,...
        movieFpos.IDX,frameNumber,angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...
        ellipseParams,bestEllipsesN,prevDetection,expetedLength,expetedSize,voteWeights,...
        expectedAnimals,multiDetectionPossible,maskIDX,headSize);
    
end
end