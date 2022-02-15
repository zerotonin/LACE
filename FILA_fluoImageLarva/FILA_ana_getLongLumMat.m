function [lumMat,lengthLum,mostStretchedL,pixRatio] = FILA_ana_getLongLumMat(data)
% This function extracts the luminence values from the data  struct of the
% FILA_anaStack. As 3D matrix for easier calculation
% GETS:
%           data = the
%
% RETURNS
%         anaRes = a struct array containing the following fields
%          image : a cropped and turned version of the orignial image
%        longLum : 6xn matrix where n is the width of the image and the rows
%                  are as follows: 1) median 2) mean 3) variance 4)
%                  standard deviation 5) upper confidence interval 6)
%                  lower CI
% transform to cell
dataC = struct2cell(data);
% get the size of the luminence vector
lengthLum  = cellfun(@(x) size(x,2),dataC(4,:,:));
% get the longest  vector
[longestLen,mostStretchedL] = max(lengthLum);
% now find out how many NaN values you have to add to create a real matrix
addNaN = num2cell((lengthLum-longestLen).*-1);
% add the NaN values
lumMat = cellfun(@(x,y) [x NaN(6,y)],dataC(4,:,:),addNaN,'UniformOutput',false);
% cell 2 mat and rearrange Dim 1: Median Mean STD VAR CIu CIl DIM2: pixel
% DIM3: frames
lumMat = cell2mat(reshape(lumMat,[1,1,length(lumMat)]));
pixRatio = cell2mat(dataC(3,:))';