 function [fileList, frames] = ivT_HBcoord_getFileLocation4Animal(traceTXTPos)
% This function is part of the head-body-coordination - sub-toolbox. This
% toolbox was written to analyse 3D manual thorax and head
% trajectories. The basic idea is that the head and thorax where traced in
% the  same movie and now we can calculate the differeneces in orientation.
%
% The idea behind this function is that every analysed animal has a txt
% file in the parent directory of that animals that includes information
% about the status of the tracing. For example the file could look like
% this:
% movie                 frames		head		thorax
% 2012-09-12--13_48_56 	0-250		done		done
% 2012-09-12--13_51_28	733-936		done		done
% 2012-09-12--13_56_28	60-620		done		done
% 2012-09-12--13_58_22	200-750		done
% 2012-09-12--13_59_18  unusebale due to tremors
% 2012-09-12--13_59_53  12-666      done        done
%
% The first line contains the heading row one contains the date and time of
% the movie which corresponds to the directory in which the traces are
% located. Pratically any string can be used as long as it is part of the
% directory name and at least 20 signs long. Seperated by tabstops or space 
% the frames that are analysed follow. The start and end frame are 
% seperated by a - . After this the head and thorax status follow if the 
% row does not contain two times the word "done" The files will not be 
% loaded. In the above example only lines 1-3 and 6 will be used.
% 
% GETS:
%      traceTXTPos = string containing the absolute fileposition if ommited
%                    the verbose mode will start
%
% RETURNS:
%         fileList = a mx2 cellstr which contains fileLocations to the head
%                    thorax trajectories. where col(1) holds the head
%                    trajectories and col(2) the thorax trajectories
%
% SYNTAX:[fileList, frames] = ivT_HBcoord_getFileLocation4Animal(traceTXTPos) ;
%
% Author: B.Geurten
%
% see also strfind, ivT_IO_3DmanTrace

% get the info File position
if exist('traceTXTPos','var'),
    fileSeps = strfind(traceTXTPos,filesep);
    infoPN = traceTXTPos(1:fileSeps(end));
    infoFN = traceTXTPos(fileSeps(end)+1:end);
else
    
[infoFN, infoPN] = uigetfile( ...
{'*.txt;*.nfo;*.;','Text Files (*.txt,*.nfo,*.)';...
   '*.*',  'All Files (*.*)'}, ...
   'Pick the info file');
end

%get directories
directories=dir(infoPN);
% remove all files
directories(~[directories(:).isdir]) = [];
% get names in cell
directoriesName = {directories(:).name};

% read out infoFile
fid = fopen([infoPN infoFN]);
infoLine = fgetl(fid);
candidateDirectoryName = {};
frames = [];
while ischar(infoLine),
    doneNb = strfind(infoLine,'done');
    if length(doneNb) == 2
        candidateDirectoryName = [candidateDirectoryName; sscanf(infoLine,'%s[ ]')];
        endOfDname = size(candidateDirectoryName{end},2)+1;
        frames = [frames; sscanf(infoLine(endOfDname:doneNb(1)-1),'%d-%d')'];
    end
    infoLine = fgetl(fid);
end
fclose(fid);

% geting the head and thorax file positions
fileList = cell(size(candidateDirectoryName,1),2);
delMe = [];
for i =1:size(candidateDirectoryName,1),
    %get the directory
    tmpDir = directoriesName{~cellfun(@isempty,strfind(directoriesName,candidateDirectoryName{i}))};
    % get file position
    [headFN, headPN] = uigetfile( ...
    {'*.traj;*.tra*;*.;','Trajectory Files (*.traj,*.tra,*.)';...
   '*.*',  'All Files (*.*)'}, ...
   'Pick the head trajectory', [infoPN tmpDir filesep]);
    % get file position
    [thoraxFN, thoraxPN] = uigetfile( ...
    {'*.traj;*.tra*;*.;','Trajectory Files (*.traj,*.tra*,*.)';...
   '*.*',  'All Files (*.*)'}, ...
   'Pick the thorax trajectory', [infoPN tmpDir filesep]);
    
    % check if the user cancelled any filepositions and save row number in
    % delMe otherwise save fileposition to return variable
    if ~ischar(headFN) || ~ischar(thoraxFN),
        delMe = [delMe;i];
        disp(['The user cancelled trajectories for: ' infoPN tmpDir filesep])
    else
        fileList{i,1} = [headPN headFN];
        fileList{i,2} = [thoraxPN thoraxFN];
    end
    
end

% delete rows conating the filepositions and frames of user cancelled files
fileList(delMe,:) = [];
frames(delMe,:) = [];
