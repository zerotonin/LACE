function area = ET_im_polygonArea(imageHeight,imageWidth,polygonV)

[pixX,pixY] =find( ones(size(imageHeight,imageWidth)));
area =sum(inpolygon(pixX,pixY,polygonV(:,1),polygonV(:,2)));