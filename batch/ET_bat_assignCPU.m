function jobList = ET_bat_assignCPU(cpuNo,durS)
% This is a subroutine to automatically assign job weights to cpus. When we
% cluster large data sets we usually devide them up into chunks that then
% can be calculated in parallel on serveral cpus. One problem is to devide
% the workload equaly on the CPUs. We use a simple greedy algorithm to
% devide the jobs up on serveral CPUs. The weights are also problematic as
% we do not know the real weights at the moment we use a logarithmic
% weigthing system. So the job with the most classes is 1000 heavier then
% the easiest job.
%
% GETS:
%       cpuNo = number of CPUs on which the clustering can be split.
%     classes = a column vector with the different k - numbers
%  chunkSizes = a row vector with chunksizes (0 => <=1)
%  weightFunc = 'default' : logspaceSkalar(1,1000,length(classes));
%
% RETURNS:
%     jobList = a cell array  of cpuNo length. Each cell holds a mx3 matrix
%               1st col chunksize 2nd col k-number 3rd row jobweight
%
% SYNTAX: jobList = ...
%           CLUST_SR_weightCPUJobs(cpuNo,classes,chunkSizes,weightFunc);
%
% Author: B. Geurten 26.10.13
%
% see also





% CPUs grab
jobList = [cell(cpuNo,1) num2cell(zeros(cpuNo,1))];

for i = 1:numel(durS),
    % find the cpu with the smallest workload
    jobSum = cell2mat(jobList(:,2));
    freeCpu = find(jobSum == min(jobSum));
    freeCpu = freeCpu(1);
    
    % find the biggest job
    biggestJob = max(durS);
    r = find(durS == biggestJob); 
    r=r(1);
    
    % assign Job
    jobList{freeCpu,1} = [jobList{freeCpu,1} r ];
    jobList{freeCpu,2} = jobList{freeCpu,2} + biggestJob ;
    
    
    durS(r) =-Inf; % set job in list to -infinity so that it cannot be picked again
      
end

