function out = load2var(in)
% This function loads mat files into one designated variable. Note if the
% mat file holds more then one variable only the first will be loaded. 
%
% GETS
%       in = string with file position
% RETURNS
%      out = variable 
%
% SYNTAX out = load2var(in);
%
% Author: B. Geurten 270709
%
% see also load

% load to struct
var_struct = load(in);

%get filenames
f_names = fieldnames(var_struct);
if length(f_names)>1,
    warning(['The mat file: ' in ' holds more then one variable, only the first was loaded']);
end

%set variable to output variable
out = var_struct.(f_names{1});