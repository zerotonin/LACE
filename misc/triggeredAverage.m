function trigAve = triggeredAverage(data,trigInd,winSize,indices,set2zero)
% This function is an all purpose triggered average function. Most often it
% is used in behavioural or movie data. In behavioural data the frame
% indices are used similar to the grouped data paradigm in boxplot. Jumps
% in the framenumbers are used to detect the start and end of the movie.
% This is afterwards used to see if the averaging window is inside or
% outside  a movie. Furthermore the data in dat is averaged over the
% triggere events in sad window size. The median and confidence-interval
% are used for the averageing.
%
% GETS:
%       data = mxn matrix containing the data where m is the number of
%              samples and n are the different features. E.g. One could
%              record a neuronal response for 5 seconds with 10kHz and
%              record the temperature as well. Then this would be a 50000x2
%              matrix. In col(1) is the neuronal response in column(2) the
%              temperature
%    trigInd = indices of the trigger events on m
%    winSize = half window size for averageing. If e.g. the winSize is set
%              to 50 then a 101 window will be used. This window is 50 
%              samples long in each direction
%    indices = if for example these are movies then the indices reflect the
%              running number of frames. Eg.: [1:1000 20:45 400:500] will 
%              be detected as 3 internal indice groups if now an averaging
%              window overlays with two of those groups it is omitted if
%              the variable is set to [] the whole checks 
%   set2zero = this flag variable is used to determine wether the first
%              value of every trigger occurence should be set to zero and
%              the following values will be treated relative to zero.
%              Meaning that you substract the first value of each occurence
%              from the whole occurence.
%
% RETURNS: 
%    trigAve = n x win*2+1 x 2 matrix containing the averaged data. Note 
%              that now the orientation of the data is transponded. The
%              order in the third dimension is mean and ste!
%
% SYNTAX: trigAve = triggeredAverage(data,trigInd,winSize,indices);
%
% Author: B. Geurten 22.04.13
%
% see also get_trajectoryStartsAndEnds, deletenan, confintND

%get size of the data
[dataLen,numFeatures] = size(data);
% number of triggers
numInd = length(trigInd);
%preAllocation of returnValue
trigAve = NaN(numFeatures,2*winSize+1,2);

% check if internal indices are used
if isempty(indices), % if not that flag variable to zero
    isInternalInd = 0;
else % if they are used
    isInternalInd = 1; % go internals
    internalInd = get_trajectoryStartsAndEnds(indices); % calculate the internal indices
end

for j =1:numFeatures,
    % pre allocate  temporary datamatrix for feature
    temp = NaN(numInd,2*winSize+1);
    
    % go through all occurences of the index
    for i =1:numInd,
        % define start and stop of average window
        start = trigInd(i)-winSize;
        stop = trigInd(i)+winSize;
        % check if the window is inside the data matrix
        if start > 0 & stop <= dataLen,
            %check if internal indices are used
            if isInternalInd,
                % if they are used find the movie in which they are used as
                % the indices have begining  and end in one line of the
                % matrix internalInd. The start and stop variable should be
                % inside those values and therefore in the same line
                seqStart = find(start>=internalInd(:,1) & start <= internalInd(:,2));
                seqStop  = find(stop >=internalInd(:,1) & stop  <= internalInd(:,2));
                % if this is not the case ommit this value and write out  a
                % warning but only for the first feature
                if seqStart ~= seqStop && j == 1,
                    
                    warning(['triggeredAverage.m: The average window of the ' num2str(i) 'th trigger crosses two internal indices and was ommitted!'])
                
                elseif seqStart == seqStop
                    % global and internal indices are good write data to
                    % temp matrix
                    temp(i,:) =data(trigInd(i)-winSize:trigInd(i)+winSize,j)';
                end
                    
            else
                % global indices are OK and we do not care for internal
                temp(i,:) =data(trigInd(i)-winSize:trigInd(i)+winSize,j)';
            end
        end
    end
    % if data was ommitted than the rows will be deleted
    temp = deletenanRows(temp);
    % check if the first value of every occurence should be set to zero
    if set2zero>1,
       temp = bsxfun(@minus,temp,mean(temp(:,1:set2zero),2));
    end
    % write the  median and confidence intervals
    trigAve(j,:,1) = mean(temp,1);
    trigAve(j,:,2) = ste(temp,[],1);
end
