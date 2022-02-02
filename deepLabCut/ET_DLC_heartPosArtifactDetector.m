function tra = ET_DLC_heartPosArtifactDetector(tra,pixThresh)

[frames,~,regions] = size(tra);

medTra = median(tra(:,1:2,:));
diffTra = bsxfun(@minus,tra(:,1:2,:),medTra);
artIDX  = sum(abs(diffTra),2)  > pixThresh;

for regionI = 1:regions
    %find all frames with noise larger than threshold
    rows = find(artIDX(:,regionI)==1);
    %find the beginning and end of the noise
    [start,stop] = getSeqStartsEnds(rows,1);
    if ~isempty(start) && ~isempty(rows)
        % the last frame is an artefact,
        if rows(stop(end)) == frames
            lastProperFrame = rows(start(end))-1;
            tra(rows(start(end)):end,:,regionI) = repmat([tra(lastProperFrame,1:2,regionI) -1],frames-lastProperFrame,1);
            start(end)=[];
            stop(end) = [];
        end
        
        if ~isempty(start) && ~isempty(rows)
            % the first frame is an artefact,
            if rows(start(1)) == 1
                firstProperFrame = rows(stop(1))+1;
                tra(1:rows(stop(1)),:,regionI) = repmat([tra(firstProperFrame,1:2,regionI) -1],rows(stop(1)),1);
                start(1)=[];
                stop(1) = [];
            end
            
            if ~isempty(start) && ~isempty(rows)
                for artiI = 1:length(start)
                    
                    lastProperFrame  = rows(start(artiI))-1;
                    nextProperFrame = rows(stop(artiI)) +1;
                    steps = nextProperFrame - lastProperFrame +1;
                    try
                    interpolantTra = [ linspace(tra(lastProperFrame,1,regionI),tra(nextProperFrame,1,regionI),steps)' ...
                        linspace(tra(lastProperFrame,2,regionI),tra(nextProperFrame,2,regionI),steps)' ones(steps,1).*-1];
                    tra(lastProperFrame:nextProperFrame,:,regionI) = interpolantTra;
                    catch
                        disp('nope')
                    end
                end
            end
        end
    end
end
