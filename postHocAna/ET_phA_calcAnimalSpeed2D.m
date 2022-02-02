function ts_speed = ET_phA_calcAnimalSpeed2D(trace)
% This function calculates the animal centered speeds (thrust, slip). It
% uses a Fick matrix to calculate to turn the position vector (pointing from 
% position t0 to t1) according to the yaw angle of the fly. The new vector
% represents thrust and yaw.
%
% GETS:
%       trace = a mx3 vector with m positions col(1) has the x col(2) the y
%               position in column 3 the yaw vector is stored
% RETURNS:
%    ts_speed = a mx2 vector containing in column(1) the thrust and col(2)
%               the slip of the animal. Note that the last line, has NaN
%               values because you get one less speed values than position
%               values.
%
% SYNTAX: ts_speed = IV_2Dtrace_calcAnimalSpeed(trace);
%
% Author: Bart Geurten
% 
% see also getFickmatrix

% make original speeds
xy_speed = diff(trace(:,1:2));

% make cell array
xy_speed = mat2cell(xy_speed,ones(1,size(xy_speed,1)),2);

% the rotation matrices
% it is pi - yaw angle because we measure to the x-axis and ivTrace to the
% y-axis
rotMat2D = arrayfun(@(y)[cos(pi+y) sin(pi+y).*-1; sin(pi+y) cos(pi+y) ] ,trace(1:end-1,3),'UniformOutput',false);
ts_speed = cell2mat(cellfun(@(x,y) (x*y')',rotMat2D,xy_speed,'UniformOutput',false));

%add last line
ts_speed(end+1,:)= NaN(1,2); 


