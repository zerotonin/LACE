function ivT_movie_setSize(fig,figParameters)
% This subroutine of the ivT_movie toolbox (ivTrace movie making toolbox)
% actually set size and position of a figure to a predefined set of
% values. This set consits of struct with the fields PaperUnits, Position
% and Paper Position, as correspondend to the figure properties. This can
% be easily defined by ivT_movie_GWYSsize
%
% GETS:
%       fig = figure handle of the figure to be adjusted
% paramters = parameters a struct with three fields PaperUnits, Position
%             and Paper Position, as correspondend to the figure
%             properties (see ivT_movie_GWYSsize)
%
% RETURNS: bothing
%
% SYNTAX: ivT_movie_setSize(fig,figParameters);
%
% Author: B. Geurten 13.10.15
%
% see also ivT_movie_GWYSsize, ivT_movie_frame4speedNtraj


set(fig,'PaperUnits',figParameters.PaperUnits);
set(fig,'Position',figParameters.Position);
set(fig,'PaperPosition',figParameters.PaperPosition);