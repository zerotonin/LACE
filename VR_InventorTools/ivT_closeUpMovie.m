function ivT_closeUpMovie(fileList,pix_coord,winSize,show)
% This function makes a closeup movie after tracking. Therefore it uses the
% pixel coordinates of the tracking to cut out a rectangle of user defined
% size around the coordinates. Afterwards it can be written as an avi or a
% series of tiff files.
%
% GETS:
%          fileList = list of filepositions as returned by ivT_makeFileList
%         pix_coord = mx2 matrix with positions from the ivTools tracking
%           winSize = two values defining 1) height 2) width of close up
%              show = boolean value defining if you want to see the
%                     closeups
%
% RETURNS: nothing writes files to disk, see above
%
% SYNTAX: ivT_closeUpMovie(fileList,pix_coord,winSize,show);
%
% Author: B.Geurten
%
% see also questdlg, VideoWriter, im2frame, ivT_makeFileList

% open file
fileID = fopen(fileList);

% read line from file
tempLine = fgetl(fileID);
% Construct a questdlg with three options
choice = questdlg('How do you want to save the close ups?', ...
    'File Types','Avi Video File',' Tiff Files','Tiff Files');

switch choice
    case 'Avi Video File'
        %get avi fileposition
        [sname, spath] =uiputfile({'*.avi','Avi Videos';...
            '*.*','All Files' },'Save Avi Video',...
            [pwd filesep 'closeUp.avi']);
        
        %get framerate
        prompt = {'Enter framerate'};
        dlg_title = 'Avi Framerate';
        num_lines = 1;
        def = {'200'};
        frate = inputdlg(prompt,dlg_title,num_lines,def);
        
        % built and open video writer object
        myObj = VideoWriter('closeUp.avi','Uncompressed AVI');
        open(myObj);
        myObj.FrameRate = frate{1};
    case 'Tiff Files'
        %get save path
        spath = uigetdir(pwd,'Where should the data be stored?');
        
        %get prefix and filetype
        prompt = {'Enter file prefix:','Enter filetyp suffix:'};
        dlg_title = 'filename information';
        num_lines = 1;
        def = {'frame_','tif'};
        sname = inputdlg(prompt,dlg_title,num_lines,def);
end



%framecounter
fcount = 0;

while ischar(tempLine) % if end of file is reached templine = -1 and this criteria
                       % terminates the reading process
    fcount = fcount+1;
    
    %get picture
    pic = imread(tempLine);
    
    %define borders
    upper = round(pix_coord(fcount,1)+winSize(1)/2);
    lower = round(pix_coord(fcount,1)-winSize(1)/2);
    left = round(pix_coord(fcount,2)-winSize(2)/2);
    right= round(pix_coord(fcount,2)+winSize(2)/2);
    
    %get close up
    closeUp = pic(upper:lower,left:right,:);
    
    %handle file saving
    switch choice
        % avi file saving, image is converted to frame and added to avi
        % object
        case 'Avi Video File'
            writeVideo(myObj,im2frame(closeUp),gray);
        % single tiff is written to file position
        case 'Tiff Files'
            imwrite(closeUp,[spath filesep sname{1} num2strleadingZero(fcount,5) sname{2}]);
            
    end
    
    % if user wants to see closeup during calculation
    if show
        figure(666)
        imagesc(closeUp)
        axis image
    end
end

%close IO file dialogue if avi save option was used
if strcmp(choice, 'Avi Video File')
    close(myObj);
end

