function ivT_BatchGenderROI

[list_fn, path2lists] = uigetfile( ...
    {  '*.txt','ASCII Lists (*.txt)'}, ...
    'Pick movie lists', ...
    'MultiSelect', 'on');

if iscell(list_fn),
    fileNB = length(list_fn);
else
    fileNB = 1;
    list_fn = {list_fn};
end

prompt = {'How many CPUs do you want to assign:'};
num_lines = 1;
def = {'4'};
cpuNB = str2double(inputdlg(prompt,'CPU Power',num_lines,def));

[script_fn,path2script] = uiputfile('','Name of the script file','ivTBatchScript.sh');

% make split operations
if fileNB < cpuNB,
    cpuList = [1:fileNB; 1:fileNB]';
else
    base = repmat(fix(fileNB/cpuNB),cpuNB,1);
    reminder = rem(fileNB,cpuNB);
    base(1:reminder) = base(1:reminder)+1;
    cpuList = [ cumsum(base) (1:cpuNB)'];
end
              
path2ivTScripts = uigetdir(pwd,'ivTrace Scripts');

scriptList = {};

for i = 1:cpuNB,
    scriptList{i} =   [path2script  script_fn(1:end-3) '_' num2strleadingZero(i,1) script_fn(end-2:end)];
    fid = fopen(scriptList{i},'a');
    fprintf(fid,'%s\n','# This is a automated shell script to trace large numbers of HS movies.');
    fprintf(fid,'%s\n','# It uses IVTBatch and works only on LINUX systems on which ivTBatch is installed.');
    fprintf(fid,'%s\n',['# The script wa automatically created by ivT_BatchGenderROI.m @ ' datestr(now)]);
    fprintf(fid,'\n');
    fclose(fid);
end

for i =1:fileNB,
    skip = 0;
    % Construct a questdlg with three options
    choice = questdlg(['How many flies are in movie ' list_fn{i}  '?'], ...
        list_fn{i}, ...
        'One','Two','Skip','One');
    % Handle response
    switch choice
        case 'One'
            flyNb = 1;
        case 'Two'
            flyNb = 2;
        case 'Skip'
            skip =1;
    end
    
    if flyNb == 2 && skip == 0,
        choice = questdlg(['What gender is the fly on the left?'], ...
            list_fn{i}, ...
            'Male','Female','Male');
        % Handle response
        switch choice
            case 'Male'
                flyL = 'M_script.txt';
            case 'Female'
                flyL = 'F_script.txt';
        end
        
        choice = questdlg(['What gender is the fly on the right?'], ...
            list_fn{i}, ...
            'Male','Female','Male');
        % Handle response
        switch choice
            case 'Male'
                if strcmp(flyL,'M_script.txt'),
                    flyR = 'M2_script.txt';
                else
                    flyR = 'M_script.txt';
                end
            case 'Female'
                if strcmp(flyL,'F_script.txt'),
                    flyR = 'F2_script.txt';
                else
                    flyR = 'F_script.txt';
                end
        end
        
        comStr = ['ivTBatch -v -r ' path2ivTScripts filesep 'leftROI.txt -s ' ...
                  path2ivTScripts filesep flyL ' -l ' path2lists  list_fn{i} ];     
        write2file(comStr,cpuList,scriptList,i);  
        
        comStr = ['ivTBatch -v -r ' path2ivTScripts filesep 'rightROI.txt -s ' ...
                  path2ivTScripts filesep flyR ' -l ' path2lists  list_fn{i} ];     
        write2file(comStr,cpuList,scriptList,i);      
    elseif flyNb == 1 && skip == 0,
        choice = questdlg(['What gender is the fly?'], ...
            list_fn{i}, ...
            'Male','Female','Male');
        
        % Handle response
        switch choice
            case 'Male'
                fly = 'M_script.txt';
            case 'Female'
                fly = 'F_script.txt';
        end
        
        choice = questdlg(['Where is the fly?'], ...
            list_fn{i}, ...
            'Left arena','Right arena','Right arena');
        % Handle response
        switch choice
            case 'Right arena'
                arena = 'rightROI.txt';
            case 'Left arena'
                arena = 'leftROI.txt';
        end  
        
        comStr = ['ivTBatch -v -r ' path2ivTScripts filesep arena ' -s ' ...
                  path2ivTScripts filesep fly ' -l ' path2lists  list_fn{i} ];     
        write2file(comStr,cpuList,scriptList,i);
        
    end
end
end

    function write2file(comStr,cpuList,scriptList,i)
        cpuCan = find(i<=cpuList(:,1));
        
        fid = fopen(scriptList{cpuList(cpuCan(1),2)},'a');
        fprintf(fid,'%s\n',comStr);
        fclose(fid);
    end
