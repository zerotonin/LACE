function [trace , artifacts] = ivT_readFile(filename,expAreaNo,varargin)
% This function is a newer version of loadco. It reads the 2D trace file
% completely and returns the complete trace. When it does not find the
% expected number of areas traced in the file it writes out NaN values in
% the line of the trace. If only one area was expected and more are found
% there is a small auto correction function available which chooses the
% area with the smallest euclidean distance from the area before.
%
% GETS:


autoCorrect = 0;

% check vor variable input arguments
for i =1:length(varargin),
    if strcmp(varargin{i},'autoCorrect'),
        if expAreaNo ~=1,
            error('ivT_readFile:autoCorrect','autoCorrect is only allowed for 1 expected area')
        else
            autoCorrect =1;
        end
    end
end


% open file communication
fid = fopen(filename ,'rb');
%# Get file size.
fseek(fid, 0, 'eof'); % go to end of file
fileSize = ftell(fid); % get file size
frewind(fid);
%# Read the whole file.
data = fread(fid, fileSize, 'uint8');
fclose(fid);

% find start and end of lines
lineBreaks = find(data == 10);
lineStarts = [1; lineBreaks(1:end-1)+1];


% make lines and built them from asccii- character
trace=arrayfun(@(y,z) data(y:z)',lineStarts,lineBreaks,'UniformOutput',false); % chop into lines
trace= cellfun(@char,trace,'UniformOutput',false); % ascii 2 char
trace= cellfun(@(x) sscanf(x,'%f')',trace,'UniformOutput',false); % char 2 number

% check for more/less than appropreate number of entries
elements = cellfun(@length,trace);
artifacts = find(elements ~= expAreaNo*5 + 1);

%auto correct data
if autoCorrect == 1 && expAreaNo == 1 && ~isempty(artifacts), % if only one area ius expected and auto Correction is chosen auto correct
    
    % check if empty lines are in front of the real trace
    if elements(1) ==1,
        fullLinesFromStart = find(elements~=1);
        trace(1:fullLinesFromStart(1)-1) = [];
        elements(1:fullLinesFromStart(1)-1) = [];
    end
    % check if empty lines are in behind of the real trace
    if elements(end) ==1,
        fullLinesFromEnd = find(elements~=1);
        trace(fullLinesFromEnd(end)+1:ebd) = [];
        elements(fullLinesFromEnd(end)+1:ebd) = [];
    end
    %update artifact list
    artifacts = find(elements ~= expAreaNo*6);
    
    if ~isempty(artifacts),
    trace = ivT_readFile_SR_autoCorrect(artifacts,trace,elements);
    end
        
    
else % do not auto correct
    trace(artifacts) = repmat({NaN(1,expAreaNo*5+1)},length(artifacts),1);
end

trace =cell2mat(trace);

end




function  lines = ivT_readFile_SR_autoCorrect(artifacts,lines,elements,filename)
if ~isempty(artifacts), % check if artifact correction is needed
    if artifacts(1) == 1, % if there is an artifact in first line abort
        warning(['ivT_readFile:autoCorrection: Auto Correction impossible n1st frame contains error in trajectory ' filename]);
        trace(artifacts) = repmat({NaN(1,expAreaNo*5+1)},length(artifacts),1);
    else % commence correcting
        for i =1:length(artifacts),
            
            err = artifacts(i);
            if elements(err) > 1,% if the artifact is that more than one area was found
                
                cor = err-1;
                xcor = lines{cor}(2);
                ycor = lines{cor}(3);
                areaNo = (elements(err)-1)/5;
                xVals = abs(lines{err}(2:5:areaNo*5+1)-xcor);
                yVals = abs(lines{err}(3:5:areaNo*5+1)-ycor);
                errSum = bsxfun(@plus,xVals,yVals);
                [~,ind] =min(errSum);
                lines{err} = [lines{err}(1) lines{err}(((ind-1)*5)+2:(ind*5)+1)];
            else % if the artifact is that no areas were found write NaNs
                lines{err} = NaN(1,6);
            end
        end
    end
end
end


