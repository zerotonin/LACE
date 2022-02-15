function emptySlots = ivT_BenzerfindEmptySlots(trace,slotNo,arenaWidth)
% This function checks which slots where empty during a given automatoc
% Benzer test recording. To do so it belives that the number of slots are
% distributed evenly without offset in the arena. The center of the slots
% are used to calculate a histogram and such classes that have less then 5%
% entries of the total traj length are believed to be empty.
%
% GETS:
%      trace = mx6xn data matrix, where m is the number of frames and nthe number
%              of flies. The rows are defined as:  
%              1. filtered x-coordinate [mm]
%              2. filtered y-coordinate [mm]
%              3. filtered yaw [rad]
%              4. global horizontal speed [mm/s]
%              5. global vertical speed [mm/s]
%              6. yaw speed [rad/s
%     slotNo = number of available slots in the arena | DEFAULT: 15
% arenaWidth = width of the slot arena in mm | DEFAULT: 89
%  
% RETURNS:
% emptySlots = 1xm boolean vector, where m is the number of flies. 1 mark
%              empty slots;
%       
%
% SYNTAX: emptySlots = ivT_BenzerfindEmptySlots(trace,slotNo,arenaWidth);
% Author: B. Geurten 15.07.2014
%
% see also ivT_IO_readMultFullIVtrace, ivT_pixBoxGUI, norm,ivT_BenzerAnalysis

if size(trace,3) < slotNo,
    % get center of slots
    slotBorders = [0 5.5:6:90];
    slotCenters = bsxfun(@plus,slotBorders(1:end-1),diff(slotBorders)/2);
    % get xPositions
    xPositions = reshape(trace(:,1,:),numel(trace(:,1,:)),1);
%     % get rid of offset
%     xPositions = xPositions -min(xPositions);
    % histogram of x Positions around centers
    n = hist(xPositions,slotCenters);
    % empty slots are defined as those that have less than 5% of the data
    % inside
    emptySlots = n < (size(trace,1)*0.05);
else,
    % there are more than enough traces per slot
    emptySlots = zeros(1,size(trace,3)) ==1;
end


% figure(1)%clf
% hold on
% for i=1:size(trace,3),
%     plot(trace(:,1,i) ,trace(:,2,i),'b')
% end
% for i=1:length(slotCenters),
%     line([slotCenters(i) slotCenters(i)],[0 75],'Color','r')
% end
% 
% hold off
% xlabel('x-position [mm]')
% ylabel('z-position [mm]')
% axis equal
