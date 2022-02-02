function strainsCell = ET_SR_getStandardStrains()
% This function returns a mx2 cell string matrix where each row holds the
% name of the standard Drosophila strains used in our temperature sensation
% experiments. The first column holds the long name in LaTex code the
% second column the short code. Col(1) can be used for legends and plots.
% Col(2) is more used for statistics.
%
% GETS: nothing
%
% RETURNS:
%  strainsCell = mx2 cell string matrix col(1) long name in LaTex col(2)
%                short name
%
% SYNTAX strainCell = TMP_getStandardStrains;
%
% AUTHOR: B.Geurten 8.5.14
%
% see also why

strainsCell = {'Strain Name','N/A';...
               'CantonS','canS';...
               'Dachshund','dachs';...
               'ort','ort';...
               'sol_homo','sol';...
               'zmyndDork','zDork';...
               'OregonR_dark', 'OR_dark';...
               'MB_defect', 'MB_defect'};
end