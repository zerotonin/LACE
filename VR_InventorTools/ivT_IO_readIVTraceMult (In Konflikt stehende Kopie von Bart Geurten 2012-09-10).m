function trace = ivT_IO_readIVTraceMult(filepos,traID)
% This function load 

% check if fileposition is given
if ~exist('filepos','var'),
    [fname,path]=uigetfile('*.tra','Pick ivTrace trajectory');
    filepos = [path fname];
elseif isempty(filepos)
    [fname,path]=uigetfile('*.tra','Pick ivTrace trajectory');
    filepos = [path fname];
end

if ~exist('traID','var'),
    prompt = {'Enter tra IDs in Matlab syntax (e.g. 1:10):'};
    dlg_title = 'trajectory IDs';
    num_lines = 1;
    def = {'1'};
    mlSyntax = inputdlg(prompt,dlg_title,num_lines,def);
    eval(['traID = ' mlSyntax{1} ';']);
elseif isempty(traID)
    prompt = {'Enter tra IDs in Matlab syntax (e.g. 1:10):'};
    dlg_title = 'trajectory IDs';
    num_lines = 1;
    def = {'1'};
    mlSyntax = inputdlg(prompt,dlg_title,num_lines,def);
    eval(['traID = ' mlSyntax{1} ';']);
end

if strcmp(traID,'all'),
    fid = fopen(filepos);
    line = fgetl(fid);
    numbers = sscanf(line,'%f',[1 inf]);
    traID = (length(numbers)-1)/5;
    traID =1:traID;
    fclose(fid);
end
    
    



trace= [];


for i =traID
    
    % calculate column index of center of gravity coordinates for
    % desired trace by using the ftgui trace format knowledge
    dataIndex = 2+(i-1)*5;
    
    % read this column
    r=loadco(filepos, dataIndex);
    p=loadco(filepos, dataIndex+1);
    t=loadco(filepos, dataIndex+2);
    
    % Concate the two columns to one matrix
    trace = cat(3,trace,[r,p,t]);
    
end