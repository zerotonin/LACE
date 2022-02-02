function varargout = ET_GUI_BashScript(varargin)
% ET_GUI_BASHSCRIPT MATLAB code for ET_GUI_BashScript.fig
%      ET_GUI_BASHSCRIPT, by itself, creates a new ET_GUI_BASHSCRIPT or raises the existing
%      singleton*.
%
%      H = ET_GUI_BASHSCRIPT returns the handle to a new ET_GUI_BASHSCRIPT or the handle to
%      the existing singleton*.
%
%      ET_GUI_BASHSCRIPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ET_GUI_BASHSCRIPT.M with the given input arguments.
%
%      ET_GUI_BASHSCRIPT('Property','Value',...) creates a new ET_GUI_BASHSCRIPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ET_GUI_BashScript_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ET_GUI_BashScript_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ET_GUI_BashScript

% Last Modified by GUIDE v2.5 27-Jan-2016 09:04:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ET_GUI_BashScript_OpeningFcn, ...
                   'gui_OutputFcn',  @ET_GUI_BashScript_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end


% --- Executes just before ET_GUI_BashScript is made visible.
function ET_GUI_BashScript_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ET_GUI_BashScript (see VARARGIN)

% Choose default command line output for ET_GUI_BashScript
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ET_GUI_BashScript wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = ET_GUI_BashScript_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%User Data
setappdata(handles.output,'toDo', {});
setappdata(handles.output,'bashDir', '~/ET_DetectionScript/bashScripts');
setappdata(handles.output,'CPUno', 4);
setappdata(handles.output,'jobList', {});
imshow('snLogo.jpg','Parent',handles.axes4)
end

%%%%%%%%%%%%%%%
% Pushbuttons %
%%%%%%%%%%%%%%%


% --- Executes on button press in pb_pickBashDir.
function pb_pickBashDir_Callback(hObject, eventdata, handles)
% get new folder name
% hObject    handle to pb_pickBashDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir(pwd,'pick new bash script folder');
if folderName ~= 0,
    setappdata(handles.output,'bashDir', folder_name);
end
end


% --- Executes on button press in pb_writeBashScript.
function pb_writeBashScript_Callback(hObject, eventdata, handles)
% hObject    handle to pb_writeBashScript (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

jobList = getappdata(handles.output,'jobList');
toDo = getappdata(handles.output,'toDo');
bashDir = getappdata(handles.output,'bashDir');

if ~isempty(jobList),
    baseDir = [ bashDir filesep datestr(now,'YYYY-mm-DD__hh-MM')];
    warning('off', 'MATLAB:MKDIR:DirectoryExists')
    mkdir(baseDir)
    warning('on', 'MATLAB:MKDIR:DirectoryExists')
    startScriptName  = [baseDir '_starter.sh'];
    
    fidStartScript = fopen(startScriptName,'w');
    % header start script
    fprintf(fidStartScript,'%s\n','#! /bin/bash');
    fprintf(fidStartScript,'%s\n','# This is an automated bash script that starts');
    fprintf(fidStartScript,'%s\n',['# ' num2str(size(jobList,1)) ' Matlab bash scripts for' ]);
    fprintf(fidStartScript,'%s\n','# parallel computation');
    fprintf(fidStartScript,'%s\n','');
    
    for i=1:size(jobList,1),
        baseFName = [baseDir filesep 'ET_bashScirpt_' num2strleadingZero(i,3) '.sh'];
        
        %write jobs for starter script
        fprintf(fidStartScript,'%s\n',['# Script No ' num2str(i)]);
        fprintf(fidStartScript,'%s\n',['gnome-terminal -e "bash -c \"' baseFName ' ; exec bash\""']);
        fprintf(fidStartScript,'%s\n','');
        
        %open file dialogue
        fidSingleScript = fopen(baseFName,'w');
        
        % header single script
        fprintf(fidSingleScript,'%s\n','#! /bin/bash');
        fprintf(fidSingleScript,'%s\n','# This is an automated distributed bash script that runs');
        fprintf(fidSingleScript,'%s\n',[ '# Matlab scripts it was built @ ' datestr(now)]);
        fprintf(fidSingleScript,'%s\n',[ '# it runs for at least ' num2str(round(jobList{i,2}/60)) ' min.']);
        fprintf(fidSingleScript,'%s\n','');
        jobIDX = jobList{i,1};
        % jobs single script
        for j =1:length(jobIDX),
            fprintf(fidSingleScript,'%s\n',['# Job No ' num2str(j)]);
            fprintf(fidSingleScript,'%s\n',['/usr/local/MATLAB/R2012b/bin/matlab -nodisplay -nodesktop -r " try, run ' toDo{jobIDX(j),1} ';end,quit" ']);
            fprintf(fidSingleScript,'%s\n','');
        end
        
        % close file
        fclose(fidSingleScript);
        system(['chmod +x ' baseFName ]);
    end
    
    fprintf(fidStartScript,'%s\n','exit');
    fclose(fidStartScript);
else
    errordlg('Distribute jobs first!')
end

end


% --- Executes on button press in pb_loadToDo.
function pb_loadToDo_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadToDo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the norpix file');
toDo = load2var([PathName FileName]);
setappdata(handles.output,'toDo', toDo);
end


% --- Executes on button press in pb_pickJobs.
function pb_pickJobs_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pickJobs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toDo = getappdata(handles.output,'toDo');
cpuNo= getappdata(handles.output,'CPUno');

if ~isempty(toDo),
    durS=cell2mat(toDo(:,2));
    jobList = ET_bat_assignCPU(cpuNo,durS);
    setappdata(handles.output,'jobList',jobList );
    
    %plot results
    data = [cellfun(@length,jobList(:,1)) cell2mat(jobList(:,2))];
    bar(data(:,2)./60,'Parent',handles.axes1)
    set(handles.axes1,'XTickLabel',[])
    ytm = get(handles.axes1,'YTick');
    set(handles.axes1,'YTick',ytm(2:end))
    ylabel(handles.axes1,'duration [dec. min]')
    bar(data(:,1),'Parent',handles.axes3)
    xlabel(handles.axes3,'Cpu No')
    ylabel(handles.axes3,'# jobs')
    
else
    errordlg('Load to-do-manager file first!')
end

end
%%%%%%%%%%%%%%%
% Subroutines %
%%%%%%%%%%%%%%%

%%%%%%%%%
% Edits %
%%%%%%%%%



function ed_cpuNo_Callback(hObject, eventdata, handles)
% hObject    handle to ed_cpuNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_cpuNo as text
%        str2double(get(hObject,'String')) returns contents of ed_cpuNo as a double
setappdata(handles.output,'CPUno',str2double(get(hObject,'String')));
end



function ed_bashDir_Callback(hObject, eventdata, handles)
% hObject    handle to ed_bashDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_bashDir as text
%        str2double(get(hObject,'String')) returns contents of ed_bashDir as a double
setappdata(handles.output,'bashDir',get(hObject,'String'));
end

%%%%%%%%%%%%%%%%%%%%
% Create Functions %
%%%%%%%%%%%%%%%%%%%%


% --- Executes during object creation, after setting all properties.
function ed_cpuNo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_cpuNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes during object creation, after setting all properties.
function ed_bashDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_bashDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
