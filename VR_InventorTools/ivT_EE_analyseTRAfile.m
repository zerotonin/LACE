function [trace,tracef] = ivT_EE_analyseTRAfile(fPos,animalNo)

[trace , artifacts] = ivT_readFile(fPos,animalNo);
trace = reshape(trace(:,2:end),[size(trace,1),5,animalNo]);
trace = trace(:,1:2,:);

[B,A] = butter(2,0.1);
 tracef = filtfilt(B,A,trace);