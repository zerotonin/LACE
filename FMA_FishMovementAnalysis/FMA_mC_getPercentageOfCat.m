function percentage= FMA_mC_getPercentageOfCat(idx)
 
% calculate percentage
percentage = [sum(idx ==1) sum(idx == 2) sum(idx ==3)]./(length(idx)).*100;