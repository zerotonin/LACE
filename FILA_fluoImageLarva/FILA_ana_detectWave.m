function [cLocs,sLocs,startsWith,status] = FILA_ana_detectWave(waveFinder,thresh,fps,offset)
% This function of the FILA toolbox finds the compression and stretch 
% (relaxation) peaks in the waveFinder trace of FILA_ana_postAnalysis. To
% do so it uses the find MinPeakDistance with user set threshold and a
% minimal peak distance is set to be a quarter of the fps the data was 
% recorded with meaning 0.25s.
%
% GETS:
%     waveFinder = the combined and filtered mean of the long axis
%                  (elipsefit),eccentricity, spline length, length of the
%                  inner spline [aU]
%         thresh = the minimal peak height as the data is before zscored a
%                  value of about 0.2 works best
%            fps = frames per second of the original footage
%         offset = detection offset is added two thresh
%
% RETURNS:
%          cLocs = indices of compression peaks
%          sLocs = indices of stretch peaks
%     startsWith = a string that indicates the first state of the larva
%                  'compression' or 'stretch'
%         status = status of the analysis if everything went through it
%                  returns 'done' otherwise 'peak structure unclear'
%
% SYNTAX: [cLocs,sLocs,startsWith,status]=FILA_ana_detectWave(waveFinder,thresh,fps);
%
% Author: B. Geurten 2014-2015 in different iterations
%
%
% Analysis Chain: FILA_ImageSpineAnalysis -> FILA_ana_postAnalysis -> 
%                 FILA_ana_struct2mat->FILA_ana_detectWave->FILA_ana_getROD-> 
%                 FILA_ana_getCompleteWaves -> FILA_ana_peristalsis
%
% see also FILA_ImageSpineAnalysis, FILA_ana_getCompleteWaves, 
%          FILA_ana_postAnalysis


% normalise
waveFinder = zscore(waveFinder);

if ~exist('offset','var')
    offset = 0;
end

% detect stretch peaks
[~,sLocs]=findpeaks(waveFinder,'MinPeakHeight',thresh+offset,'MinPeakDistance',ceil(fps/4));
%detect compression peaks
[~,cLocs]=findpeaks(waveFinder.*-1,'MinPeakHeight',thresh+offset*-1,'MinPeakDistance',ceil(fps/4));


% % plotFunction 
% figure(1),clf
% plot(waveFinder)
% hold on
% plot(sLocs, waveFinder(sLocs),'g*')
% plot(cLocs, waveFinder(cLocs),'r*')
% hold off

%check if waves beginn with contractions or

if cLocs(1) < sLocs(1),
   inBetweenPeaks = FILA_ana_detectWaveSR(cLocs,sLocs);
   startsWith = 'compression';
   status =  FILA_ana_detectWaveSRcheckResult(inBetweenPeaks);
else
   inBetweenPeaks = FILA_ana_detectWaveSR(sLocs,cLocs);
   startsWith = 'stretch';
   status =  FILA_ana_detectWaveSRcheckResult(inBetweenPeaks);
end
end

function inBetweenPeaks = FILA_ana_detectWaveSR(locs1,locs2)


inBetweenPeaks = NaN(1,length(locs1)-1);
for i=1:length(inBetweenPeaks),
    inBetweenPeaks(i) = sum(locs2> locs1(i) & locs2 < locs1(i+1));
end
end

function status =  FILA_ana_detectWaveSRcheckResult(inBetween),
   if sum(inBetween) ==length(inBetween),
       status = 'done';
   else
       status = 'peak structure unclear';
   end
end