function [thr, SMAP, SMAP_shuffled] = similaritythreshold(M, fitype, pval, toplot)
% [thr, SMAP, SMAP_shuffled] = similaritiesthreshold(m, fitype, pval, toplot) 
%
%
%
%   INPUTS:
%       m -
%       fitype - 
%       pval -
%       toplot - 
%
%   OUTPUTS:
%       thr -      
%       SMAP - 
%       SMAP_shuffled - 
%
%See also tfifd, temporal_vectors_durstim
%Part of ZENITH source

if nargin < 4
    toplot = 0;
end
if nargin < 3
    pval = 0.05;
end
if nargin < 2
    fitype = 'Normal';
end

sh = shuffle_time_frames(M);
SMAP = similaritymaps(M);
SMAP_shuffled = similaritymaps(sh);

pd = fitdist(SMAP(:), fitype);
pd_sh = fitdist(SMAP_shuffled(:), fitype);
thr = icdf(pd_sh, 1-pval);

if toplot


end
