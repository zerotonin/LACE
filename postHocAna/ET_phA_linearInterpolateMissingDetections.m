 function [traceResult,stillMissing,headP,tailP,contour,spline] = ...
           ET_phA_linearInterpolateMissingDetections(traceResult,tooFew,...
                    expectedAnimals,axisH,fps,headP,tailP,contour,spline)
% This function of the Ethotrack posthoc analysis toolbox (ET_phA_)
% interpolates linearly sequences of the movie in which an animal was
% missing. The user has to aprove the interpolation.
%
% GETS:
%   traceResult = a mx13 result where m is the number of found animals,
%                 columns are defined as follows:
%                 col  1: x-position in pixel
%                 col  2: y-position in pixel
%                 col  3: major axis length of the fitted ellipse
%                 col  4: minor axis length of the fitted ellipse
%                 col  5: ellipse angle in degree
%                 col  6: quality of the fit
%                 col  7: number of animals believed in their after final
%                         evaluation
%                 col  8: number of animals in the ellipse according to
%                         surface area
%                 col  9: number of animals in the ellipse according to
%                         contour length
%                 col 10: is the animal close to an animal previously traced 
%                         (1 == yes)
%                 col 11: evaluation weighted mean
%                 col 12: detection quality [aU] if
%                 col 13: correction index, 1 if the area had to be
%                         corrected automatically
%        tooFew = indices of the frames in which too few animals where
%                 found
%expectedAnimals= number of animals that should be visible in the footage
%         axisH = handle of the axis object
%           fps = scalar frames per second
%        headP  = head Position, optional (2D pixel coordinates for the head)
%        tailP  = tail Position, optional (2D pixel coordinates for the tail)
%       contour =
%       spline  =
%
%
% RETURNS:
%   traceResult = same as above only corrected
%  stillMissing = starts and ends of still missing animals
%
% SYNTAX:  [traceResult,stillMissing] = ...
% ET_phA_linearInterpolateMissingDetections(traceResult,tooFew,expectedAnimals,axisH,fps);
%
%
% Author: B.Geurten 11-30-2015
%
% Notes:
%
% see also ET_phA_removeAnimalManually, ET_phA_fdfByAnimalNumber

if exist('headP','var'),
    if ~isempty(headP),
        headCorrFlag = 1;
    else
        headCorrFlag = 0;
        headP = [];
    end
else
    headCorrFlag = 0;
    headP = [];
end

if exist('tailP','var'),
    if ~isempty(tailP),
        tailCorrFlag = 1;
        
    else
        tailCorrFlag = 0;
        tailP = [];
    end
else
    tailCorrFlag = 0;
    tailP = [];
end

if exist('contour','var'),
    if ~isempty(contour),
        conCorrFlag = 1;
        
    else
        conCorrFlag = 0;
        contour = [];
    end
else
    conCorrFlag = 0;
    contour = [];
end

if exist('spline','var'),
    if ~isempty(spline),
        spCorrFlag = 1;
        
    else
        spCorrFlag = 0;
        spline = [];
    end
else
    spCorrFlag = 0;
    spline = [];
end


% get the beginning and ends of  the missing sequences
[start,stop]=getSeqStartsEnds(tooFew,1);

if ~isempty(stop),
    
    % if an animal in the first frame is missed ...
    if tooFew(start(1)) == 1,
        stillMissing = [1 tooFew(stop(1))];
        start(1) =[];
        stop(1) = [];
    else
        stillMissing= [];
    end
    % ... or in the  last it cannot be interpolated
    if tooFew(stop(end)) == length(traceResult),
        stillMissing= [stillMissing; tooFew(start(end)) tooFew(stop(end))];
        start(end) =[];
        stop(end) = [];
    end
    
    % change the starts and stops of the missing sequence to the last correct
    % detection and the next correction after the false sequence
    lastDet = tooFew(start)-1;
    nextDet = tooFew(stop)+1;
    
    % iterate through all sequence of missing animals
    for i =1:length(start),
        % get the coordinates of the animal tracking before and after and in
        % the middle to determine which animals need to be interpolated
        coord1 = traceResult{lastDet(i)}(:,1:2);
        coordTF = traceResult{round(mean([lastDet(i) nextDet(i)]))}(:,1:2);
        coord2 = traceResult{nextDet(i)}(:,1:2);
        
        % find the missing animals via matching
        if isempty(coordTF),
            missingAnimals = 1:expectedAnimals;
        else
            distMat=Hungarian_getDistMat(coord1,coordTF,'euclidean');
            match = lapjv(distMat');
            missingAnimals = setdiff(1:expectedAnimals,match);
        end
        %number of frames to be interpolated
        interpSteps = nextDet(i)-lastDet(i)-1;
        %now iterate through all missing animals in this sequence
        for j = 1:length(missingAnimals)
            % correct tracing
            corrTrace =correctTraceResult(traceResult,lastDet(i),nextDet(i),missingAnimals(j),interpSteps);
            if headCorrFlag == 1,
                corrHP =correctTraceResult(headP,lastDet(i),nextDet(i),missingAnimals(j),interpSteps);
            end
            if tailCorrFlag == 1,
                corrTP =correctTraceResult(tailP,lastDet(i),nextDet(i),missingAnimals(j),interpSteps);
            end
            if conCorrFlag == 1,
                corrCon = correctImageStructureVal(contour,interpSteps,lastDet(i),nextDet(i)); %mat2cell(NaN(interpSteps,2),ones(interpSteps,1),2);
            end
            if spCorrFlag == 1,
                corrSp = correctImageStructureVal(spline,interpSteps,lastDet(i),nextDet(i)); %mat2cell(NaN(interpSteps,2),ones(interpSteps,1),2);
            end
        end
        % sort animals by their position
        corrTrace = ET_phA_sortTraceByPos(corrTrace );
        
        %convey to matrix for plotting
        corrTraceM = ET_phA_cell2mat(corrTrace);
        corrTraceM(:,3,:)= deg2rad( corrTraceM(:,3,:));
        cla(axisH)
        ET_plot_lollipopTrace(corrTraceM,fps,interpSteps+2,3,1,20,axisH)
        
        %ask user if the interpolation is correct and either save data or
        %increase still missing
        userAns = questdlg('Does the trace look natural','Correct?','Yes','No','Yes');
        if strcmp(userAns,'Yes')
            traceResult(lastDet(i)+1:nextDet(i)-1) = corrTrace(2:end-1);
            if headCorrFlag == 1,
                headP(lastDet(i)+1:nextDet(i)-1)   = corrHP(2:end-1);
            end
            if tailCorrFlag == 1,
                tailP(lastDet(i)+1:nextDet(i)-1)   = corrTP(2:end-1);
            end
            if conCorrFlag == 1,
                contour(lastDet(i)+1:nextDet(i)-1) = corrCon(2:end-1);
            end
            if spCorrFlag == 1,
                spline(lastDet(i)+1:nextDet(i)-1)  = corrSp(2:end-1);
            end
        else
            stillMissing = [stillMissing; lastDet(i)+1 nextDet(i)-1];
        end
    end
end
end
 
 function  corrTrace = correctTraceResult(traceResult,lastDet,nextDet,missingAnimals,interpSteps)
 % before we interpolate we make sure that both (the last known and the next detection)
 % are sorted the same way, otherwise we might interpolated to the
 % wrong animal
 traceResult([lastDet nextDet ]) = ET_phA_sortTraceByPos(traceResult([lastDet nextDet ]));

 %now we interpolaTe
 lastCoords = traceResult{lastDet}(missingAnimals,:);
 nextCoords = traceResult{nextDet}(missingAnimals,:);
 interpTrace = linspaceNDim(lastCoords',nextCoords',interpSteps+2 )';
 % make a cell of the matrix
 interpTrace = mat2cell(interpTrace,ones(interpSteps+2,1),size(interpTrace,2));
 % add interpolated traces
 if missingAnimals ==1,
     corrTrace = interpTrace;
 else
     corrTrace = cellfun(@(x,y) [x;y],traceResult(lastDet+1:nextDet-1),interpTrace(2:end-1),'UniformOutput',false);
     corrTrace = [traceResult(lastDet);corrTrace;traceResult(nextDet)];
 end
 end

 function corrTrace = correctImageStructureVal(data,interpSteps,lastDet,nextDet),
 if interpSteps == 1,
     corrTrace = [data(lastDet); data(lastDet);data(nextDet)];
 elseif mod(interpSteps,2) == 1,
     halfSteps = (interpSteps-1)/2;
     corrTrace = [data(lastDet); repmat(data(lastDet),halfSteps,1);repmat(data(nextDet),halfSteps+1,1);data(nextDet)];
     
 else
     halfSteps = (interpSteps)/2;
     corrTrace = [data(lastDet); repmat(data(lastDet),halfSteps,1);repmat(data(nextDet),halfSteps,1);data(nextDet)];
 end
 end
 
 