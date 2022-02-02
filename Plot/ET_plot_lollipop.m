function h = ET_plot_lollipop(x,y,yaw,tailLength,col,axisH)
% This function of the Ethotrack plot toolbox (ET_plot_) plots animal close
% ups in seperate subplots.
%
% GETS:
%             x = x - coordinate
%             y = y - coordinate
%           yaw = the orientation in radians
%    tailLength = length of the lollipop stick
%           col = colour of the lollipop
%         axisH = axis handle to plot to
%
% RETURNS:
%            h  = handle 1 is the handle to the lollipop stick,2 is the
%                 handle to the head 
%
% SYNTAX: [hL,hA]=ET_plot_addEllipse(traceResult,colorMap,Nb,axisH)
%
% Author: B. Geurten 11-30-15
%
% NOTE:
%
%
% see also  ET_plot_frameNellipses, ET_plot_addEllipse

% make orientation vector
yawPin= [tailLength 0 0]';
% get rotation matrix
rot_mat = getFickmatrix(yaw,0,0,'p');
% rotate vector with matrix
pin_temp = rot_mat * yawPin;
% shift flag 2 position in space
pin_orient = [pin_temp(1)+x,pin_temp(2)+y];
% plot the lollipop
h(1) = plot(axisH,[x pin_orient(1)],[y pin_orient(2)],'Color',col);
h(2) = plot(axisH,x,y,'o','Color',col,'MarkerFaceColor',col);