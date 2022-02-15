function rot_mat = getFickmatrix(y,p,r,modus)
% This function calculates the passive or acrtive rotationmatrix with Euler angles in the Fick
% coordination
% GETS y     = yaw (radians)
%      p     = pitch
%      r     = roll
%      modus = "a" for an active rotation matrix or "p" for a passive
%              matrix
%
% SYNTAX rot_mat = getFickmatrix(yaw,pitch,roll, modus)
%
% Author: B. Geurten
%
% see also calcRotAxisFromFickAngles,getFickMatrix2D

if strcmp(modus, 'p'),
    rot_mat =[cos(y)*cos(p)     cos(y)*sin(p)*sin(r)-sin(y)*cos(r)      cos(y)*sin(p)*cos(r)+sin(y)*sin(r);...
              sin(y)*cos(p)     sin(y)*sin(p)*sin(r)+cos(y)*cos(r)      sin(y)*sin(p)*cos(r)-cos(y)*sin(r);...
             -sin(p)                   cos(p)*sin(r)                             cos(p)*cos(r)      ];
elseif strcmp(modus, 'a'),
    rot_mat =[cos(y)*cos(p)                        -sin(y)*cos(p)                        sin(p)        ;...
              cos(y)*sin(p)*sin(r)+sin(y)*cos(r)   -sin(y)*sin(p)*sin(r)+cos(y)*cos(r)  -cos(p)*sin(r) ;...
             -cos(y)*sin(p)*cos(r)+sin(y)*sin(r)    sin(y)*sin(p)*cos(r)+cos(y)*sin(r)   cos(p)*cos(r)];
else
    error('`This is no valid modus either use "a" for an active rotation matrix or "p" for a passive matrix ')
end        