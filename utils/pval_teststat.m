function [pval_thr] = pval_teststat(SYNC_shuffled, pval)
% p_thr = pval_teststat(sync_real, sync_shuffled) - counts the p value from
% the propotion of shuffled and real data
%
%   INPUTS:
%       SYNC_shuffled - synchronization matrix of shuffled B
%       pval - p-value as a significance level
%
%   OUTPUTS:
%       pval - p-value corresponding cutoff threshold
%       
%
%Part of ZENITH utils

if nargin < 2
    pval = 0.01;
end

shuffled_max = max(SYNC_shuffled, [], 2);
[h_counts, h_ranges] = histcounts(shuffled_max,numel(unique(shuffled_max))); 
h_max = floor(max(h_ranges));
pval_thr = round(h_max - h_max*pval); % requires refactorization later on
