function tra = ET_DLC_formatDLC2TRA(dset)
% This function of the Ethotrack deepLabCut toolbox (ET_DLC_) transfroms
% the raw output of the dlc h5 file into an easier format for matlab.
%
% GETS:
%          dSet = matrix of floats; mxn where n is the number of frames
%                 analysed by deepLabCut and m = regions *3. Each region
%                 starts with a row for the x coordinate, than a row for
%                 the y coordinate and than the quality of object
%                 recognition. This is returned by ET_DLC_readh5.
%    
% RETURNS:
%
%           tra = matrix of floats; mx3xp, where m is the number of frames
%                 analysed. n is 1) x-coordinate 2) y-coordinate 3) object
%                 recognition quality. p is number of different regions
%
% SYNTAX:  tra = ET_DLC_formatDLC2TRA(dset);
%
% Author: B. Geurten 09-19-19
%
% see also ET_DLC_readh5, ET_DLC_openTra

[row,samples] = size(dset);
flyNum = row/3;
tra = NaN(samples,3,flyNum);
for i =1:3:row
    flyI = ceil(i/3);
    tra(:,1,flyI) = dset(i,:)';
    tra(:,2,flyI) = dset(i+1,:)';
    tra(:,3,flyI) = dset(i+2,:)';
end