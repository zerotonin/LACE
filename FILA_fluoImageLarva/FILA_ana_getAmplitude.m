function amplitudes = FILA_ana_getAmplitude(lengthLum,cLocs,sLocs,startsWith)
% This function calculates the stretch amplitudes of the fluoresecent
% larvae based on the overall size of the detected aniimal.

if strcmp(startsWith,'compression'),
    amplitudes = NaN(length(cLocs)-1,1);
    for i =1:length(cLocs)-1,
        amplitudes(i) = lengthLum(sLocs(i)) - mean(lengthLum([cLocs(i) cLocs(i+1)]));
    end
else
    amplitudes = NaN(length(sLocs)-1,1);
    for i =1:length(sLocs)-1,
        amplitudes(i) = lengthLum(cLocs(i)) - mean(lengthLum([sLocs(i) sLocs(i+1)]));
    end
end