function [hL,hA]=ET_plot_addEllipse(traceResult,colorMap,Nb,axisH,cbFlag,numberFlag)
% This function of the Ethotrack plot toolbox (ET_plot_) add the ellipses 
% and the animals orientation to a plot, most likely a presentation of the
% corresponding frame. The ellipse is plotted and the angle as a line from
% the center of the ellipse to its tip. The number of the animals is
% plotted to the upper right corner.
% %
% GETS:
%   traceResult = a mx13 matrix where m is the number of found animals,
%                 columns are defined as follows:
%                 col  1: x-position in pixel
%                 col  2: y-position in pixel
%                 col  3: major axis length of the fitted ellipse
%                 col  4: minor axis length of the fitted ellipse
%                 col  5: ellipse angle in degree
%                 col  6: quality of the fit
%                 col  7: number of animals believed in their after final
%                         evaluation
%                 col  8: number of animals in the ellipse according to
%                         surface area
%                 col  9: number of animals in the ellipse according to
%                         contour length
%                 col 10: is the animal close to an animal previously traced 
%                         (1 == yes)
%                 col 11: evaluation weighted mean
%                 col 12: detection quality [aU] if
%                 col 13: correction index, 1 if the area had to be
%                         corrected automatically
%      colormap = 'string' with the colormap name or mx3 color matrix
%            Nb = number of points drawn in ellipse
%         axisH = parent axis handle
%        cbFlag = boolean, if set to 1 a colorbar is plotted next to the
%                 plot
%    numberFlag = boolean, if set to 1 the animal ID number is plotted
%
% RETURNS:
%            hL = handle of the ellipses
%            hA = handle of the angle line
%
% SYNTAX: [hL,hA]=ET_plot_addEllipse(traceResult,colorMap,Nb,axisH,cbFlag,numberFlag)
%
% Author: B. Geurten 11-30-15
%
% NOTE: This function is based on the ellipse function of D.G. Long, 
% Brigham Young University, based on the CIRCLES.m original 
% written by Peter Blattner, Institute of Microtechnology, University of 
% Neuchatel, Switzerland, blattner@imt.unine.ch
%
%
% see also  ET_plot_SRellipse

freezeColors
%colormap
if isstr(colorMap)
    qual = round(traceResult(:,12).*100)+1;
    colorMap = eval([colorMap '(max(qual))']);
    colormap(colorMap)
else
    qual = round(traceResult(:,12).*100)+1;
    colormap(colorMap)
end

% plot ellipses
[hL,hA]=ET_plot_SRellipse(traceResult(:,3),traceResult(:,4),deg2rad(traceResult(:,5)),...
    traceResult(:,1),traceResult(:,2),[],Nb);

% adjust parent figure and color of the lines
for i=1:length(hL),
    
    set(hL(i),'Color', colorMap(qual(i),:));
    set(hL(i),'Parent', axisH);
    set(hA(i),'Color', colorMap(qual(i),:));
    set(hA(i),'Parent', axisH);
    if numberFlag ==1,
        text(traceResult(i,1)+traceResult(i,3)+1,traceResult(i,2)-traceResult(i,3)+1,...
            num2str(i),'Color',colorMap(qual(i),:),'FontSize',15,'Parent',axisH)
    end
end
% colorbar for detectoion quality
if cbFlag ==1,
    hCB = colorbar();
    
    newYTL = linspace(0,max(traceResult(:,12)),5)';
    newYTL = num2cell(newYTL);
    newYTL = cellfun(@(x) num2str(x,'%2.2f'), newYTL,'UniformOutput',false);
    set(hCB,'YTick',linspace(0,255,5))
    set(hCB,'YTickLabel',newYTL)
    ylabel(hCB,'detection quality [aU]')
end
end

function [hL,hA]=ET_plot_SRellipse(ra,rb,ang,x0,y0,C,Nb)
% Ellipse adds ellipses to the current plot
%
% ELLIPSE(ra,rb,ang,x0,y0) adds an ellipse with semimajor axis of ra,
% a semimajor axis of radius rb, a semimajor axis of ang, centered at
% the point x0,y0.
%
% The length of ra, rb, and ang should be the same. 
% If ra is a vector of length L and x0,y0 scalars, L ellipses
% are added at point x0,y0.
% If ra is a scalar and x0,y0 vectors of length M, M ellipse are with the same 
% radii are added at the points x0,y0.
% If ra, x0, y0 are vectors of the same length L=M, M ellipses are added.
% If ra is a vector of length L and x0, y0 are  vectors of length
% M~=L, L*M ellipses are added, at each point x0,y0, L ellipses of radius ra.
%
% ELLIPSE(ra,rb,ang,x0,y0,C)
% adds ellipses of color C. C may be a string ('r','b',...) or the RGB value. 
% If no color is specified, it makes automatic use of the colors specified by 
% the axes ColorOrder property. For several circles C may be a vector.
%
% ELLIPSE(ra,rb,ang,x0,y0,C,Nb), Nb specifies the number of points
% used to draw the ellipse. The default value is 300. Nb may be used
% for each ellipse individually.
%
% h=ELLIPSE(...) returns the handles to the ellipses.
%
% as a sample of how ellipse works, the following produces a red ellipse
% tipped up at a 45 deg axis from the x axis
% ellipse(1,2,pi/8,1,1,'r')
%
% note that if ra=rb, ELLIPSE plots a circle
%
%
% written by D.G. Long, Brigham Young University, based on the
% CIRCLES.m original 
% written by Peter Blattner, Institute of Microtechnology, University of 
% Neuchatel, Switzerland, blattner@imt.unine.ch


% Check the number of input arguments 

if nargin<1,
  ra=[];
end;
if nargin<2,
  rb=[];
end;
if nargin<3,
  ang=[];
end;

%if nargin==1,
%  error('Not enough arguments');
%end;

if nargin<5,
  x0=[];
  y0=[];
end;
 
if nargin<6,
  C=[];
end

if nargin<7,
  Nb=[];
end

% set up the default values

if isempty(ra),ra=1;end;
if isempty(rb),rb=1;end;
if isempty(ang),ang=0;end;
if isempty(x0),x0=0;end;
if isempty(y0),y0=0;end;
if isempty(Nb),Nb=300;end;
if isempty(C),C=get(gca,'colororder');end;

% work on the variable sizes

x0=x0(:);
y0=y0(:);
ra=ra(:);
rb=rb(:);
ang=ang(:);
Nb=Nb(:);

if isstr(C),C=C(:);end;

if length(ra)~=length(rb),
  error('length(ra)~=length(rb)');
end;
if length(x0)~=length(y0),
  error('length(x0)~=length(y0)');
end;

% how many inscribed elllipses are plotted

if length(ra)~=length(x0)
  maxk=length(ra)*length(x0);
else
  maxk=length(ra);
end;

% drawing loop

for k=1:maxk
  
  if length(x0)==1
    xpos=x0;
    ypos=y0;
    radm=ra(k);
    radn=rb(k);
    if length(ang)==1
      an=ang;
    else
      an=ang(k);
    end;
  elseif length(ra)==1
    xpos=x0(k);
    ypos=y0(k);
    radm=ra;
    radn=rb;
    an=ang;
  elseif length(x0)==length(ra)
    xpos=x0(k);
    ypos=y0(k);
    radm=ra(k);
    radn=rb(k);
    an=ang(k);
  else
    rada=ra(fix((k-1)/size(x0,1))+1);
    radb=rb(fix((k-1)/size(x0,1))+1);
    an=ang(fix((k-1)/size(x0,1))+1);
    xpos=x0(rem(k-1,size(x0,1))+1);
    ypos=y0(rem(k-1,size(y0,1))+1);
  end;

  co=cos(an);
  si=sin(an);
  the=linspace(0,2*pi,Nb(rem(k-1,size(Nb,1))+1,:)+1);
%  x=radm*cos(the)*co-si*radn*sin(the)+xpos;
%  y=radm*cos(the)*si+co*radn*sin(the)+ypos;
  hL(k)=line(radm*cos(the)*co-si*radn*sin(the)+xpos,radm*cos(the)*si+co*radn*sin(the)+ypos);
  arrowX = [xpos xpos+ra(k)*cos(an)];
  arrowY = [ypos ypos+ra(k)*sin(an)];
  hA(k) = line(arrowX,arrowY);
  %[figx, figy] = dsxy2figxy(gca, arrowX, arrowY);
  %hA(k)=annotation('arrow',figx,figy);
  
  switch C(k),
      case 1
          co = 'c';
      case 0
          co = 'g';
      case -1
          co = 'r';
  end
  
%  set(h(k),'color',co(rem(k-1,size(co,1))+1,:));

end
end