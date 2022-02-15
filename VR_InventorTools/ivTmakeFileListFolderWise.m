function ivTmakeFileListFolderWise(path,prefix,suffix)
% This Matlab function creates a list of tif files for every directory in a
% parent directory. The files must have a common prefix, as for example 
% "first_" or "frame", same goes for the file extension aka suffix.  The
% list will be saved in the parent folder as "subfolder Name" _list.txt
%
% GETS:
%        path = path to parent directory
%      prefix = common prefix of all to list files, e.g. 'frame_'
%      suffix = common suffix of all to list files, e.g.'tif','jpg' or 'txt'
%
% RETURNS: dispalys list position and entry number in the command window 
%
% SYNTAX: ivTmakeFileListFolderWise(path,prefix,suffix);
%
% Author: Bart Geurten
% 
% see also: filesep, dir, fopen, fclose, fprintf, inputdlg,ivTmakeFileList

% get list of files in the parent folder
dirList = dir(path);

% check every folder in parent folder and make fileList
for i =1:length(dirList),
    dirName = dirList(i).name; % get file name
    if dirList(i).isdir && ~strcmp(dirName,'.') && ~strcmp(dirName,'..'), % check if it is a directory and not . or ..
        ivT_makeFileList([path filesep dirName],prefix,suffix,path,[dirName '_list.txt']); % write file List to parent directory
    end
end