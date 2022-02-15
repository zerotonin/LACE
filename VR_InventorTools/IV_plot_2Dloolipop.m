function IV_plot_2Dloolipop(trace,step,tail_len)

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
cmap =colormap(gray(ceil(frame_nb/step)));
hold on

% go through all frames 
for z = 1:step:frame_nb

    %plot ball
    h=plot(trace(z,1),trace(z,2),'o');
    set(h, 'Color',cmap(i,:));
    %plot tail
    h=line([trace(z,1) x_orient(z,1)],[ trace(z,2) x_orient(z,2)]);
    set(h, 'Color',cmap(i,:));

    %set counter
    i = i + 1;

end
%annotations
xlabel('x [mm]')
ylabel('y [mm]')
axis('equal')
hold off
% get view correct
view(0,-90)