function [SMAP, COMAP, COMAP2] = similaritymaps(TFIDF)
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
% comap = zeros(sn);
% coomap  = zeros(sn);
for ivec = 1:sn-1
    a = TFIDF(:,ivec); % reference vector
%     a_cn = a>0;
    bn = ivec+1:sn;
    for n = bn
        b = TFIDF(:,n); % pair vector
%         b_cn = b>0;
        si = dot(a,b)/(norm(a)*norm(b));
%         coc = sum(a_cn .* b_cn);
%         cocc = sum((a_cn + b_cn) >= 1);
        smap(ivec,n) = si;
%         comap(ivec,n) = coc;
%         coomap(ivec,n) = cocc;
    end
end

SMAP = smap' + smap;
SMAP(1:size(SMAP,1)+1:end) = diag(smap);

% COMAP = comap' + comap;
% COMAP(1:size(COMAP,1)+1:end) = diag(comap);

% COMAP2 = coomap' + coomap;
% COMAP2(1:size(COMAP2,1)+1:end) = diag(coomap);

if nargout == 2
    for irun = 1:sn-1
        c = irun + 1;
        scmap{irun} = smap(irun,c:sn); 
    end
end