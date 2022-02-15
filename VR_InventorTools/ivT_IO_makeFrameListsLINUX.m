function ivT_IO_makeFrameListsLINUX(parentPath,extension)
% This function finds all files of a user set extension in subdirectories
% and writes their absolute fileposition into textfiles named after their
% subdirectory.
%
% GETS: 
%       parentPath = path to the directory holding the picture
%                    subdirectories
%        extension = extension of the files that should be listed, eg 'jpg'
%
% RETURNS: 
%               textfiles and prints out fileposition on the screen;
%
%
% SYNTAX: ivT_IO_makeFrameListsLINUX(parentPath,extension);
%
% Author: B.Geurten
%
% see also fprintf, system, dir

% get all files
fileList = dir(parentPath);
%make cell for logical indexing reasons
fileList = struct2cell(fileList);
%get the information if files are directories
logInd = cell2mat(fileList(4,:));
%keep only files that are directories
fileList = fileList(1,logInd == 1);

for i=3:length(fileList) % because '.' and '..' are also directories
    fprintf(['Writing file-list: ' parentPath filesep 'FL_'  fileList{i} '.txt ... '])
    %Linux command
    command = ['find ' parentPath filesep fileList{i} '/ -name ''*.' extension ''' |sort > '...
                parentPath '/FL_' fileList{i} '.txt'];
    system(command);
    fprintf('done\n')
    
end