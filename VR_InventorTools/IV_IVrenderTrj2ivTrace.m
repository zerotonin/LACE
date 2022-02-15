function trajectory=IV_IVrenderTrj2ivTrace(trajectory)
% This function tranforms a IVtrace 3D trajectory in to a Inventor readable
% camera trajectory. Therefore the orientations has to betransformed from
% a rotation axis normalized to the roationan angle (ivTrace) into the
% passive Fick angles (Inventor). Also the y,z axis have to be adjusted to
% the different coordinate system. The trajectory furthermore is filtered
% with a 2nd degree Butterworth filter with a cut off frequency of .1
%
% GETS
%       trajectory = mx6 trajectory in IVrender format
% RETURNS
%       trajectory mx6 matrix consisting of x,y,z position in Inventor
%       coordinates and yaw pitch roll as passive Fick angles
%
% SYNTAX IV_ivTrace2IVrenderTrj(trajectory,filepos);
%
% Author: B. Geurten
%
% see also IV_writeInventorTrj, IV_write_discArena,
% calcFickAnglesFromRotAxis



% angle transformation from rotation axis to passive Fick angles
trajectory(:,4:6) =  calcRotAxisFromFickAngles(trajectory(:,4:6),'p'); % get rot axis

%function call to transform from IvTrace to IvRender
trajectory = tra2path(trajectory);

