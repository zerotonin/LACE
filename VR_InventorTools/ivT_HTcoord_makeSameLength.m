function [head,thorax] = ivT_HBcoord_makeSameLength(head,thorax,indices)
% This function is part of the head-body-coordination - sub-toolbox. This
% toolbox was written to analyse 3D manual thorax and head
% trajectories. The basic idea is that the head and thorax where traced in
% the  same movie and now we can calculate the differeneces in orientation.
%
% This function makes the thorax and head trajectory the same lengths.
% Thereby the longer trajectory is shortend to consist only of the indices
% that are also part in the shorter trajectory. Furthermore there is the
% option to use allready predefined indices, as can be found for many
% animals in the info  text files.
% 
% GETS:
%         head = head trajectory as is returned by ivT_IO_3DmanTrace
%       thorax = thorax trajectory as is returned by ivT_IO_3DmanTrace
%      indices = frame indices of the interessting part of the trajectory
%                (ivTrace frames!)
%
% RETURNS:
%         head = head trajectory reduced to the frames analysed in both
%                trajectories
%       thorax = thorax trajectory reduced to the frames analysed in both
%                trajectories
%
% SYNTAX:[head,thorax] = ivT_HBcoord_makeSameLength(head,thorax,indices);
%
% Author: B.Geurten
%
% see also strfind, ivT_IO_3DmanTrace

% flag to determine mode
autoFindFlag = 0;

% check if there is a correct indices variable
if exists('indices','var'),
    if ismatrix(indices)
        % if there is a correct indices variable, we set the trajectories
        % to this value
        hindices = [find(head(:,1) == indices(1)), find(head(:,1) == indices(2)) ];
        head = head(hindices(1):hindices(2),:);
        tindices = [find(thorax(:,1) == indices(1)), find(thorax(:,1) == indices(2)) ];
        thorax = thorax(tindices(1):tindices(2),:);
    else
        %otherwise we use the automode
        autoFindFlag = 1;
        warning('ivT_HBcoord_makeSameLength:Using auto mode to find the optimal length for head and thorax trajectories!')
    end
else
    %otherwise we use the automode
    autoFindFlag = 1;
    warning('ivT_HBcoord_makeSameLength:Using auto mode to find the optimal length for head and thorax trajectories!')
end

% auto-mode

if autoFindFlag,
    if length(thorax) >=  length(head);
        indice = strfind(thorax(:,1)',head(:,1)');
        thorax = thorax(indice:length(head)+indice-1,:);
    else
        indice = strfind(head(:,1)',thorax(:,1)');
        head = head(indice:length(thorax)+indice-1,:);
    end

end