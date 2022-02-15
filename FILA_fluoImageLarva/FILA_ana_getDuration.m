function  durations = FILA_ana_getDuration(cLocs,sLocs,startsWith,fps)

if strcmp(startsWith,'compression'),
    durations = diff(cLocs)./fps;
else
    durations = diff(sLocs)./fps;
end