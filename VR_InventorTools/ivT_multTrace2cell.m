function traCell = ivT_multTrace2cell(tra)
% This function splits a multiple area trace into a cellmatrix only holding
% one are per cell.
%
% GETS:
%
%       tra = a full 2D trace with multiple areas; 1+numberOfanimals*5
%             columns; number of rows = frames
%
% RETURNS:
%
%   traCell = a cell matrix consinsting of as many cells as areas and each
%             matrix is mx5, where m is the number of frames
%
% SYNTAX: traCell = ivT_multTrace2cell(tra);

%tra(:,1) = [];

tra_nb = size(tra,2)/5;
traCell = cell(1,tra_nb);

for i =1:tra_nb
    traCell{i} = tra(:,(i-1)*5+1:(i-1)*5+5);
end