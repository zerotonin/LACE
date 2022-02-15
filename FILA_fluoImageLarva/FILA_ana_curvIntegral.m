function curvetureV = FILA_ana_curvIntegral(spline)
% This function of the BFT (BackLightFlyTracer) toolbox calculates the
% curvature of the larva by calculating the signed and unsingend integral
% of the spline of the larva. A high unsigned value coincident with a high
% signed value indicates a curve. A low signed value with a high unsigned
% value woulde be something like an S-shape an, a high signed value with a
% low unsigned value is mathematically impossible, whereas two low values
% indicate a straight line. The unsigned value also tells you if the animal
% moves right or left (negative left, positive right)
%
% GETS
%      spline = a mx2 matrix with the central line of the polygon, as
%               returned by FILA_ana_getSpine
%
% RETURNS
% curvetureV  = 1x2 vector: 1) unsigned integral 2) signed integral
%
% SYNTAX: curvetureV = FILA_ana_curvIntegral(spline)
%
% Author: B. Geurten Octobre 2015
%
% see also FILA_ana_getSpine

%filter
w = normpdf(0,floor(size(spline,1)/8)*-1:floor(size(spline,1)/8),3);
spline = filtfilt(w,1,spline(:,1));

% get median
medLen = round(length(spline)*.05);
mPos = median(spline([1:medLen end-medLen:end],1));

% substract median from bodylong axis to get the curveture around it
spline=spline-mPos;

%save variable
curvetureV = [sum(abs(spline(:,1))) sum(spline(:,1))];
