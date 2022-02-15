function [saccs, broken] = get_saccades(ang_vel, threshold, varargin)
%This function finds saccades in an angle velocities. Its transverses the
%velocities in search of threshold. When this threshold is crossed its
%searches for the beginng of the slope. This might either be the first
%value before the slope changes direction or zero. The same is done for the
%end of the saccade. The peak is found by a maximum search.
%
%GETS:      ang_vel = Values of the angle velocities
%           threshold = the threshold that has to be crossed to detect a saccade
%                    
%         VarArgIn
%         * You might add the statement 'plot' after these values if you
%           want to see where the saccades where found
%         * Sometimes one saccades 'overlap'. Then the 
%           end of the first saccade is after or simutanously to the start 
%           of the second. 
%         ** If you use the statement 'merge_overlap', these  saccades are 
%           treated as one. 
%         ** If you use 'del_overlap' both saccades are deleted in saccs
%           and marked as broken saccades in broken.    
%         ** If you use 'ex_overlap' only the merged saccades are returned
%           in saccs and all other saccades are shifted to broken.
%
%RETURNS:   saccs = a mxn matrix where m is the number of found saccades
%                   and n are the following rows: start, peak
%                   ,end,direction duration and amplitude of the saccade.
%                   After this the start and end of the intersaccdic
%                   intervals are given.
%           broken = a mxn vector with the start, peaks and ends of broken 
%                    saccades
%
%SYNTAX:    [saccs, broken] = get_saccades(ang_vel,threshold,varargin);
%
% Author: B.Geurten
%
% see also get_saccades_moviewise, findpeaks

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Getting variable input arguments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ang_vel_plot = ang_vel;
plotSaccs = 0;
merge_overlap = 0;
del_overlap = 0;
ex_overlap = 0;
for i=1:length(varargin),
    if strcmpi(varargin{i},'plot'),
        plotSaccs =1;
    elseif strcmpi(varargin{i},'merge_overlap'),
        merge_overlap = 1;
    elseif strcmpi(varargin{i},'del_overlap'),
        del_overlap = 1;
    elseif strcmpi(varargin{i},'ex_overlap'),
        ex_overlap = 1;
    elseif isstr(varargin{i}),
        disp('Unknown input argument')
    end
    
end

%intialising variables
ang_len = length(ang_vel);
start = [];
stop = [];
broken_start = [];
broken_end = [];
del_me = [];
broken_pos = [];
last_correct_start =-39;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Getting all saccs with an amplitude above threshold %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sacc_amp,sacc_pos] = findpeaks(abs(ang_vel),'minpeakheight',threshold,'minpeakdistance',5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finding starts and ends of the saccades and mark broken saccades %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(sacc_pos),
    %Finding beginning of saccade
    start_ok =1;
    for j=sacc_pos(i)-1:-1:1,
        if  j == 1 %|| j-last_correct_start < 40, %if the start is undetectable the saccade is noted in delme
            broken_pos = [broken_pos; sacc_pos(i)];
            broken_start = [broken_start; j];
            del_me = [del_me; i];
            start_ok = 0;
            start = [start; NaN];
    
            break
        elseif (sign(ang_vel(j)) ~= sign(ang_vel(j+1)) || abs(ang_vel(j)) > abs(ang_vel(j+1)) )
            start = [start; j];
            last_correct_start = j;
       
            break
        end
    end
    
        for j = sacc_pos(i):ang_len-1,
            if j+1 == length(ang_vel), % if the end is undectable the saccade is noted in del_me
                broken_pos = [broken_pos; sacc_pos(i)];
                broken_start = [broken_start; start(end)];
                broken_end = [broken_end; j];
                del_me = [del_me; i]; 
                stop =[stop; NaN];
              
    
                break
            elseif (sign(ang_vel(j)) ~= sign(ang_vel(j+1)) || abs(ang_vel(j)) < abs(ang_vel(j+1)))
                if start_ok
                    stop = [stop; j];
                else
                    stop =[stop; NaN];
                    broken_end = [broken_end; j];
                end
     
                break
            end
            
        end

end
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deleting broken saccades from saccade counter %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sacc_amp(del_me) = [];
sacc_pos(del_me) = [];
start(del_me)    = [];
stop(del_me)     = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Processing overlapping saccades %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MERGE

if merge_overlap,
   %Merge saccades which end and start are overlapping
    i =1;
    while i <= length(start)-1;
        i= i+1; 
        if start(i) <= stop(i-1),
            stop(i-1) = stop (i);
            start(i)    = [];
            stop(i)     = [];
            sacc_amp(i) = [];
            sacc_pos(i) = [];
            i =i-1; % this line is needed, because after merging the last 
                    % saccade, you have to test if the merged saccade
                    % overlaps with the next
        end
    end
end

% DELETE

if del_overlap,
    %Delete saccades which end and start are overlapping
    del_me =[];
    for i =2:length(start),
        if start(i) <= stop(i-1);
            del_me = [del_me; i-1;i];
        end
    end
    del_me = del_me(find(diff(del_me)==1)); % reject doublicate indices;
    %shove combined saccs to brokensaccs 
    broken_start = sort([broken_start;start(del_me)]);
    broken_end   = sort([broken_end;   stop(del_me)]);
    broken_pos   = sort([broken_pos;   sacc_pos(del_me)]);
    % delete combined saccs 
    sacc_amp(del_me) = [];
    sacc_pos(del_me) = [];
    start(del_me)    = [];
    stop(del_me)     = [];
end

% EXTRACT

if ex_overlap,
    %Delete saccades which end and start are overlapping
    keep_me =[];

    for i =2:length(start),
        if start(i) <= stop(i-1);
            keep_me = [keep_me; i-1;i];
        end
    end
    keep_me = keep_me(find(diff(keep_me)==1)); 
    
    %shove non-overlapping saccs to brokensaccs 
    temp_start = start;
    temp_pos   = sacc_pos;
    temp_end   = stop;
    temp_start(keep_me) = [];
    temp_pos(keep_me)   = [];
    temp_end(keep_me)   = [];
    broken_start = sort([broken_start; temp_start]);
    broken_end   = sort([broken_end;   temp_end]);
    broken_pos   = sort([broken_pos;   temp_pos]);
    
    
    
    % delete non-overlapping saccs 
    sacc_amp = sacc_amp(keep_me);
    sacc_pos = sacc_pos(keep_me);
    start    = start(keep_me);
    stop     = stop(keep_me);
       
    
    
    
   %Merge saccades which end and start are overlapping
    i =1;
    while i <= length(start)-1;
        i= i+1; 
        if start(i) <= stop(i-1),
            stop(i-1) = stop (i);
            start(i)    = [];
            stop(i)     = [];
            sacc_amp(i) = [];
            sacc_pos(i) = [];
            i =i-1; % this line is needed, because after merging the last 
                    % saccade, you have to test if the merged saccade
                    % overlaps with the next
        end
    end
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating return value %
%%%%%%%%%%%%%%%%%%%%%%%%%

if isempty(start)
    saccs = [];
    broken = [];
else
    saccs = [start sacc_pos stop sign(ang_vel(sacc_pos)) stop-start sacc_amp];
    broken = [broken_start broken_pos broken_end];
    
end

%%%%%%%%%%%%
% Plotting %
%%%%%%%%%%%%

if plotSaccs ==1,
    start_ys = ang_vel_plot(start);
    stop_ys = ang_vel_plot(stop);
    peak_ys = ang_vel_plot(sacc_pos);
    figure()
    plot(ang_vel_plot)
    hold on
    plot(1:ang_len,ones(1,ang_len)*threshold,'--k');
    plot(start,start_ys,'g*',sacc_pos,peak_ys,'mo',stop,stop_ys,'rs')
       hold on
    plot(1:ang_len,ones(1,ang_len)*-threshold,'--k');
    hold off
    legend('angle velocity','threshold','start','peak','end')
    xlabel('time')
    ylabel('angular velocity')
    
end

