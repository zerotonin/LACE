function trace=ivT_Benzer_interpNaN(trace)

%find nan values
[~,c,s] = ind2sub(size(trace),find(isnan(trace)));
% get the unique combinations of column and slices
artifacts = unique([c,s],'rows');
% iterate through all nan columns
for i=1:size(artifacts,1)
    % get the artifact column
    artiColumn = trace(:,artifacts(i,1),artifacts(i,2));
    % find the starts and ends of artifact phases
    [starts,stops] = getSigStartsEnds(isnan(artiColumn));
    % iterate through each artifact
    for artiI = 1:length(starts)
        % if it is at the start, repeat first non NaN value
        if starts(artiI)==1,
            artiColumn(starts(artiI):stops(artiI)) = artiColumn(stops(artiI)+1);
        % if it is at the end, repeat last non NaN value
        elseif stops(end)==length(artiColumn),
            artiColumn(starts(artiI):stops(artiI)) = artiColumn(starts(artiI)-1);
        % if it is somewher in the middle, interpolate between the last and
        % the next non NaN value
        else
            artiColumn(starts(artiI)-1:stops(artiI)+1) =linspace(artiColumn(starts(artiI)-1),artiColumn(stops(artiI)+1), stops(artiI)-starts(artiI)+3);
        end
    end
    % write the corrected column back
    trace(:,artifacts(i,1),artifacts(i,2)) = artiColumn;
end
