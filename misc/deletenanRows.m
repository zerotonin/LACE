function  matrix=deletenanRows(matrix)
% This function deletes all rows in a Matrix that hold an NaN value.
%
% GETS:
%       matrix = a mxn matrix
%
% RETURNS
%       matrix = the same matrix as before, but all m that hold a NaN value
%                are deleted
%
% SYNTAX: matrix=deletenan(matrix);
%
%Author B.Geurten 28.07.09
%
% see also nanmean, nanstd, nanmedian

matrix(isnan(sum(matrix,2)),:) = [];
