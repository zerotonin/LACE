function n=round2digit(n,digit)
% This function rounds a number to a certain digit after the point.
%
% GETS     n = numbers
%      digit = digit precision
%
% SYNTAX: n=round2digit(n,digit)
%
% Author: B.Geurten

n=n.*10^digit;
n= round(n);
n=n./10^digit;