function ivT_IO_writeIVtrace2DMult(traMult,names,directory,suffix)

try 
    mkdir(directory)
end
h = waitbar(0,'Please wait...');
traNb= size(names,2);
for i=1:traNb,
    IV_write_IVtraceTra2D(traMult{i},[directory filesep ...
        names{i}(1:end-5) suffix names{i}(end-4:end)])
    waitbar(i/traNb,h)
end
close(h)