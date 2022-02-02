function ET_GUI_spline_SR_writeScript(handles)
% This function of the Ethotrack graphical user interface toolbox (ET_GUI_)
% this function actually writes the script that is later on used to analyse
% the movie. The script will be in the folder set by the field detetction
% scroipt path, subfolder scripts. 
%
% GETS:
%             handles = struct holding all gui handles
%
%
% RETURNS:
%             writes a script according to the settings in the gui to
%             either remote or auto named positions.
%
% SYNTAX:  ET_GUI_spline_SR_writeScript(handles);
%
% Author: B.Geurten 01-28-2016
% 
% Notes:
% This might only work for Zebrafishes!
%
% see also ET_GUI_spline_SR_imageManip


%check flag
goOn =1;

%gather data from handles
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
prevDetection=getappdata(handles.output,'usePrevPos');
expetedLength= getappdata(handles.output,'expAnimalLen');
expetedSize= getappdata(handles.output,'animalArea');
voteWeights= getappdata(handles.output,'voteWeights');
expectedAnimals= getappdata(handles.output,'expAnimalNum');
multiDetectionPossible= getappdata(handles.output,'useMultDet');
sortNorpix= getappdata(handles.output,'sortNorpix');
calcDur = getappdata(handles.output,'calcDur');
pix2mm = getappdata(handles.output,'pix2mm');
detScriptPath = getappdata(handles.output,'detScriptPath');
scriptAutoNaming = getappdata(handles.output,'scriptAutoNaming');
headerSize = getappdata(handles.output,'headerSize');
movieFpos = getappdata(handles.output,'movieFilePos');
%get movie position
movFileName = movieFpos.fPos;
% get file basis name
[~,fileBasis,~]=fileparts(movFileName);
idx = strfind(fileBasis,'-');
fileBasis(idx) = '_';
if  getappdata(handles.output,'useROI') ==1,
    maskIDX = getappdata(handles.output,'ROI');
else
    maskIDX = [];
end

%get background
backGround = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
if isempty(bgSubModus) || strcmp(bgSubModus,'difference direction'),
    errordlg('You have to pick a substraction mode first')
    goOn = 0;
else
    goOn = 1;
    
end



%get filenames
if goOn==1,
    
    % filenames
    if scriptAutoNaming == 1,
        
    [bgFileName,roiFileName,scriptFileName,variablesFileName,...
             resultFileName] = ET_GUI_spline_SR_autoNamingScripts(handles);
    else
    %overwrite if remote names where chosen
    [bgFileName,roiFileName,scriptFileName,variablesFileName,...
              resultFileName] = ET_GUI_spline_SR_remoteNamingScripts(handles,...
              bgFileName,roiFileName,scriptFileName,variablesFileName,...
              resultFileName);
    end
end

%check if script name allready exists
if goOn ==1,
    toDo = load2var([detScriptPath 'ET_Script_Manager_todo.mat']);
    if ~isempty(toDo),
        idx = find(~cellfun(@isempty,strfind(toDo(:,1),scriptFileName)));
        if ~isempty(idx),
            answer = questdlg('There is allready a script with that name','name conflict','overwrite','abort','abort');
            if strcmp(answer,'abort')
                goOn = 0;
            else
                toDo(idx,:) = [];
            end
        end
    end
end


% now start writing the script
if goOn==1,
    
    %write data files
    save(bgFileName,'backGround');
    save(roiFileName,'maskIDX');
    save(variablesFileName,...
        'movieFpos','bgDir','bgSubModus','angleCorrection','contrastThresh',...
        'eroderR','ellipseParams','bestEllipsesN','prevDetection','expetedLength',...
        'expetedSize','voteWeights','expectedAnimals','multiDetectionPossible','pix2mm','headerSize');
    
    fid = fopen(scriptFileName,'w');
    
    % Header
    fprintf(fid,'%s\n','% This script was automatically designed by ET_GUI_spline for further information');
    fprintf(fid,'%s\n','% look into the doczumentation of the specific functions. This script can be run');
    fprintf(fid,'%s\n','% manually or via ET_GUI_script2bash. ET_GUI_script2bash, devides the tasks onto');
    fprintf(fid,'%s\n','% many CPUs and is preferable!');
    fprintf(fid,'%s\n','% ');
    fprintf(fid,'%s %5.2f \n','% Estimated time [min]: ',round2digit((median(calcDur)*length(movieFpos.IDX))/60,2));
    fprintf(fid,'%s\n','');
    
    fprintf(fid,'%s\n','clear;clc;');
    fprintf(fid,'%s\n','');
    
    %intialise variables
    fprintf(fid,'%s\n','% intialise variables');
    fprintf(fid,'%s\n','backGround = NaN;');
    fprintf(fid,'%s\n','maskIDX = NaN;');
    fprintf(fid,'%s\n','movieFpos = NaN;');
    fprintf(fid,'%s\n','bgDir = NaN;');
    fprintf(fid,'%s\n','bgSubModus = NaN;');
    fprintf(fid,'%s\n','angleCorrection = NaN;');
    fprintf(fid,'%s\n','contrastThresh = NaN;');
    fprintf(fid,'%s\n','eroderR = NaN;');
    fprintf(fid,'%s\n','ellipseParams = NaN;');
    fprintf(fid,'%s\n','bestEllipsesN = NaN;');
    fprintf(fid,'%s\n','prevDetection = NaN;');
    fprintf(fid,'%s\n','expetedLength = NaN;');
    fprintf(fid,'%s\n','expetedSize = NaN;');
    fprintf(fid,'%s\n','voteWeights = NaN;');
    fprintf(fid,'%s\n','expectedAnimals = NaN;');
    fprintf(fid,'%s\n','multiDetectionPossible = NaN;');
    fprintf(fid,'%s\n','headerSize = NaN;');
    fprintf(fid,'%s\n',['scriptName = ''' scriptFileName ''';']);
    fprintf(fid,'%s\n',['pix2mm = NaN;']);
    fprintf(fid,'%s\n','');
    
    
    %Load binaries
    fprintf(fid,'%s\n','% loading binaries (variable,roi and background) ');
    fprintf(fid,'%s\n',['load(''' bgFileName ''');']);
    fprintf(fid,'%s\n',['load(''' roiFileName ''');']);
    fprintf(fid,'%s\n',['load(''' variablesFileName ''');']);
    fprintf(fid,'%s\n','');
    
    % open file dialogue
    fprintf(fid,'%s\n','% open file dialogue');
    if sortNorpix ==1,
        fprintf(fid,'%s\n',['[fid, endianType,headerInfo,imgOut, IDX] = ivT_norpix_openSeq(''' movieFpos.fPos ''',''onlyHeader'',''sort'');']);
    else
        fprintf(fid,'%s\n',['[fid, endianType,headerInfo,imgOut, IDX] = ivT_norpix_openSeq(''' movieFpos.fPos ''',''onlyHeader'','''');']);
    end
    fprintf(fid,'%s\n','');
    
    if prevDetection ==1,
        %central loop
        fprintf(fid,'%s\n','% central loop');
        fprintf(fid,'%s\n','traceResult= cell(length(movieFpos.IDX),5);');
        fprintf(fid,'%s\n','traceResult(1,:) = ET_anaS_basic4spline(fid,headerInfo,endianType,...');
        fprintf(fid,'%s\n','  IDX,1,angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...');
        fprintf(fid,'%s\n','  ellipseParams,bestEllipsesN,[],expetedLength,expetedSize,voteWeights,...');
        fprintf(fid,'%s\n','  expectedAnimals,multiDetectionPossible,maskIDX,headerSize);');
        fprintf(fid,'%s\n','');
        fprintf(fid,'%s\n','for frameNumber=2:length(movieFpos.IDX),');
        fprintf(fid,'%s\n','         traceResult(frameNumber,:) = ET_anaS_basic4spline(fid,headerInfo,endianType,...');
        fprintf(fid,'%s\n','             IDX,frameNumber,angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...');
        fprintf(fid,'%s\n','             ellipseParams,bestEllipsesN,traceResult{frameNumber-1,1}(:,1:2),expetedLength,expetedSize,voteWeights,...');
        fprintf(fid,'%s\n','             expectedAnimals,multiDetectionPossible,maskIDX,headerSize);');
        fprintf(fid,'%s\n','');
        fprintf(fid,'%s\n','         if frameNumber==2 || mod(frameNumber,100) == 0,');
        fprintf(fid,'%s\n',['                  disp([''Analysing ' fileBasis ': '' num2str((frameNumber/length(movieFpos.IDX)).*100) '' % | @ '' datestr(now)])']);
        fprintf(fid,'%s\n','         end');
        fprintf(fid,'%s\n','');
        fprintf(fid,'%s\n','end');
        fprintf(fid,'%s\n','');
    else
        %central loop
        fprintf(fid,'%s\n','% central loop');
        fprintf(fid,'%s\n','traceResult= cell(length(movieFpos.IDX),5);');
        fprintf(fid,'%s\n','for frameNumber=1:length(movieFpos.IDX),');
        fprintf(fid,'%s\n','         traceResult(frameNumber,:) = ET_anaS_basic4spline(fid,headerInfo,endianType,...');
        fprintf(fid,'%s\n','             IDX,frameNumber,angleCorrection,backGround,bgSubModus,contrastThresh,eroderR,...');
        fprintf(fid,'%s\n','             ellipseParams,bestEllipsesN,[],expetedLength,expetedSize,voteWeights,...');
        fprintf(fid,'%s\n','             expectedAnimals,multiDetectionPossible,maskIDX,headerSize);');
        fprintf(fid,'%s\n','');
        fprintf(fid,'%s\n','         if frameNumber==1 || mod(frameNumber,100) == 0,');
        fprintf(fid,'%s\n',['                  disp([''Analysing ' fileBasis ': '' num2str((frameNumber/length(movieFpos.IDX)).*100) '' % | @ '' datestr(now) ])']);
        fprintf(fid,'%s\n','         end');
        fprintf(fid,'%s\n','');
        fprintf(fid,'%s\n','end');
        fprintf(fid,'%s\n','');
    end
    
    %close movie filedialog
    fprintf(fid,'%s\n','% closing fid');
    fprintf(fid,'%s\n','fclose(fid);');
    fprintf(fid,'%s\n','');
    
    % saving stuff
    fprintf(fid,'%s\n','% saving result');
    fprintf(fid,'%s\n',['save(''' resultFileName ''',''traceResult'',''pix2mm'');']);
    fprintf(fid,'%s\n','');
    
    % update toDo Manager
    fprintf(fid,'%s\n','% update toDo Manager');
    fprintf(fid,'%s\n',['toDo = load2var([''' detScriptPath ''' filesep ''ET_Script_Manager_todo.mat'']);']);
    fprintf(fid,'%s\n',' idx = find(~cellfun(@isempty,strfind(toDo(:,1),scriptName)));');
    fprintf(fid,'%s\n',' toDo(idx,:) = [];');
    fprintf(fid,'%s\n',['save([''' detScriptPath ''' filesep ''ET_Script_Manager_todo.mat''],''toDo'');']);
    
    fprintf(fid,'%s\n','');
    
    %close file dialogue
    fclose(fid);
    
    
    % now update the todo manager
    toDo = [toDo; {scriptFileName median(calcDur)*length(movieFpos.IDX)}];
    save([detScriptPath 'ET_Script_Manager_todo.mat'],'toDo');
    
end