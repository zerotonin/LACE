function indices = ivT_artifact2D_List(fList,multiplicator,filePos)
% This function searches for artifacts in 2D trajectory files of ivTrace.
% The basic mechanism is to look for pixel differences that are higher than
% the standarddeviation of the trajectory times a user defined factor. The
% function expects a number of trajectories and uses the std of all
% trajectories as threshold. It returns the files with likely candidates
% for artifacts and the frame indices of the artifact. Also it writes
%
% GETS:
%            fList = cell array with the trajectory-files positions 
%   mutltiplicator = float which multiplicates the threshold to user define
%                    the used threshold.  threshold = std(data)*
%                    threshold = std(data)*multiplicator
%          filePos = string containing the fileposition of the output text
%                    file, if set to be an empty string no file will be
%                    produced
%
% RETURNS:
%          indices = a mx2 cell array where col(1) holds the trajectory
%                    file name and column 2 holds the corresponding row
%                    vector with the candidate indices
%
% SYNTAX: indices = ivT_artifact2D_List(fList,multiplicator,filePos);
%
% Author: B. Geurten 5.6.13
%
% see also cellfun, ivT_IO_readIVfullTrace

% loading data
traceAll = cell(length(fList),1);
traceNo = length(fList);

h = waitbar(0,[' trace 1 of ' num2str(traceNo)],'Name','Loading traces',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)


for i=1:traceNo,
    if getappdata(h,'canceling')
        break
    end
    [trace , ~] = ivT_readFile(fList{i},1,'autoCorrect');
    traceAll{i} = trace;
    %traceAll{i} = ivT_IO_readIVfullTrace(fList{i});
    waitbar(i/traceNo,h,sprintf('trace %i of %i',i,traceNo))
    
end
delete(h)

% finding the threshold
speeds = cell2mat(traceAll);
speeds = sum(abs(diff(speeds(:,1:2),1)),2);
threshhold = std(speeds);

% comp
speeds = cellfun(@(x) sum(abs(diff(x(:,1:2),1)),2),traceAll, 'UniformOutput', false);
indices = cellfun(@(x) find(x> multiplicator*threshhold),speeds, 'UniformOutput', false);


if length(filePos) >0,
    fid = fopen(filePos,'w');
    for i =1:length(fList),
        if ~isempty(indices{i})
            fprintf(fid,'%s \n',fList{i});
            fprintf(fid,'%s \n',repmat('=',1,length(fList{i})));
            fprintf(fid,'%i \n',indices{i});
        end
    end
    fclose(fid);
end
    
indices= [fList indices];