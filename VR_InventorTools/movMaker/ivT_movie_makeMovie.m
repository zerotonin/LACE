function movie = ivT_movie_makeMovie(fPos,anaTRA,SPmode,Fmode,fps,lolliN,...
                    mapChoice,tailLength,fH,saccadeT,saccadePos,...
                    pix2mm,offSet,cometWake,fParameters,stepSize,visMode)
% This subroutine of the ivT_movie toolbox (ivTrace movie making toolbox)    
% makes a movie from figure states that contains a trajectory in different
% styles (see Fmode) overlayed on the footage from a movie. The figure may
% or may not have additional graphs (see SPmode). This is saved in a movie
% struct and can be saved via ivT_movie_writeMov.
%
% GETS:
%      fPos = cell list with the absolute file positions of the frames in
%             the identical succesion as the anaTra
%    anaTRA = mx3xp where m is the number of frames | col(1) x-mm-coords
%             | col(2) y-mm-coords | col(3) yaw in radians and unwrapped
%             with ivT_unwrapYaw | size of the object | eccentricity of the
%             object | thrust [mm*s⁻¹] | slip [mm*s⁻¹] | lift [mm*s⁻¹]
%       fps = scalar frames per second
%    lolliN = the number tells you distance between two lollipops the
%             second number the position of the last lollipop
% mapChoice = if set to 1 the lollipos will be color coded in darkgray | 2)
%             jet | 3) summer
%tailLength = how long the stick of the lollipop should be, if empty or not
%             set it is set to 5% of the maximal distance in the
%             trajectory
%        fH = figure Handle where to plot to
%  saccadeT = saccade threshold used for detection -> get_saccades
%saccadePos = frame indices at which the saccades happen, from get_saccades
%             second column of the return value
%    pix2mm = the factor to calculate from pixels 2 mm 
%    SPmode = if subplotmode is set to 'on' the velocity subplots will be
%             plotted
%     Fmode = frame version to plot either 'comet' or normal 'lollipop'
% cometWake = how many frames is the comet wake long or how many positions
%             are shown before the last
%fParamters = parameters a struct with three fields PaperUnits, Position
%             and Paper Position, as correspondend to the figure
%             properties
%  stepSize = how many frames are in between each videoframe 1:stepSize:end
%   visMode = if set to 1 the figure is shown
%
% RETURNS:
%     movie = a Matlab movie struct array with 2 fields cdata and image
%
% SYNTAX: movie = ivT_movie_makeMovie(fPos,anaTRA,SPmode,Fmode,fps,lolliN,...
%                    mapChoice,tailLength,fH,saccadeT,saccadePos,...
%                    pix2mm,offSet,cometWake,fParameters,stepSize,visMode) 
%
% Author: B. Geurten 13.10.15
%
% see also ivT_movie_lollipopTrace,ivT_movie_makeSpeedSubplots,
%          ivT_movie_makeMovieFrame,ivT_movie_writeMov

if size(fPos,1) ~= size(anaTRA,1),
    error('ivT_movie_makeMovie:number of images is different from lenth of trajectory')
end
c= 1;
if visMode == 0,
    set(fH, 'visible','off');
    for i =1:stepSize:length(fPos)
        
        ivT_movie_setSize(fH,fParameters);
        
        ivT_movie_makeMovieFrame(fPos,anaTRA,SPmode,Fmode,fps,lolliN,...
            mapChoice,tailLength,i,fH,saccadeT,saccadePos,pix2mm,...
            offSet,cometWake);
        
        drawnow
        movie(c)=getframe(fH);
        c=c+1;
    end
    close(fH);
else
    for i =1:stepSize:length(fPos)
        
        ivT_movie_setSize(fH,fParameters);
        
        ivT_movie_makeMovieFrame(fPos,anaTRA,SPmode,Fmode,fps,lolliN,...
            mapChoice,tailLength,i,fH,saccadeT,saccadePos,pix2mm,...
            offSet,cometWake);

        drawnow
        movie(c)=getframe(fH);
        c=c+1;
        
    end
end