function coordsRot = FILA_SR_rotCoords(coords,rotMat)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

coordsRot = [coords zeros(size(coords,1),1)] *rotMat;
coordsRot = coordsRot(:,1:2);

end

