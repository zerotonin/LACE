function IV_plot_2Dlolipop(trace,step,tail_len,lineFlag,cmap)
% This function plots one trajectory of an animal as a lolipop trace. This
% means the head is denoted as a circle and a line indictaes the body long
% axis. The plot is colorcoded from black to light grey. Axis are equal
%
% GETS:
%        trace = mx3 matrix col(1) x position col(2) y position col(3) yaw
%                vector in radians
%         step = scalar indicating which nth position should be plotted. If
%                set to one every frame is plotted. If set to 7 every 7th
%                frame is plotted.
%     tail_len = length of the body axis indicator
%     lineFlag = if set to 1 a line will be plotted over all trajectory
%                points
%         cmap = 
%   
% RETURNS: a figure, a great figure 
%
% SYNTAX:IV_plot_2Dloolipop(trace,step,tail_len,lineFlag)
%
% Author: Bart Geurten
% 
% see also:getFickmatrix


% number of recorded frames
frame_nb = size(trace,1);


% Producing tail coordinates
x = [tail_len 0 0]';
x_orient = zeros(frame_nb,3); %preallocation

% rotate tail
for i =1:frame_nb;
    rot_mat = getFickmatrix(trace(i,3),0,0,'a');
    x_temp = rot_mat * x;
    x_orient(i,:) = x_temp' + trace(i,:);
end

%counter for colormap
i = 1;
% create colormap
switch cmap
    case 'darkgray'
        cmap =colormap(darkgray(ceil(frame_nb/step)));
    case {'b'  'k' 'r' 'g' 'm' 'y' 'c'}
        cmap = repmat(cmap,ceil(frame_nb/step),1);
    otherwise
        if ismatrix(cmap) && size(cmap,2) ==3,
            cmap = repmat(cmap,ceil(frame_nb/step),1);
        end
end
hold on

% go through all frames 
for z = 1:step:frame_nb

    %plot ball
    h=plot(trace(z,1),trace(z,2),'o','MarkerSize',5);
    set(h, 'Color',cmap(i,:));
    set(h,'MarkerFaceColor',cmap(i,:));
    %plot tail
    h=line([trace(z,1) x_orient(z,1)],[ trace(z,2) x_orient(z,2)],'LineWidth',2);
    set(h, 'Color',cmap(i,:));

    %set counter
    i = i + 1;

end

% line

if exist('lineFlag','var'),
    if lineFlag == 1,
        plot(trace(:,1),trace(:,2),'r')
    end
end


%annotations
%xlabel('x [mm]')
% ylabel('y [mm]')
axis('equal')
hold off
