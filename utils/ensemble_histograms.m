function ensemble_histograms(ENS,stimlist)
% ensemble_histograms(ENS,stimlist) - visualizes stimuli dominance in each
% ensemble detected by SVD
%
%   INPUTS:
%       ENS - ensemble struct
%       stimlist (optional) - stimuli id list
%
%part of ZENITH

if nargin < 2
    stimlist = [0:45:315,666,999];
end
F = figure;
set(F,'units', 'normalized', 'position', [0.0995 0.0954 0.81 0.75])

N = numel(ENS);
AX2 = autoaxes(F,2,ceil(N/2),[0.05 0.025 0.05 0.05],[0.025,0.05]);
for in = 1:N
    M(in) = sum(ENS(in).samps_stimid == mode(ENS(in).samps_stimid));
end

for in = 1:N
    final_counts = zeros(size(stimlist));
%     [h_counts, h_units] = hist(ENS(in).samps_stimid,unique(ENS(in).samps_stimid));
    h_units = unique(ENS(in).samps_stimid);
    a = ENS(in).samps_stimid;
    c = arrayfun(@(x)length(find(a == x)), unique(a), 'Uniform', false);
    h_counts = cell2mat(c);
    final_counts(ismember(stimlist,h_units)) = h_counts;
    stimlist(stimlist==999) = -45;
    stimlist(stimlist==666) = 360;
    axes(AX2(in));
    
    bar(stimlist, final_counts);
    title(['component ',num2str(in)]);
    ylim([0 max(M)]);
    stimlist(stimlist==-45) = 999;
    stimlist(stimlist==360) = 666;
end