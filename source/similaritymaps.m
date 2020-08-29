function [SMAP, svec, cvec, COMAP, scmap] = similaritymaps(TFIDF)
% [SMAP, svec, cvec, COMAP, scmap] = similaritymaps(TFIDF) - calculates 
% the similarity indices between all possible vector pairs taken from
% the tf*idf normalized matrix
%
%   INPUTS
%       TFIDF - matrix containing tf*idf normalized significant vectors
%
%   OUTPUTS
%       SMAP - similarity map containing the upper triangle of similarity
%               indices
%       svec - vector containing similarity indices
%       cvev - vecotor containing maximum value of coactive cell numbers
%       COMAP - max cocell number map
%       scmap - cell array of similarity rows
%
%Part of ZENITH source

sn = size(TFIDF,2);
smap = zeros(sn);
if nargout == 4
    cmap = zeros(sn);
end
count = 1;
for ivec = 1:sn-1
    a = TFIDF(:,ivec); % reference vector
    bn = ivec+1:sn;
    for n = bn
        b = TFIDF(:,n); % pair vector
        [si] = norminprod(a,b); %sim index + inner prod
        co = sum(all([a,b],2));
        cvec(count) = co; %because mx is not binary, else inprod would be ok
        svec(count) = si;
        smap(ivec,n) = si;
        if nargout == 4
            cmap(ivec,n) = co;
        end
        count = count + 1;
    end
end
SMAP = smap' + smap;
SMAP(1:size(SMAP,1)+1:end) = diag(smap);

if nargout == 4
    COMAP = cmap' + cmap;
    COMAP(1:size(COMAP,1)+1:end) = diag(cmap);
end
if nargout == 5
    for irun = 1:sn-1
        c = irun + 1;
        scmap{irun} = smap(irun,c:sn); 
    end
end