function result = ste(values,flag,dim)
% For vectors, Y = STE(X) returns the standard error.  For matrices,
% Y is a row vector containing the standard deviation of each column.  For
% N-D arrays, STE operates along the first non-singleton dimension of X.
%  
% As this implementation uses std you need to use std syntax:
%   Y = STD(X,FLAG,DIM) takes the standard deviation along the dimension
%   DIM of X.  Pass in FLAG==0 to use the default normalization by N-1, or
%   1 to use N.
%  
% Author: B.Geurten    
std_values = std(values,flag,dim);
N = size(values,dim);
result = std_values./sqrt(N);
