function dset = ET_DLC_readh5(h5Pos)
% This function of the Ethotrack deepLabCut toolbox (ET_DLC_) reads inn the
% h5 result files of deepLabCut. The result files are unaltered and
% returned as a matrix. If you want to read in a trajectory you want to use
% ET_DLC_openTra, this is a lowlevel function
%
% GETS:
%         h5Pos =  string; file position of the h5 file
%    
% RETURNS:
%          dSet = matrix of floats; mxn where n is the number of frames
%                 analysed by deepLabCut and m = regions *3. Each region
%                 starts with a row for the x coordinate, than a row for
%                 the y coordinate and than the quality of object
%                 recognition.
%
% SYNTAX: dset = ET_DLC_readh5(h5Pos);
%
% Author: B. Geurten 09-19-19
%
% see also h5read,ET_DLC_formatDLC2TRA, ET_DLC_openTra

dset = h5read(h5Pos,'/df_with_missing/table');
dset = dset.values_block_0;