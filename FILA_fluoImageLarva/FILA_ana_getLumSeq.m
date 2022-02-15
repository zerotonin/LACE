function lumSeq = FILA_ana_getLumSeq(dataC)
% This function of FILA toolbox takes the data cell matrix and composes
% a 3D matrix from the lum matrices of the cell matrix. The data is usually
% save in the 4 row of the cell matrix and its format is mx n, where m is
% th number of features (mean, median, etc) and n is the image width. Now
% this function patches n so that it as large as the largest matrix with
% NaN values and merges them in the third dimension.
%
% GETS:
%
%       dataC = cellmatrix that holds the lumMatrix in the 4th row, after
%               head correction see FILA_ana_turnHead2right
%
% RETURNS:
%      lumSeq = mxnxp matrix, m = number of features, n is the maximal
%               image width, p is the number of frames
%
% SYNTAX: lumSeq = FILA_ana_getLumSeq(dataC)
%
% Author: B. Geurten 25.2.15
%
% see also FILA_ana_turnHead2right


%detect maximal imageWidth
imageWidth = max(cellfun(@(x) size(x,2),dataC(4,:)));
%detect number of extracted features
featureNb = size(dataC{4,1},1);
% patch matrix with NaN values
lumSeq = cellfun(@(x) [x NaN(featureNb,imageWidth-size(x,2))],dataC(4,:),'UniformOutput',false);
%reshape to 3D
lumSeq = cell2mat(reshape(lumSeq,[1,1,length(lumSeq)]));