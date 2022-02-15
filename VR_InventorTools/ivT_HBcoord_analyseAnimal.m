function trajectories = ivT_HBcoord_analyseAnimal(fileList,frames,frameRate,filterChoice)
% This function is part of the head-body-coordination - sub-toolbox. This
% toolbox was written to analyse 3D manual thorax and head
% trajectories. The basic idea is that the head and thorax where traced in
% the  same movie and now we can calculate the differeneces in orientation.
%
% This function analyses all trajectories of a single animal. Therefore the
% data has to be arranged in the following way: The parentdirectory for one
% animal contains a information text file as described in 
% ivT_HBcoord_getFileLocation4Animal. All trajectories are in
% subdirectories to this directory. The functions returns a mx2 cell
% array where m is the number of movies and column 1 holds the head
% trajectories, where column 2 holds the thorax trajectories.
% 
% GETS:
%         hfile = absolute file position of the 3D-mask trajectory for the
%                 head
%         tfile = absolute file position of the 3D-mask trajectory for the
%                 thorax
%       indices = frame indices of the interessting part of the trajectory
%                 (ivTrace frames!)
%     frameRate = frame rate with which the original movie was calculated
%  filterChoice = number that sets the filter type used to filter the
%                 trajectories:
%                 1 = Savitzky-Golay (3,21)
%                 2 = Savitzky-Golay (3,31)
%                 3 = Butterworth (2,0,1)
%                 4 = Butterworth (2,0.05)
%                 5 = Butterworth (3,0.1)
%                 6 = Gauss 50 frame window | 3 frame sigma
%                 default and other values evoke no filtering
%
% RETURNS:
%         fileList = a mx2 cellstr which contains fileLocations to the head
%                    thorax trajectories. where col(1) holds the head
%                    trajectories and col(2) the thorax trajectories
%
% SYNTAX:[fileList, frames] = ivT_HBcoord_getFileLocation4Animal() ;
%
% Author: B.Geurten
%
% see also strfind, ivT_IO_3DmanTrace

% get file Locations
if isempty(fileList) || isempty(frames),
    
    [fileList, frames] = ivT_HBcoord_getFileLocation4Animal();
    tmpPath = fileList{1,1};
    filesepPos = strfind(tmpPath,filesep);
    [flistFN,flistPN] = uiputfile('*.mat','Save File Position Information',[tmpPath(1:filesepPos(end-1)) 'filePositions.mat']);
    if ischar(flistFN)
        save([flistPN,flistFN],'fileList','frames')
    end
end

%preallocate
traNb=size(frames,1);
trajectories = cell(traNb,2);
disp (repmat('_',1,50));

for i =1:traNb,
    disp(['analysing: ' fileList{i,1} ])
    disp(['analysing: ' fileList{i,2} ]);
    disp (repmat('_',1,50));
    % load data & analyse
    [trajectories{i,1},trajectories{i,2}] = ivT_HBcoord_analyse2trajs(fileList{i,1},fileList{i,2},frames(i,:),frameRate,filterChoice);
end
