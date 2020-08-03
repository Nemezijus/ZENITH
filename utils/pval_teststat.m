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
%Part of ZENITH utils

if nargin < 2
    pval = 0.01;
end

shuffled_max = max(SYNC_shuffled, [], 2);
[h_counts, h_units] = hist(shuffled_max,unique(shuffled_max)); 
subs = sum(h_counts)*pval;
for n=numel(h_counts):-1:1
    if subs>=h_counts(n)
        subs = subs-h_counts(n);
        continue
    end
    pval_thr = h_units(n);
    break
end
