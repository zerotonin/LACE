function  adjMat = ivT_calcDistance(trace)
%  This function calculates the distaces between different areas of the
%  same trace. The distances are in the dimesionality of the trace.
% 
%  GETS:
%           trace = mxpxn matrix, where m(1) is the x coordinate m(2) is
%                   the y coordinate. n is the number of sareas / animals

%  
%  RETURNS: 
%          adjMat = pxpxm matrix. Adjecency matrix containing the
%                   distances between animals. p is the number of positions
%  
%  SYNTAX:  adjMat = ivT_calcDistance(trace);
%  
%  Author: B.Geurten
%  
%  see also 

%get trace size
t_size = size(trace);
%preallocate data
adjMat = NaN(t_size(3),t_size(3),t_size(1));

for k=1:t_size(1),
    for i =1:t_size(3),
        for j=i+1:t_size(3),
            %calc distance
            adjMat(i,j,k) = abs(trace(k,1,i)- trace(k,1,j))+abs(trace(k,2,i)- trace(k,2,j));
            adjMat(j,i,k) = abs(trace(k,1,i)- trace(k,1,j))+abs(trace(k,2,i)- trace(k,2,j));
        end
    end
end