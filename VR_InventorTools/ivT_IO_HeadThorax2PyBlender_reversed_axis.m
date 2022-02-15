function ivT_IO_HeadThorax2PyBlender(fposH,fposT,spos,filterChoice,sameZ)
% This fuction reads in two 3D ivTrace traces for the head and thorax of a
% a given trajectory and writes out a small python script that allows the
% programm blender to run a 3D trajectory with a set of given objects.
%
% GETS: 
%        fposH = absolute fileposition of the head trajectory
%        fposT = absolute fileposition of the thorax trajectory
%        spos  = absolute fileposition of the python script
%                if any of the aboth set variables is empty the verbose 
%                mode is activated and the user has to set file  positions         
% filterChoice = flag variable that elicits filtering as follows:
%                1 = Savitzky-Golay (3,21)
%                2 = Savitzky-Golay (3,31)
%                3 = Butterworth (2,0,1)
%                4 = Butterworth (2,0.05)
%                5 = Butterworth (3,0.1)
%                6 = Gauss 50 frame window | 3 frame sigma
%                default and other values evoke no filtering
%        sameZ = if 1 head get thorax z-coordinate
%
% RETURNS: nothing, writes out script to given position
%
% SYNTAX: ivT_IO_HeadThorax2PyBlender(fposH,fposT,spos,filterChoice);
%
% Author: B. Geurten 20.2.2013
%
% see also fprintf, filter3DTrace, strfind

if isempty(fposH),
    [filenameH, pathnameH] = uigetfile( ...
{'*.tra;*.trj;*.traj','ivTools trajectory file (*.tra,*.trj,*.traj)';
   '*.*',  'All Files (*.*)'}, ...
   'Pick the head trajectory file');
fposH = [pathnameH, filenameH];
end

if isempty(fposT)
[filenameT, pathnameT] = uigetfile( ...
{'*.tra;*.trj;*.traj','ivTools trajectory file (*.tra,*.trj,*.traj)';
   '*.*',  'All Files (*.*)'}, ...
    'Pick the thorax trajectory file');
fposT = [pathnameT, filenameT];
end

if isempty(spos),
[filename, pathname] = uiputfile(...
 {'*.py';'*.m';'*.txt';'*.*'},...
 'Save python-file as' , [fposT(1:end-4) 'py']);
spos = [pathname,filename];
end

% load data
head = ivT_IO_3DmanTrace(fposH);
thorax = ivT_IO_3DmanTrace(fposT);

% make same length
thorax(isnan(thorax(:,6)),:) = [];
head(  isnan(  head(:,6)),:) = [];

if length(thorax) >=  length(head); % check which one is longer
    indice = strfind(thorax(:,1)',head(:,1)'); % strfind identifies the frame numbers that are in both trajectories 
    thorax = thorax(indice:length(head)+indice-1,:);
else
    indice = strfind(head(:,1)',thorax(:,1)');
    head = head(indice:length(thorax)+indice-1,:);
end

if sameZ,
    headDiff = head(1,4);
    thoraxDiff = thorax(1,4);
    head(:,4) = bsxfun(@minus,head(:,4),headDiff);
    thorax(:,4) = bsxfun(@minus,thorax(:,4),thoraxDiff);
end
%filter tracks, NOTE that we in contrast to other analysis tools filter the
%rotation axis directly!
head(:,2:7)= [ filter3DTrace(head(:,2:4),filterChoice) filter3DTrace(head(:,5:7),filterChoice)];
thorax(:,2:7) =[  filter3DTrace(thorax(:,2:4),filterChoice) filter3DTrace(thorax(:,5:7),filterChoice)];

    

% write out python script
% open file dialoge
fidr = fopen(spos,'w');

% write out header
fprintf(fidr,'%s\n','import bpy	#die blender-api');
fprintf(fidr,'\n');

%write out thorax
fprintf(fidr,'%s','thorax_trans_list = [');
SR_writeOutData(fidr,thorax(:,2:4));
fprintf(fidr,'%s\n',']	#Translation-Daten');

fprintf(fidr,'%s','thorax_rot_list = [');
SR_writeOutData(fidr,thorax(:,5:7));
fprintf(fidr,'%s\n',']	#Rotation-Daten');

%write out head
fprintf(fidr,'%s','head_trans_list = [');
SR_writeOutData(fidr,head(:,2:4));
fprintf(fidr,'%s\n',']	#Translation-Daten');

fprintf(fidr,'%s','head_rot_list = [');
SR_writeOutData(fidr,head(:,5:7));
fprintf(fidr,'%s\n',']	#Rotation-Daten');

% write out script rest
fprintf(fidr,'%s\n',' ');
fprintf(fidr,'%s\n','thorax_obj = bpy.data.objects["Thorax"]		# Objektbezeichner ist hardcoded, das Thorax-3D-Modell muss in blender "Thorax" heissen');
fprintf(fidr,'%s\n','head_obj = bpy.data.objects["Head"]		#wie Thorax, Kopfmodell muss "Head" heissen');
fprintf(fidr,'%s\n',' ');
fprintf(fidr,'%s\n','for i in range(len(thorax_trans_list)):');
fprintf(fidr,'%s\n','    thorax_obj.location = thorax_trans_list[i]				#location des Thorax-Modells wird gesetzt');
fprintf(fidr,'%s\n','    thorax_obj.location[1] = thorax_obj.location[1] * -1				# y translation invertieren ');
fprintf(fidr,'%s\n','    thorax_obj.location[2] = thorax_obj.location[2] * -1				#z translation invertieren ');
fprintf(fidr,'%s\n','    thorax_obj.rotation_euler = thorax_rot_list[i]			#rotation des Thorax-Modells wird gesetzt');
fprintf(fidr,'%s\n','    thorax_obj.rotation_euler[1] = thorax_obj.rotation_euler[1] * -1				#rotation invertieren ');
fprintf(fidr,'%s\n','    thorax_obj.rotation_euler[2] = thorax_obj.rotation_euler[2] * -1				#rotation invertieren ');
fprintf(fidr,'%s\n','    thorax_obj.keyframe_insert(data_path="rotation_euler", frame=i)	#keyframe für rotation wird erzeugt (würde sonst nur bis zur nächsten Änderung erhalten bleiben)');
fprintf(fidr,'%s\n','    thorax_obj.keyframe_insert(data_path="location", frame=i)         	#keyframe für location wird erzeugt');
fprintf(fidr,'%s\n',' ');
fprintf(fidr,'%s\n','for i in range(len(head_trans_list)):');
fprintf(fidr,'%s\n','    head_obj.location = head_trans_list[i]				#location des Kopf-Modells wird gesetzt ');
fprintf(fidr,'%s\n','    head_obj.location[1] = head_obj.location[1] * -1				# y translation invertieren ');
fprintf(fidr,'%s\n','    head_obj.location[2] = head_obj.location[2] * -1				#z translation invertieren ');
fprintf(fidr,'%s\n','    head_obj.rotation_euler = head_rot_list[i]				#rotation des Kopf-Modells wird gesetzt ');
fprintf(fidr,'%s\n','    head_obj.rotation_euler[1] = head_obj.rotation_euler[1] * -1				#rotation invertieren ');
fprintf(fidr,'%s\n','    head_obj.rotation_euler[2] = head_obj.rotation_euler[2] * -1				#rotation invertieren ');
fprintf(fidr,'%s\n','    head_obj.keyframe_insert(data_path="rotation_euler", frame=i)	#keyframe für rotation wird erzeugt (würde sonst nur bis zur nächsten Änderung erhalten bleiben) ');
fprintf(fidr,'%s\n','    head_obj.keyframe_insert(data_path="location", frame=i)         	#keyframe für location wird erzeugt');
fprintf(fidr,'%s\n',' ');
end

function SR_writeOutData(fidr,data)
% sub function that writes out the coordinates as intended by the python
% script
% fidr is the file Identifier data is either the translatory or the
% rotational coordinates.
for i =1:size(data,1)-1,
    fprintf(fidr,'[%5.10f, %5.10f, %5.10f],',data(i,:));
end
fprintf(fidr,'[%5.10f, %5.10f, %5.10f]',data(i,:));
end