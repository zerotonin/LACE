function [tra,correctionIndex] = ivT_IO_readLargeNoisySingleAreaTRA(fPos,correctionType1,correctionType2,varargin)
% This function reads in large noisy trajetories of a single area detected
% with ivTrace. It can cope with to many or not found areas by lineary
% interpolating trajectory coordinates or finding the area clossest to the
% last known coordinates and discarding the rest. It furthermore reads in
% the data as binary stream which is faster than the old functions based on
% the loadco function. The function is programmed so that it can be easily
% adapted to reading more than one area.
%
% GETS:
%            fPos = position of the trafile
% correctionType1 = the correctionType used to correct for too many found
%                   areas. Implemented options so far:
%                   'none' = nothing is done might crash if more than one
%                            area was found
%                   'fixedXY' = tethered flight setup the x,y coordinates
%                               do not change a lot
%   recomended ->   'lastKnown' = here the incidences with 2 many areas are
%                                 compared to the closest one with the correct
%                                 number of areas and a perfect matching
%                                 over the euclidean distances between both
%                                 frames' areas is calculated
%                   'sizeA' = size of the objects ascending
%                   'sizeD' = size of the objects descending
% correctionType2 = the correctionType used to correct for not enough found
%                   areas. Implemented options so far:
%                   'none' = nothing is done might crash if more than one
%                            area was found
%                   'delete' = all trapositions with not enough found areas
%                              are deleted WARNING take this into account
%                              when you calculate VELOCITIES
%                   'interp' = lineary interpolate between the ends of the
%                              gap. If the gap is in the beginning or end
%                              the last or first known positions is
%                              repeated.
% varargin = if you add to the end the string 'UniformOutputFalse', the
% return value will be a cell
%
% RETURNS
%            tra = mx6 matrix holding framenumber x-position in pix 
%                   y-position in pix yaw in rad size in pix and the
%                   eccentricity.
% correctionIndex = vector with the length of data 0 indicate that no
%                   correction was perormed. Ones indicate that to many 
%                   areas were corrected and -1 cases of lost areas.  
%
% SYNTAX: [tra,correctionIndex] = ivT_IO_readLargeNoisySingleAreaTRA(fPos,...
%                                         correctionType1,correctionType2);
%
% ANALYSIS TRAIN:  ivT_IO_readLargeNoisySingleAreaTRA->ivT_ananalyseMulti2DTraces->
%                  ivT_artifact2D_findSpeedArtifacts
%
% Author: B.Geurten 4.11.14
%
% see also linspaceNDim

%flag variable setting the output tra to cell array
makeMat =1;


% checking for variable input arguments
for i=1:length(varargin),
    if strcmp(varargin{i},'UniformOutputFalse')
        makeMat = 0;
    end
end

% this function can be elaborated into dealing with more than one area so
% we keep the expectedAreas variable
expectedAreas = 1;

% I/O read in data stream
fid = fopen(fPos);
tra = fread(fid);
fclose(fid);

% string 2 num
% split lines by looking for the linebreak chaacter
dataStr = strsplit(char(tra)',char(10))';
% find empty lines, these are the ones without any entry as for example a
% frame number
dataLenIndex = cellfun(@length,dataStr)< 7;
dataStr(dataLenIndex) = [];

% now change data from strings to numbers. As some images are so large that
% the x -coordinate tends to write into the frame number we seperate frame 
% numbers by taking the first 7 chars out of the sscanf command
tra = cellfun(@(x) [str2double(x(1:7)) sscanf(x(8:end),'%f')'],dataStr,'UniformOutput',false);

% now correcting for possible miss detections

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if two many areas were found %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch correctionType1,
    case 'none' % no correction used
        correctionIndex1 = zeros(size(tra,1));
    case 'fixedXY', % algorithm expects area not to move as for example in
        % a tehtered setup
        
        % check if more  than the expected areas were found
        data2manyA = cellfun(@length,tra) > 1 + 5*expectedAreas;
        % check if less than the expected areas were found
        dataNotEnoughA = cellfun(@length,tra) < 1 + 5*expectedAreas;
        
        % get by sorting x,y tethered
        % get correctFrames
        correctFrames = bsxfun(@plus,double(data2manyA),double(dataNotEnoughA)) == 0;
        % make matrix
        correctFrames = cell2mat(tra(correctFrames));
        % get median position
        medPos = median(correctFrames(:,2:3),1);
        % calculate absolute difference
        xyDifference= cellfun(@(x) sum(abs(bsxfun(@minus,[x(2:5:end)' x(3:5:end)'],medPos)),2) ,tra(data2manyA),'UniformOutput',false);
        % find the closest area to the median position
        xyClosest = cellfun(@(x) find(x == min(x)),xyDifference,'UniformOutput',false);
        % correct the data
        tra(data2manyA) = cellfun(@(x,y) [x(1) x(2+(y-1)*5:6+(y-1)*5)] ,tra(data2manyA),xyClosest,'UniformOutput',false);
        
        
        % correction Index
        correctionIndex1 =double(data2manyA);
        %     case 'moving XY'
        %         error('ivT_IO_readLargeNoisySingleAreaTRA:moving XY: NOT implemented yet')
    case 'lastKnown',
        data2manyA = cellfun(@length,tra) > 1 + 5*expectedAreas;
        
        
        if sum(data2manyA) ~=0,
            %get indices of occurences
            indexSS = SR_getSSfromLogIdx(data2manyA);
            % check if there is a first frame occurence, if so we have to
            % flip this particular part of the trajectory so that we can
            % use the first known occurence
            if indexSS(1,1) ==1 && indexSS(1,2) ~=length(tra),
                % +1 to take the next known coordinates with you and flip
                % it upside down so that known coordinates are in the
                % beginning
                tempTra= flipud(tra(indexSS(1,1):indexSS(1,2)+1));
                %now use the hungarian algorithm
                tempTra = SR_lastKnowHungarian(flipud(data2manyA(1:indexSS(1,2)+1)),tempTra);
                %return values to tra, this time skip the first one because
                %it was the next known one and is allready in tra
                tra(indexSS(1,1):indexSS(1,2)) = flipud(tempTra(2:end));
                % clear data2many
                data2manyA(indexSS(1,1):indexSS(1,2)) =0;
            elseif indexSS(1,1) ==1 && indexSS(1,2) ==length(tra),
                error(['ivT_IO_readLargeNoisySingleAreaTRA: ' fPos ' has too many areas and is unsolveable because it detects to many areas throughout the whole trajectory!'])
            end
            %now check the rest of the trajectory
            tra = SR_lastKnowHungarian(data2manyA,tra);
        end
        correctionIndex1 =double(data2manyA);
        
    case 'sizeA'
        % check if more  than the expected areas were found
        data2manyA = cellfun(@length,tra) > 1 + 5*expectedAreas;
        % sort ascending to size
        tra(data2manyA) = cellfun(@(x) SR_sortTra2Size(x,'ascend'),tra(data2manyA),'UniformOutput',false);
        if makeMat,
            % now shorten it down to the number of expected areas
            tra(data2manyA) = cellfun(@(x) x(1:1+5*expectedAreas),tra(data2manyA),'UniformOutput',false);
        end
        % correction Index
        correctionIndex1 =double(data2manyA);
        
    case 'sizeD'
        % check if more  than the expected areas were found
        data2manyA = cellfun(@length,tra) > 1 + 5*expectedAreas;
        % sort descending to size
        tra(data2manyA) = cellfun(@(x) SR_sortTra2Size(x,'descend'),tra(data2manyA),'UniformOutput',false);
        if makeMat,
            % now shorten it down to the number of expected areas
            tra(data2manyA) = cellfun(@(x) x(1:1+5*expectedAreas),tra(data2manyA),'UniformOutput',false);
        end
        % correction Index
        correctionIndex1 =double(data2manyA);
        
    otherwise
        error('ivT_IO_readLargeNoisySingleAreaTRA:correctionType 1: unknown correction type for to many areas')
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%
% correct missing areas %
%%%%%%%%%%%%%%%%%%%%%%%%%

switch correctionType2,
    case 'none' % no correction used
        correctionIndex2 = zeros(size(tra,1));
    case 'delete'
        % check if less than the expected areas were found
        dataNotEnoughA = cellfun(@length,tra) < 1 + 5*expectedAreas;
        
        % delete to small data
        tra = tra(~dataNotEnoughA);
        
        % correction Index
        correctionIndex2 = double(dataNotEnoughA).*-1;
        
    case 'interp',
        % check if less than the expected areas were found
        dataNotEnoughA = cellfun(@length,tra) < 1 + 5*expectedAreas;
        
        indexSS = SR_getSSfromLogIdx(dataNotEnoughA);
        
        % if there are empty frames in the beginning
        if ~isempty(indexSS)
            if indexSS(1,1) ==1,
                firstCompleteSet = tra{indexSS(1,2)+1}(2:end);
                tra(indexSS(1,1):indexSS(1,2)) = cellfun(@(x) [x(1) firstCompleteSet],tra(indexSS(1,1):indexSS(1,2)),'UniformOutput',false);
                indexSS(1,:) =[];
            end
            % if there are empty frames at the end. It might be possible
            % that indexSS is empty because there was only one incident in
            % the beginning. If this is corrected after the first if-loop
            % indexSS is empty and will produce an error
            if ~isempty(indexSS),
                if indexSS(end,2) == size(tra,1)
                    lastCompleteSet = tra{indexSS(end,1)-1}(2:end);
                    tra(indexSS(end,1):indexSS(end,2)) = cellfun(@(x) [x(1) lastCompleteSet],tra(indexSS(end,1):indexSS(end,2)),'UniformOutput',false);
                    indexSS(end,:) =[];
                end
            end
            
            % fill gaps in the middle
            tra = SR_interpTRA(tra,indexSS);
        end
        % correction Index
        correctionIndex2 = double(dataNotEnoughA).*-1;
        
    otherwise
        error('ivT_IO_readLargeNoisySingleAreaTRA:correctionType 1: unknown correction type for not enough areas')
        
end

% change from cell 2 mat
if makeMat
    tra = cell2mat(tra);
end
% correction Index
correctionIndex = bsxfun(@plus,correctionIndex2,correctionIndex1);

end

function tra = SR_lastKnowHungarian(data2manyA,tra)
% This function tries to find the correctareas by comparing them to a
% correctly traced frame. The areas from the wrongly traced frame (x') and
% the correct frame (x) are treated as a bipartide graph and a hungarian
% algorithmn is used to create a perfect matching between both groups.
% Thereby the artifact arenas are ignored.
%
% GETS:
%       data2many = logical index with the frames in which to many areas
%                   were found
%             tra = cell array with the ivTrace areas
%
% RETURNS:
%             tra = corrected tra
%
% SYNTAX: tra = SR_lastKnowHungarian(data2manyA,tra);
%
% Author: B.Geurten 20.5.15
%
% see also Hungarian, SR_get_dist

% get the frames that have too many areas
index = find(data2manyA);
for i =1:length(index),
    %get x,ycoordinates of the known arenas
    knownAreas =[ tra{index(i)-1}(2:5:end)' tra{index(i)-1}(3:5:end)'];
    manyAreas = tra{index(i)};
    
    % reshape the many areas
    frameNum = manyAreas(1);
    % get number of areas
    areaNum = (length(manyAreas)-1)/5;
    % reshape to matrix, because than things are easier to sort
    manyAreas = reshape(manyAreas(2:end),5,areaNum)';
    
    % get the distance matrix ...
    dist_mat = SR_get_dist(knownAreas,manyAreas(:,1:2));
    % ... and run the Hungarian.
    [MATCHING,COST] = Hungarian(dist_mat);
    
    %get the row and col indices of the matching
    [knownAidx,manyAidx]= find(MATCHING);
    %now sort after the indices of the known areas
    [~,IX] = sort(knownAidx);
    manyAidx = manyAidx(IX);
    %use that to arrange the knownareas found in the many areas
    foundAreas =manyAreas(manyAidx,:);
    % reshape back to the line vector form and ad the frame number saved in the
    % first command
    tra{index(i)} = [frameNum reshape(foundAreas,1,numel(foundAreas))];
          
end
end

function dist_mat = SR_get_dist(knownAreas,manyAreas)
% This function builts from the psoitions of the areas found and of the areas 
% we believe to be correct a distance matrix. Used for the Hungarian
% Algorithmn in the lastKnown correctionType. 
%
% Gets 
%       knownAreas = mx2 matrix with the x  and y coordinates of all
%                   correctly identified areas as a column vector
%       manyAreas = px2 matrix of column vectors. First x than y coordinate
%                   of all areas found 
%
% RETURNS 
%         distMat = a mxp matrix with euclidean distances between the areas
%                   of the real and many group
%
% SYNTAX: dist_mat = get_dist(knownAreas,manyAreas);
%
% Author: B. Geurten 20.05.15
%
%
% see also Hungarian,SR_lastKnowHungarian

dist_mat = ones(size(knownAreas,1),size(manyAreas,1));
dist_mat = dist_mat.*inf;

for k =1:size(knownAreas,1)
    for j=1:size(manyAreas,1)
        diff_C = manyAreas(j,:) -knownAreas(k,:);
        diff_C = sqrt(sum(diff_C.^2));
        dist_mat(k,j) = diff_C;
    end
end
end

function data = SR_interpTRA(data,index)
% This function closes the gaps inside a trajectory by lineary
% interpolating the coordinates,size ,orientation and frame number of the
% missing values.
%
% GETS
%
%    data = cell array with  6 value vectors inside sometimes less the gaps
%           are not at the end or beginning
% indexSS = a mx2 matrix wher col 1 holds the starts and col2 the ends of a
%           gap
%
% RETURNS
%    data = a cella rray consinsting of 6 value line vectors
%
% SYNTAX: data = SR_interpTRA(data,index);
%
% Author: B.Geurten 4.11.14
%
% see also linspaceNDim

for gapI=1:size(index,1),
    % get size of the gap
    gapSize = index(gapI,2)-index(gapI,1)+1;
    % interpolate data between the last known positions
    gapdata = linspaceNDim(data{index(gapI,1)-1},data{index(gapI,2)+1},gapSize+2)';
    % return values
    data(index(gapI,1):index(gapI,2)) = mat2cell(gapdata(2:end-1,:),ones(1,gapSize),size(gapdata,2));
end

end

function startsNstops = SR_getSSfromLogIdx(logIdx)
% This function calculates the starts and stops of the ones in a logical
% index!
%
% GETS
%    logIdx = one dimensional logical index 
%
% RETURNS
%    startsNstops = mx2 with the starts and stops of the 1 in the logIdx
%
% SYNTAX: startsNstops = getSSfromLogIdx(logIdx);
%
% Author: B.Geurten 4.11.14
%
% see also linspaceNDim

% get by sorting x,y tethered
index = double(logIdx);
% check if first incident is at the beginning
if index(1) == 1,
    starts = [1; find(diff(index) ==1)+1];
else
    starts =  find(diff(index) ==1)+1;
end
% check if last incident is at the end
if index(end) == 1,
    stops = [ find(diff(index) ==-1); length(logIdx)];
else
    stops = find(diff(index) ==-1);
end
startsNstops = [starts stops];
end


function sortPos = SR_sortTra2Size(pos,direction)
% This function sorts a trajectory entry after its size either scending or
% descending.
%
% GETS: 
%       pos = a column vetcor with frameNumber, followed by a number of
%             vetctors containing x-pos y-pos atan size eccentricity
% direction = string variable either 'ascending' or 'descending'

%
% RETURNS:
%   sortpos = sorted trajectory after size
%
% SYNTAX: sortPos = SR_sortTra2SizeA(pos,direction);
%
% Author: B. Geurten 13.11.14
%
% see also sort, reshape

% save for later use
frameNum = pos(1);
% get number of areas
areaNum = (length(pos)-1)/5;
% reshape to matrix, because than things are easier to sort
pos = reshape(pos(2:end)',5,areaNum);
% get the sorting index
[~,index] = sort(pos(4,:),direction);
% use sorting index on matrix, which is easier than working on a line vector 
pos= pos(:,index);
% reshape back to the line vector form and ad the frame number saved in the
% first command
sortPos = [frameNum reshape(pos,1,numel(pos))];


end