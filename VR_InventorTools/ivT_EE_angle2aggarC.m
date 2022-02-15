function aggar = ivT_EE_angle2aggarC(theta,concentration,varargin)

for i =1:length(varargin),
    if strcmp(varargin{i},'standard')
        concentration = [0.2 5 1 3 1.5 0.5 2 0.7];
    elseif strcmp(varargin{i},'standard_mirrored')
        concentration = [0.7 2 0.5 1.5 3 1 5 0.2];
    elseif strcmp(varargin{i},'standard_180')
        concentration = [1.5 0.5 2 0.7 0.2 5 1 3];
    else
        warning('varargin not recognised')
    end
end


aggar = theta;
aggar(theta <= pi/2      & theta >pi/4)      = concentration(1);
aggar(theta<= pi/4       &  theta>0)         = concentration(2);
aggar(theta <= 0         & theta >pi/-4)     = concentration(3);
aggar(theta <= pi/-4     & theta >pi/-2)     = concentration(4);
aggar(theta <= pi/-2     & theta >pi*-0.75)  = concentration(5);
aggar(theta <= pi*-0.75  &  theta>-pi)       = concentration(6);
aggar(theta <= pi        &  theta> pi*0.75)  = concentration(7);
aggar(theta <= pi*0.75   &  theta> pi/2)     = concentration(8);