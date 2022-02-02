function img = ET_GUI_SR_undistort(handles,img)


if getappdata(handles.output,'undistort') == 1
    params = getappdata(handles.output,'distortParams');
    img = ET_im_undistort(img, params);
end