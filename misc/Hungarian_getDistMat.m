function distMat = Hungarian_getDistMat(group1,group2,measure)
% This funtion ois a subroutine for a Hungarian perfect matching. To
% determine the pefect matching of a bipartite graph one has to create a
% distance matrix first. in this mxn matrix the costs of all matching
% between node of group m and  group n are calculated. The resulting matrix
% is a  mxn matrix. The measurement for the distances or costs are given by
% the pdist function. 
%
% GETS:
%                group1 = mxp matrix with the coordinates of the vertices
%                         of the first group of the bipartide graph, where
%                         m is the number of vertices and p is the number
%                         of dimensions in which the corrdinates are given.
%                group2 = nxp matrix with the coordinates of the vertices
%                         of the first group of the bipartide graph, where
%                         n is the number of vertices and p is the number
%                         of dimensions in which the corrdinates are given.
%               measure = the distance measure string as follows:
%         'euclidean'   - Euclidean distance (default)
%         'seuclidean'  - Standardized Euclidean distance. Each coordinate
%                         difference between rows in X is scaled by dividing
%                         by the corresponding element of the standard
%                         deviation S=NANSTD(X). To specify another value for
%                         S, use D=pdist(X,'seuclidean',S).
%         'cityblock'   - City Block distance
%         'minkowski'   - Minkowski distance. The default exponent is 2. To
%                         specify a different exponent, use
%                         D = pdist(X,'minkowski',P), where the exponent P is
%                         a scalar positive value.
%         'chebychev'   - Chebychev distance (maximum coordinate difference)
%         'mahalanobis' - Mahalanobis distance, using the sample covariance
%                         of X as computed by NANCOV. To compute the distance
%                         with a different covariance, use
%                         D =  pdist(X,'mahalanobis',C), where the matrix C
%                         is symmetric and positive definite.
%         'cosine'      - One minus the cosine of the included angle
%                         between observations (treated as vectors)
%         'correlation' - One minus the sample linear correlation between
%                         observations (treated as sequences of values).
%         'spearman'    - One minus the sample Spearman's rank correlation
%                         between observations (treated as sequences of values).
%         'hamming'     - Hamming distance, percentage of coordinates
%                         that differ
%         'jaccard'     - One minus the Jaccard coefficient, the
%                         percentage of nonzero coordinates that differ
%         function      - A distance function specified using @, for
%                         example @DISTFUN.
%  
%     A distance function must be of the form
%  
%           function D2 = DISTFUN(XI, XJ),
% RETURNS
%             stackInfo = an mxn matrix with the pairwise distances
%
% SYNTAX: distMat = Hungarian_getDistMat(group1,group2,measure);
%
% Author: B.Geurten 20.8.15
%
% see also pdist, squareform, Hungarian

completeMat = squareform(pdist([group1;group2],measure));
distMat = completeMat(1:size(group1,1),size(group1,1)+1:end);
