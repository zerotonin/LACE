function  ivT_plot_tramov(mmTRA,step,saveM)
% This function plays a movie of up to 13 traces. 
% The fly are presented as a marker. following a fading trace of
% double the step size. If you want to see the movie frame by frame, choose
% step size 1. The fading trace then will be 2. If a step size of 10 is
% choosen, 20 fading steps of the trajectory will be shown. setting the
% saveM variable to 1 enables the save mode. Then single frames will be
% saved in tif files.
%
% GETS
%        mmTRA = mx2xp matrix holding fly trajectories in mm.
%                m is the number of frames, col(1) xposition col(2). As
%                derived by ivT_pix2mm; p is the number of trajectories
%        
%         step = step size how many frames should be displayed in a fading
%                trace. if set to 7 only every 7th frame will be displayed.
%                But you will see 14 trace positions in every picture
%                fading from black to midgray.
%      interpF = interpolation factor of the heat map
%        saveM = if set to 1 a gui will open and ask where to save each
%                frame of the resulting movie. if not set saveM is ignored
%
% RETURNS
%           a lot of figures
% SYNTAX: ivT_plot_tramov(mmTRA,step,saveM);
%
% Author: B.Geurten 22.3.12
%
% see also ivT_pix2mm, TMP_pro_temporalInterpTemp

marker= ['+';'o';'*';'.';'x';'s';'d';'p';'h';'<';'>';'^';'v'];
fadeTrace = linspace(0.5,0,2*step);
fadeTrace = repmat(fadeTrace',1,3);
[frameNb, ~ , traNb] = size(mmTRA);
h=figure();
screen_size = get(0, 'ScreenSize');
set(h, 'Position', [0 0 1200 800 ] );%
axis_lim = [min(min(min(mmTRA(:,1,:)))) max(max(max(mmTRA(:,1,:))))...
            min(min(min(mmTRA(:,2,:)))) max(max(max(mmTRA(:,2,:))))];

if saveM,
    mkdir('frames')
    for i=2*step+1:step:frameNb,
        figure(h);
        clf(h);
        hold on
         axis(axis_lim)
                axis equal
        for j=1:traNb,
            tempTRA = mmTRA(i-(2*step):i,:,j);
            for k=1:2*step,
                plot(tempTRA(k,1),tempTRA(k,2),marker(j),'color',[fadeTrace(k,:)])
               
            end
        end
        title(['time: ' num2str(round(i*.04)) ' s'])
        
        
        saveas(h,[ pwd '/frames/frame_' num2strleadingZero(i,4) '.tif' ])
    end
else
    
    
    for i=2*step+1:step:frameNb,
        figure(h);
        clf(h);
        hold on
        axis(axis_lim)
                axis equal
        for j=1:traNb,
            tempTRA = mmTRA(i-(2*step):i,:,j);
            for k=1:2*step,
                plot(tempTRA(k,1),tempTRA(k,2),marker(j),'color',[fadeTrace(k,:)])
                
            end
        end
        hold off
        pause(0.001)
    end
end


    