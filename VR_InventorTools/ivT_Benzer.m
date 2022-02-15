function filePos = ivT_Benzer_getFilePos(pFolder)
%This function findes directories that hold exactly one txt one tra and one
%jpg file. It is used for batch processing of large numbers of benzer test
%observations and returns the file positions of the aforementioned files as
%a mx3 cell str.
%
% GETS
%       pFolder = parent folder from which the directories are searched
%
% RETURNS:
%       filePos = mx3 cellstr matrix where each row is one subdirectory and
%                 col(1) holds the trajectory position col(2) holds the pic
%                 position col(3) holds the txt position
%
% SYNTAX: filePos = ivT_Benzer(pFolder);
%
% Author: B.Geurten 230714
%
% see also 


% system call to find all directories 
system(['find ' pFolder ' -type d | sort > ' pFolder 'folderList.txt '])
% read in the resulting txt files
folderList = textread([pFolder 'folderList.txt'],'%s\n');


% get all subfolder that contain exactly one tra one txt and one jpg
% search for jpg
picPos = cellfun(@(x) dir([x filesep '*.jpg']),folderList,'UniformOutput',false) ;
% search for tra files
traPos = cellfun(@(x) dir([x filesep '*.tra']),folderList,'UniformOutput',false) ;
%search for txt files
txtPos = cellfun(@(x) dir([x filesep '*.txt']),folderList,'UniformOutput',false) ;

% make a logic connection between all 3 searches
thisShouldBe3 = cellfun(@(x,y,z) sum([length(x) length(y) length(z)]),picPos,traPos,txtPos);
logIDX = thisShouldBe3 == 3;

% get all absolute file positions
picPos = cellfun( @(x,y) [y filesep x.name]  ,picPos(logIDX),folderList(logIDX),'UniformOutput',false);
traPos = cellfun( @(x,y) [y filesep x.name]  ,traPos(logIDX),folderList(logIDX),'UniformOutput',false);
txtPos = cellfun( @(x,y) [y filesep x.name]  ,txtPos(logIDX),folderList(logIDX),'UniformOutput',false);
% built return variable
filePos = [traPos picPos txtPos];

end