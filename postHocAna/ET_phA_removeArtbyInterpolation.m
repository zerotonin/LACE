% find artifacts
trace = traceSave;
threshMode = 'default'
fps = 50;




%get pixel speeds
xSpeed = diff(trace(:,1,:),1).*fps;
ySpeed = diff(trace(:,2,:),1).*fps;
% define threshholds as 10 times the standard deviation
switch threshMode
    case 'default'
        % 50 mm /sec 20mm/sec is the literature max speed
        xThresh = repmat(50,[size(xSpeed,1),1,size(xSpeed,3)]);
        yThresh = repmat(50,[size(ySpeed,1),1,size(xSpeed,3)]);
    case 'stDev10'
        % 10 times the standard deviation       
        xThresh = repmat(std(xSpeed,[],1).*10,[size(xSpeed,1),1,1]);
        yThresh = repmat(std(ySpeed,[],1).*10,[size(ySpeed,1),1,1]);
    case 'uDefine'
        xThresh = repmat(varargin{1},[size(xSpeed,1),1,size(xSpeed,3)]);
        yThresh = repmat(varargin{1},[size(ySpeed,1),1,size(xSpeed,3)]);
end
        % 10 times the standard deviation       
% make index of times the animal is faster than the threshold
xArtIDX =[xSpeed>xThresh xSpeed<xThresh.*-1 ];
yArtIDX =[ySpeed>yThresh ySpeed<yThresh.*-1 ];
% sum it up and make an index again
artIDX = bsxfun(@plus,xArtIDX,yArtIDX) ~= 0;
% find the occasions
[frame,~,animal] = ind2sub(size(artIDX),find(artIDX))

% A typical 'one off' artifact is the appearence of an reflection.
% A new 'object' is created and therefore a real animal is thrown out. This
% should usually apear as one single jump. Hence the fast movement is forth
% and back in the same object.

% As both times the same object is found odiff objects should be zero at
% this phase
unqAn = unique(animal)
    interpolationIDX = zeros(size(trace,1),size(trace,3));
for animalI =1:length(unqAn),
    frameTemp = unique(frame(animal == unqAn(animalI)));
    
    [start,stop]=getSeqStartsEnds(frameTemp,1);
    
    last = frame(start) -1;
    next = frame(stop) +1;
    traLen = size(trace,1);
    
    for i =1:length(last),
        canbeRepaired =0;
        if last(i) < 1 && next(i) == 2,
            % only first frame is hit copy second on first
            %disp('first frame off')
            trace(1,:,animal(start(i)))=trace(2,:,animal(start(i)));
            interpolationIDX(1,animal(start(i))) =1;
        elseif last(i) < 1 && next(i) ~=2,
            disp('no repair routine')
        else
            canbeRepaired =1;
        end
        if next(i) > traLen && last(i) == traLen-1,
            disp('last off')
            trace(end,:,animal(start(i)))=trace(end-1,:,animal(start(i)));
            interpolationIDX(end,animal(start(i))) =1;
        elseif next(i) > traLen && last(i) ~= traLen-1,
            disp('no repair routine')
        else
            canbeRepaired =1;
        end
        if canbeRepaired ==1 && next(i) <= traLen && last(i) >= 1,
            disp([num2str(i) ' let''s do this'])
            interpSteps = next(i)-last(i)+1;
            trace(last(i):next(i),:,animal(start(i))) = linspaceNDim(trace(last(i),:,animal(start(i)))',trace(next(i),:,animal(start(i)))',interpSteps)';
            interpolationIDX(last(i):next(i),:,animal(start(i))) =1;
        end
    end
end

% interpTrace = linspaceNDim(traceResult{lastDet(i)}(missingAnimals(j),:),traceResult{nextDet(i)}(missingAnimals(j),:),interpSteps )';
% unique(objects)
          