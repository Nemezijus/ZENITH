function [SMap, CMap, s, c] = simmap(TFIDF)
% [SMap, CMap, s, c] = simmap(TFIDF) - speeded up version of similaritymaps
% generates the similarity, and co-active cell number maps (symmetric
% matrices) which contain the similarity indices between each pairs of
% significant population vectors and the summed numbers of coactive cells
% in the paired vectors - it also returns these similarity index and
% coactive cell numbers (only) as vectors
%
%   INPUTS:
%       TFIDF - TF*IDF Matrix containing the normalized significant vectors
%
%   OUTPUTS:
%       SMap - Similarity Map (symmetric matrix) storing the similarity
%               indices of pairwise population vectors
%       CMap - Coactive cell Map (symmetric matrix) storing the number of
%               coactive cells of pairwise population vectors
%       s - similarity index storing vector
%       c - coactive cell count storing vector
% 
%See also similaritymaps, similaritythreshold, norminprod
%Part of ZENITH methods 

sn = size(TFIDF,2);
smap = zeros(sn);
if nargout == 2 || nargout == 3 || nargout == 4
    cmap = zeros(sn);
end
% count = 1;
for ivec = 1:sn-1
    a = TFIDF(:,ivec);
    B = TFIDF(:,ivec+1:end);
    si = norminprod(a,B, 'new'); % getting back a line
    smap(ivec,ivec+1:end) = si;
    if nargout == 2 || nargout == 3 || nargout == 4
        cllnum = sum(double(a > 0) .* double(TFIDF(:,ivec:end)>0));
        cmap(ivec,ivec:end) = cllnum;
    end
end
SMap = smap' + smap;
SMap(1:size(SMap,1)+1:end) = 1;
if nargout == 2 || nargout == 3 || nargout == 4
    CMap = cmap' + cmap;
    CMap(1:size(CMap,1)+1:end) = diag(cmap);
end

if nargout == 3 || nargout == 4
    % singular index containing vector
    SMtri = triu(SMap);
    SMtri(1:size(SMtri,1)+1:end) = 0;
    s = SMtri(SMtri > 0);
end
if nargout == 4
    % cell number containing vector
    CMtri = triu(CMap);
    CMtri(1:size(CMtri,1)+1:end) = 0;
    c = CMtri(CMtri > 0);
end
