function [seq_start seq_end] = getSeqStartsEnds(index, cutOff)
% sometimes often in trajectories or clustering results. Many trajectories
% or sequences for that matter are concatenated after another. To find the
% beginning and end of such a sequence of sequences the frame IDs are saved
% to an IDX file wich looks like this 
% IDX = [1 2 3 4 5 6 7 8 9 10 0 1 2 3 4 5 6 7 8 9 10 1 ...];
%        |                  | |                    | |
%        S                  E S                    E S                 
%
% This function finds the individual starts and ends of the sewuences and
% returns their indice on the IDX variable.
%
% GETS
%       index  = the frame indices 
%       cutOff = the difference between the last frame of the old and the
%                first frame of the next movie 100 should normally surfice
%
% RETURNS
%    seq_start = indices of starts of the individual sequences
%    seq_end   = indices of ends of the individual sequences
%
% SYNTAX: [seq_start seq_end] = getSeqStartsEnds(index, cutOff);
%
% Author B. Geurten 270709
%
% see also diff, getSigStartsEnds


%get index difference
ind_diff   = diff(index);
%every shift bigger then the cut off should be a new sequence
seq_changes = find(abs(ind_diff) > cutOff);

%derive starts and ends from changes
seq_start  = [1; seq_changes + 1];
seq_end    = [seq_changes; length(index)];