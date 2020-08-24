function [smap, scmap] = similaritymaps(TFIDF)
% [] = similaritymaps(TFIDF) calculates the similarity indices between all
% possible vector pairs taken from the tf*idf normalized matrix
%
%   INPUTS
%       TFIDF - matrix containing tf*idf normalized significant vectors
%
%   OUTPUTS
%       smap - similarity map containing the upper triangle of similarity
%               indices
%       scmap - cell array of similarity rows
%
%Part of ZENITH



sn = size(TFIDF,2);
smap = zeros(sn);
for ivec = 1:sn-1
    a = TFIDF(:,ivec);
    bn = ivec+1:sn;
    for n = bn
        b = TFIDF(:,n);
        si = dot(a,b)/(norm(a)*norm(b));
        smap(ivec,n) = si;
    end
end

if nargout == 2
    for irun = 1:sn-1
        c = irun + 1;
        scmap{irun} = smap(irun,c:sn); 
    end
end