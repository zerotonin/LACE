function frame = ET_GUI_SR_loadFrame(handles,frameNumber)


try,
    headSize = getappdata(handles.output,'headerSize');
catch,
    headSize =1024
end
movieFpos = getappdata(handles.output,'movieFilePos');

switch getappdata(handles.output,'movieIOtype'),
    case 'videoReader'
        rawFrame = read(movieFpos.movObj,movieFpos.IDX(frameNumber));
        frame = ET_SR_rgb2gray(rawFrame);
    case 'norpix'
        frame = double((ivT_norpix_loadSingleImage(movieFpos.fid,...
            movieFpos.headerInfo,movieFpos.endianType,movieFpos.IDX,...
            frameNumber,headSize)));
    case 'imageStack'
        frame = ET_SR_loadImage(movieFpos.fPos{movieFpos.IDX(frameNumber)});
end
