function tra = ET_DLC_interpArtifacts(tra,IDX)
% This function of the Ethotrack deepLabCut toolbox (ET_DLC_) is specific
% for multiple animale trajectories with heads and tails. By analysing the
% euclidean distance between head and tail one can detected artifacts where
% the animal suddenly gets twice as large as the median bodylength during
% the movie. If this happens the
% GETS:
%           tra = matrix of floats; mxnxp, where m is the number of frames
%                 analysed. n is the number of coordinates and the mean of
%                 object recognition quality for all regions in this frame.
%                 p is the number of regions.
%
% RETURNS:
%           IDX = mxp matrix of bools. where m is the number of frames and
%                 p is the number of animals. The value is true if the
%                 detection is false and should be corrected.
%
% SYNTAX:  tra = ET_DLC_interpArtifacts(tra,IDX);
%
% Author: B. Geurten 09-19-19
%
% see also ET_DLC_openTra, ET_DLC_tra2HBtra
[samples,coordNum,regionNum] = size(tra);

for regI =1:regionNum
    % test if data has to be corrected
    frames2correct = sum(IDX(:,regI));
    if frames2correct ~=0
        disp (['length detection error in ' num2str(frames2correct) ' frames of region No: ' num2str(regI)])
        
        [start,stop] = getSigStartsEnds(IDX(:,regI));
        
        if start(1) == 1 && stop(end) == samples && length(start)==1,
            
            tra(:,:,regI) = NaN;
            start(1) = [];
            stop(1) = [];
            frames2correct = 0;
        end
        
        % if errors are detected at the end or the beginning of the
        % trajectory we cannot interpolate the positions so we have to take
        % the last/first correct detection and fill the trajectory with
        % that.
        
        if frames2correct ~= 0
        if start(1) == 1 
            firstCorrectDetection = stop(1)+1;
            % make template to fill the trajectory set the object Rec
            % quality to zero
            template = [tra(firstCorrectDetection,1:coordNum-1,regI) 0 ];
            tra(1:stop(1),:,regI) = repmat(template,stop(1),1);
            start(1) = [];
            stop(1) = [];
        end
        end
        
        frames2correct = length(stop);
        if frames2correct ~= 0
            if stop(end) == samples
                lastCorrectDetection = start(end)-1;
                
                % make template to fill the trajectory set the object Rec
                % quality to zero
                template = [tra(lastCorrectDetection,1:coordNum-1,regI) 0];
                tra(start(end):stop(end),:,regI) = repmat(template,stop(end)-start(end)+1,1);
                start(end) = [];
                stop(end) = [];
            end
        end
        for artI = 1:length(start)
            artDuration = stop(artI)-start(artI)+1;
            
            % make template to fill the trajectory set the object Rec
            % quality to zero
            template = NaN(artDuration,coordNum);
            for coordI =1:coordNum-1
                template(:,coordI) = linspace(tra(start(artI)-1,coordI,regI),...
                    tra(stop(artI)+1,coordI,regI),...
                    artDuration)';
            end
            template(:,end) = zeros(artDuration,1);
            
            
            tra(start(artI):stop(artI),:,regI) = template;
        end
        
        
    end
end