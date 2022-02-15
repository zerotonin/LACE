function deltaFbyF =  FILA_ana_lumSeq2deltaFbyF(lumSeq,base)
f = reshape_2Dto3D(lumSeq(base,:,:));
%f0 = prctile(f,25,1);
deltaFbyF =f;
%deltaFbyF = bsxfun(@rdivide,bsxfun(@minus,f,f0),f0);