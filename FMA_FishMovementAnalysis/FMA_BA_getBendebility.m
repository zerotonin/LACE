function bendability = FMA_BA_getBendebility(traceResult,pix2mm)

bendability =cellfun(@(centralLines) cellfun(@(x) ...
    FMA_BA_getBendebilitySR(x,pix2mm),centralLines,'UniformOutput',false),...
    traceResult,'UniformOutput',false);
bendability = [bendability{:}]';
end

function bendability = FMA_BA_getBendebilitySR(cL,pix2mm)


%get vertice positions
v1 = cL(1:end-2,:);
v2 = cL(2:end-1,:);
v3 = cL(3:end,:);

%make vectors
v12 = bsxfun(@minus,v1,v2);
v32 = bsxfun(@minus,v3,v2);

% calulate norm of vectors
normv12 = arrayfun(@(idx) norm(v12(idx,:)), 1:size(v12,1))';
normv32 = arrayfun(@(idx) norm(v32(idx,:)), 1:size(v32,1))';

% normalise vectors
u12 = bsxfun(@rdivide,v12,normv12);
u32 = bsxfun(@rdivide,v32,normv32);

% calulate angles
angles = arrayfun(@(idx) acos(dot(u12(idx,:),u32(idx,:))), 1:size(u12,1))';

% return variable , 
% distance along the fish is the cumulative sum of norms of the vector
% angles are transformed from radians to degrees
bendability = [cumsum(normv12)./pix2mm rad2deg(angles)];

end