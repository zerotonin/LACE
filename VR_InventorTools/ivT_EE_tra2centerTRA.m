function traceC = ivT_EE_tra2centerTRA(trace,centers)

traceC = bsxfun(@minus,trace,reshape(centers',[1 2 size(trace,3)]));

% as image coordiantes have a flipped y axis
traceC(:,2,:) = traceC(:,2,:).*-1;