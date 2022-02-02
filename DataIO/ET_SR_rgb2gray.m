function frame = ET_SR_rgb2gray(frame)

if size(frame,3) == 3
        frame = rgb2gray(frame);
elseif size(frame,3) ~=1,
        error('ET_SR_rgb2gray: This image format is not yet implemented')
end