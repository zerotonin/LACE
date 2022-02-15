function IV_filterInventorTrace_batch(f_setting)
% This is a batch function that reads ivTrace trajectories, filters them
% transforms them into ivRender readable camera trajectories and saves all
% trajectory types. It starts in one directory and recursivly searches all
% tra files and does the calculation there. It saves the trajectories in the 
% same folder the original was. The filtered versions have a lable next to
% them.
%
% GETS
%    filterChoice = flag to determine which filter to use (moszt often 3)
%                   1: Savitzky-Golay (3,21)    label _SGolay321
%                   2: Savitzky-Golay (3,31)    label _SGolay331
%                   3: Butterworth (2,0.1)      label _ButterW201
%                   4: Butterworth (2,0.05)     label _ButterW2005
%                   5: Butterworth (3,0.1)      label _ButterW301
%                   6: Gauss 50 frame window | 3 frame sigma    _Gaus503
%                   default and other values evoke no filtering _nofilter
% RETURNS
%        nothing but writes the following files to disk. * = original file
%        name without extension:
%           *.trj = unfiltered version in ivRender format (passive angles)
%                   ascii file
%           *.mat = unfiltered version in ivRender format (passive angles)
%                   MatLab file
% filterlabel.trj = filtered version in ivRender format (passive angles)
%                   ascii file
% filterlabel.tra = filtered version in ivTrace format (passive angles)
%                   ascii file
% filterlabel.mat = filtered version in ivRender format (passive angles)
%                   MatLab file
 

%set filter label
switch f_setting
    case {1}
        filterlabel = '_SGolay321';
    case {2}
        filterlabel = '_SGolay331';
    case {3}
        filterlabel = '_ButterW201';
    case {4}
        filterlabel = '_ButterW2005';
    case {5}
        filterlabel = '_ButterW301';
    case {6}
        filterlabel = '_Gauss503';
    otherwise
        filterlabel = '_nofilter';
end


%get strating directory
dname = uigetdir(pwd,'Pick the parent directory of all trajectory files');
%get all tra files
[~,~,flist] = dirr(dname,'\.tra\>','name');
%get file number
f_num = length(flist);

%waitbar
h = waitbar(0,'Filtering data');

% mainloop: read,filter,write
for i=1:f_num,
    waitbar(1/f_num);
    %short hand
    read_fn = flist{i};
    
    %output file names
    write_trj_fn =  [read_fn(1:end-4) '.trj'];
    write_mat_fn =  [read_fn(1:end-4) '.mat'];
    write_f_trj_fn =  [read_fn(1:end-4) filterlabel '.trj'];
    write_f_tra_fn =  [read_fn(1:end-4) filterlabel '.tra'];
    write_f_mat_fn =  [read_fn(1:end-4) filterlabel '.mat'];
   
    %read file
    trajectory=IV_ivTrace2IVrenderTrj(read_fn);
    
    %filter
    trajectory_f = IV_filterInvetorTrace(trajectory,f_setting);
    
    %transform to iVTrace
    trajectory_ftra =IV_IVrenderTrj2ivTrace(trajectory_f);
    
    %write outputs
    IV_write_InventorTrj(trajectory,write_trj_fn);
    save(write_mat_fn,'trajectory');
    IV_write_InventorTrj(trajectory_f,write_f_trj_fn);
    IV_write_IVtraceTra(trajectory_ftra,write_f_tra_fn);
    save(write_f_mat_fn,'trajectory_f');
end
close(h)