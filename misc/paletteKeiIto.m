function cmapIto = paletteKeiIto(idx)
% This function returns Kei Itos pallette for colorblind people in 0->1 rgb. It
% returns 8 differentiatable colors for Protan Deutan and Tritan colorblind
% persons. The Colors are:
%           No   Name            RGB [0->1]       CMYK [%]
%            1   black              0    0    0     0   0   0 100
%            2   orange          0.9   0.6    0     0  50 100   0
%            3   sky blue        0.35  0.7  0.9    80   0   0   0
%            4   bluish green       0  0.6  0.5    97   0  75   0
%            5   yellow          0.95  0.9 0.25    10   5  90   0
%            6   blue               0 0.45  0.7   100  50   0   0
%            7   vermillion       0.8  0.4    0     0  80 100   0
%            8   reddish purple   0.8  0.6  0.7    10  70   0   0
%
% GETS
%      idx = vector of cardinals; This vector will be used as indices on 
%            the color matrix, so if you only want sky blue, vermillion and 
%            orange and in this sequence set idx to be idx = [3 7  2];
%            If idx is  empty or not set, all colors will be returned.
%
% RETURNS
%  cmapIto = a mx3 matrix where m is the length of idx, or if idx is unset
%            or empty an 8x3 matrix. The colors are in rgb scaled 0 to 1,
%
% SYNTAX:cmapIto = paletteKeiIto(idx);
%
% Author: B. Geurten 18.07.14
%
% see also http://jfly.iam.u-tokyo.ac.jp/color/
        
 
if exist('idx','var')
    if isempty(idx),
        idx = 1:8;
    end
else
    idx =1:8;
end

% for idx over 8
idx=mod(idx,8);
idx(idx == 0) = 8;


cmapIto = [0 0 0; 90 60 0; 35 70 90; 0 60 50; 95 90 25; 0 45 75; 80 40 0; 80 60 70]./100;
cmapIto = cmapIto(idx,:);
end