function tra = ET_DLC_openTra(h5Pos)
% This function of the Ethotrack deepLabCut toolbox (ET_DLC_) opens a h5
% file of deeplab cut and returns it as a 3D matrix.
% GETS:
%          dSet = matrix of floats; mxn where n is the number of frames
%                 analysed by deepLabCut and m = regions *3. Each region
%                 starts with a row for the x coordinate, than a row for
%                 the y coordinate and than the quality of object
%                 recognition. This is returned by ET_DLC_readh5.
%    
% RETURNS:

%           tra = matrix of floats; mxnxp, where m is the number of frames
%                 analysed. n is 1) x-coordinate 2) y-coordinate 3) object
%                 recognition quality. p is number of different regions
%
% SYNTAX:  tra = ET_DLC_openTra(h5Pos)
%
% Author: B. Geurten 09-19-19
%
% see also ET_DLC_readh5, ET_DLC_formatDLC2TRA

 dset = ET_DLC_readh5(h5Pos);
 tra = ET_DLC_formatDLC2TRA(dset);