function pixBox = ivT_pixBoxFromCenterNradius(center,radius)
% This function transforms a pixel trace as rendered by ivTrace into real
% world coordinates. Thereby it uses the four corners of a rectangle in
% which the trajectory must stay inside. The functions needs the pixel and
% the realworld coordinates of the 4 corners of the rectangle. and then
% interpolates the trajectory lineary inside.
%
% GETS
%        center = a 1x2 matrix holding the x and y position of the center
%                 of the circular arena, as for example deduced by ivT_GUI_circleArena
%        radius = a scalar with the radius of the circular arena in pixels
%
% RETURNS
%       pixBox = 4x2 matrix holding the pixel coordinates of the 4 corners
%                starting in the lower left corner and then counting 
%                counter clock wise)
%                       3-----2
%                       |     |
%                       4-----1
%
% SYNTAX: pixBox = ivT_pixBoxFromCenterNradius(center,radius)
%
% Author: B.Geurten 22.7.17
%
% see also ivT_pixBoxGUI,TriScatteredInterp,ivT_pix2mm,ivT_GUI_circleArena



pixBox =[center(1)+radius center(2)-radius;...
         center(1)+radius center(2)+radius;...
         center(1)-radius center(2)+radius;...
         center(1)-radius center(2)-radius];




