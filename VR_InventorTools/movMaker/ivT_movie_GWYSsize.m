function figParameters = ivT_movie_GWYSsize(fig)
% This subroutine of the ivT_movie toolbox (ivTrace movie making toolbox)
% actually helps user define the proper figure size for the exported single
% frames. 1st step: plot the figure that you want to save as a videoframe 
% than adjust it's with height and position. 2nd step use ivT_movie_GWYSsize
% to copy sizes etc. to figParameteres. Notice that functions like
% ivT_movie_frame4speedNtraj will use tightfig and thereby change size
% again.
%
% GETS:
%       fig = figure handle of the adjusted figure
%
% RETURNS:
% paramters = parameters a struct with three fields PaperUnits, Position
%             and Paper Position, as correspondend to the figure
%             properties
%
% SYNTAX: figParameters = ivT_movie_GWYSsize(fig);
%
% Author: B. Geurten 13.10.15
%
% see also ivT_movie_setSize, ivT_movie_frame4speedNtraj


figParameters.PaperUnits    = 'points';
figParameters.Position      = get(fig,'Position');
figParameters.PaperPosition = get(fig,'Position');