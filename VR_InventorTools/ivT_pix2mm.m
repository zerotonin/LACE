function mmTRA = ivT_pix2mm(pixBox,mmBox,pixTRA)
% This function transforms a pixel trace as rendered by ivTrace into real
% world coordinates. Thereby it uses the four corners of a rectangle in
% which the trajectory must stay inside. The functions needs the pixel and
% the realworld coordinates of the 4 corners of the rectangle. and then
% interpolates the trajectory lineary inside.
%
% GETS
%       pixBox = 4x2 matrix holding the pixel coordinates of the 4 corners
%        mmBox = 4x2 matrix holding the real world coordinates [m] of the 4
%                corners. If left empty the coordinates of the heat arena
%                are used. Then the pixel coordinates need to be in this
%                succession: Start at lower left corner and go counter
%                clock wise
%       pixTRA = mx2xp matrix holding the trajectory in pixel values. col(1)
%                x-values, col(2) y-values, m = number of frames, p
%                number of trajectories
%
% RETURNS
%        mmTRA = mx2xp matrix holding the trajectory in real world coordinates
%                col(1) x-values, col(2) y-values, m = number of frames, p
%                number of trajectories
%
% SYNTAX: mmTRA = ivT_pix2mm(pixBox,mmBox,pixTRA);
%
% Author: B.Geurten 20.3.12
%
% see also ivT_pixBoxGUI, TriScatteredInterp

if isempty(mmBox),
    disp('mmBox was empty so the default value was used! This default value')
    disp('are the real world coordinates for the heat arena (starting in the')
    disp('lower left corner and then counting counter clock wise)!')
    disp('                       3-----2')
    disp('                       |     |')
    disp('                       4-----1')
    
    mmBox = TMP_SR_getCMBox;
    
end

%preallocate variable
mmTRA = NaN(size(pixTRA,1),size(pixTRA,2),size(pixTRA,3));


% interpolate x values
F = TriScatteredInterp(pixBox(:,1), pixBox(:,2), mmBox(:,1)); % built interpolation object for x - real world
mmTRA(:,1,:)= F(pixTRA(:,1,:),pixTRA(:,2,:)); % interpolate with pixel positions
% interpolate
mmTRA(:,1,:) = linInterp(mmTRA(:,1,:));


%interpolate y values
F = TriScatteredInterp(pixBox(:,1), pixBox(:,2), mmBox(:,2)); % built interpolation object for y - real world
mmTRA(:,2,:)= F(pixTRA(:,1,:),pixTRA(:,2,:)); % interpolate with pixel positions
% interpolate
mmTRA(:,2,:) = linInterp(mmTRA(:,2,:));
end

function coord2 = linInterp(coord)
v        = ~isnan(coord);
G        = griddedInterpolant(find(v), coord(v), 'previous');
idx      = find(~v);
bp       = G(idx);
G.Method = 'next';
bn       = G(idx);
coord2   = coord;
coord2(idx)   = (bp + bn) / 2;
end
