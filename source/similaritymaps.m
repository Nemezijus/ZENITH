function [SMAP, svec, cvec, scmap] = similaritymaps(TFIDF)
% [] = similaritymaps(TFIDF) calculates the similarity indices between all
% possible vector pairs taken from the tf*idf normalized matrix
%
%   INPUTS
%       TFIDF - matrix containing tf*idf normalized significant vectors
%
%   OUTPUTS
%       SMAP - similarity map containing the upper triangle of similarity
%               indices
%       scmap - cell array of similarity rows
%
%Part of ZENITH


sn = size(TFIDF,2);
smap = zeros(sn);
count = 1;

for ivec = 1:sn-1
    a = TFIDF(:,ivec); % reference vector
    bn = ivec+1:sn;
    for n = bn
        b = TFIDF(:,n); % pair vector
        [si] = norminprod(a,b); %sim index + inner prod
        cvec(count) = sum(all([a,b],2)); %because mx is not binary, else inprod would be ok
        svec(count) = si;
        smap(ivec,n) = si;
        count = count + 1;
    end
end

SMAP = smap' + smap;
SMAP(1:size(SMAP,1)+1:end) = diag(smap);

if nargout == 4
    for irun = 1:sn-1
        c = irun + 1;
        scmap{irun} = smap(irun,c:sn); 
    end
end