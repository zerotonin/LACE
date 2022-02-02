function tra = ET_phA_interpolate2DMisDetections(tra,start,stop)

frames = size(tra,1);
if ~isempty(start) 
    % the last frame is an artefact,
    if stop(end) == frames
        lastProperFrame = start(end)-1;
        tra(start(end):end,:) = repmat([tra(lastProperFrame,1:2) -1],frames-lastProperFrame,1);
        start(end)=[];
        stop(end) = [];
    end
    
    if ~isempty(start)
        % the first frame is an artefact,
        if start(1) == 1
            firstProperFrame = stop(1)+1;
            tra(1:stop(1),:) = repmat([tra(firstProperFrame,1:2) -1],stop(1),1);
            start(1)=[];
            stop(1) = [];
        end
        
        if ~isempty(start) 
            for artiI = 1:length(start)
                
                lastProperFrame  = start(artiI)-1;
                nextProperFrame = stop(artiI) +1;
                steps = nextProperFrame - lastProperFrame +1;
                try
                    interpolantTra = [ linspace(tra(lastProperFrame,1),tra(nextProperFrame,1),steps)' ...
                        linspace(tra(lastProperFrame,2),tra(nextProperFrame,2),steps)' ones(steps,1).*-1];
                    tra(lastProperFrame:nextProperFrame,:) = interpolantTra;
                catch
                    disp('nope')
                end
            end
        end
    end
end