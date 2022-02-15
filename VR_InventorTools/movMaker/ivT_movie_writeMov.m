function ivT_movie_writeMov(fPos,movie,fps,quality)
% This subroutine of the ivT_movie toolbox (ivTrace movie making toolbox),
% writes a MATLAB movie struct array to disk as an avi file in 'Archival' -
% codec. The video writing is done via VideoWriter
% 
%
% GETS:
%     movie = a Matlab movie struct array with 2 fields cdata and image as
%             returned by ivT_movie_makeMovie
%      fPos = absolute target file position
%       fps = replay fps
%   quality = setting of the codec quality 0-100%
%
% RETURNS:
%           writes avi file on disk
%
% SYNTAX: ivT_movie_writeMov(fPos,movie,fps,quality);
%
% Author: B. Geurten 14.10.15
%
% see also ivT_movie_makeMovie, ivT_movie_makeMovieFrame, VideoWriter
myVideo = VideoWriter(fPos);
myVideo.FrameRate = fps;  % Default 30
myVideo.Quality = quality;

% check length
dataC = struct2cell(movie);
dataC = reshape(dataC,2,length(movie));
[row,col,layers] = cellfun(@size,dataC(1,:,:));
rowM = min(row);
colM = min(col);
layM = min(layers);
%back fom cell 2 struct
dataC(1,:) =cellfun(@(x) x(1:rowM,1:colM,1:layM),dataC(1,:),'UniformOutput',false);
movie = cell2struct(dataC,{'cdata','colormap'},1)';
clear dataC



open(myVideo)
writeVideo(myVideo, movie);
close(myVideo);