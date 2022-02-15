function reString = num2strleadingZero(number,leadZero)
% This function is a shortcut to convert numbers into strings and takes one
% other variables defining the number of leading zeros. For more opions 
% (e.g. scientific notation) see num2str.
%
% GETS
%       number = the number you want to convert (float)
%     leadZero = number of leading zeros (cardinal)
%
% RETURNS
%     reString = string with converted number
%
% SYNTAX: reString = num2strleadingZero(number,leadZero);
%
% Author: B.Geurten 19.08.10
%
% see also num2str,fprintf,


%built fprintf converson string see doc fprintf for help
fstring = ['%0' num2str(round(leadZero)) '.0f'];
%convert to string
reString=num2str(number,fstring);