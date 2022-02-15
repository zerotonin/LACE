function dataC =FILA_ana_turnHead2right(dataC)
% The convention in the FILA toolbox is that the larva is so arranged that
% the head is on the right side.  This function looks at the hcTposition
% and checks if the first row (head row) has the largest x-coordinate, if
% not the larvae is orientated to the left and the data matrixes are
% flipped accordingly.
%
% GETS:
%       dataC = the cell2struct return value of the struct array from the
%               light analysis
%
% RETURNS: 
%       dataC = same struct but now all heads are pointing to the right
%
% SYNTAX: dataC =FILA_ana_turnHead2right(dataC);
%
% Author: B. Geurten 25.2.15
%
% see also FILA_ana_turnHead2right

%check which is the most right line
headRight=cell2mat(cellfun(@(x) find(x(:,2)==max(x(:,2))),dataC(2,:),'UniformOutput',false));
%check if all max values are in the first (head) line
logIDX = headRight ~=1;
% if not turn the data
if sum(logIDX) ~= 0,
    warning('FILA_ana_turnHead2right: head needs to be turned'); 
    dataC(2,logIDX) = cellfun(@(x) flipud(x),dataC(2,logIDX),'UniformOutput',false);
    dataC(4,logIDX) = cellfun(@(x) fliplr(x),dataC(4,logIDX),'UniformOutput',false);
end
