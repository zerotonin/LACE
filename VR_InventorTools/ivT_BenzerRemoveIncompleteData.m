function data = ivT_BenzerRemoveIncompleteData(data,empties)

%make matrix out of empty slots
emptyMat =  cell2mat(empties);
% find all those slots that became empty once during the repetitions
delMe = sum(emptyMat) >0;
% get the row numbers of those
candidates =find(delMe);
% make a matrix of those you would want to delete because they were
% empty at other times
delMat = emptyMat;
delMat(:,candidates) = ~delMat(:,candidates);
% now copy everything back to cells
emptyCell = mat2cell(emptyMat,ones(size(emptyMat,1),1),size(emptyMat,2));
delCell = mat2cell(delMat,ones(size(emptyMat,1),1),size(emptyMat,2));
% now the real magic starts @futureBart keep your fingers off the code is correct
% as a slot might not be used in the beginning but latter the delete
% matrix has to be shifted to account for the lesser number of rows
% therefore we use this command:
delCell = cellfun(@(x,y) x(~y),delCell,emptyCell,'UniformOutput',false  );
% now use the correct deletion matrix to delete the rest
data = cellfun(@(x,y) x(~y,:),data,delCell,'UniformOutput',false  );