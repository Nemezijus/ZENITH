function [thr, SMAP, SMAP_shuffled] = similaritythreshold(M, fitype, pval, toplot)
% [thr, SMAP, SMAP_shuffled] = similaritythreshold(m, fitype, pval, toplot) 
% calculates the significance threshold based on the similarity
% coefficients and optionally plots probability distributions of similarities
%
%   INPUTS:
%       M - matrix with not only binary values (so far: TFIDF mx)
%       fitype - string defining fitdist second input element (by default 'Normal')
%       pval - double defining probability value for the cutoff level
%       toplot - binary defining to plot or not to plot
%
%   OUTPUTS:
%       thr - double defininf cutoff value of significance     
%       SMAP - matrix of the similarity map for real data
%       SMAP_shuffled - matrix of the similarity map for shuffled data
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

x = 0.1:0.1:0.9;
%Real
SMAP = similaritymaps(M);
pd = fitdist(SMAP(:), fitype);
pd_real = pdf(pd, x);
%Shuffled
% h1 = histfit(SMAP(:), numel(unique(SMAP(:))));
PD_SH = [];
tic
for n = 1:1000
    sh = shuffle_time_frames(M);
    SMAP_shuffled = similaritymaps(sh);
    max_sh = max(max(SMAP_shuffled));
%     pd_sh = fitdist(SMAP_shuffled(:), fitype);
%     pd_shuffled = pdf(pd_sh, x);
%     PD_SH = [PD_SH; pd_shuffled ./ numel(pd_shuffled)];
    PD_SH = [PD_SH; max_sh];
end
toc
% PD_SH already normalized!
% m_pdsh = mean(PD_SH);
% sd_pdsh = std(PD_SH);
% err = sd_pdsh .* ones(size(x));
pd_sh = fitdist(PD_SH, fitype);
thr = icdf(pd_sh, 1-pval);

% figure;
% plot(x, log10(m_pdsh), 'ko--');
% hold on
% plot(x, log10(m_pdsh+sd_pdsh), 'k*--');
% plot(x, log10(m_pdsh-sd_pdsh), 'k*--');
% errorbar(x, log10(m_pdsh), log10(err), 'vertical','LineStyle', 'none', 'Color', 'k' );
% plot(x, log10(pd_real), 'k^-');
% pd = fitdist(SMAP(:), fitype);

% thr = icdf(m_pdsh, 1-pval);

if toplot
    f = figure;
    set(f, 'units', 'normalized', 'position', [0.174 0.406 0.643 0.354]);
    AX_l = createAXES(f, 2, 2, [0 0.3 0 0]);
    AX_r = createAXES(f, 1, 1, [0.7 0 0 0]);
    
    axes(AX_l(1,1))
    imagesc(SMAP);
%     AX_l(1,1).XLabel.String = '';
%     AX_l(1,1).YLabel.String = '';
    AX_l(1,1).Title.String = 'Similarity map of real data';
    
    axes(AX_l(2,1))
    imagesc(SMAP_shuffled);
    AX_l(2,1).Title.String = 'Similarity map of shuffled data';
    
    axes(AX_l(1,2))
    h1 = histfit(SMAP(:), numel(unique(SMAP(:))));
    ylim([0 20]);
    AX_l(1,2).Title.String = 'Histogram with gaussian fitting of real data';
    
    axes(AX_l(2,2))
    h2 = histfit(SMAP_shuffled(:), numel(unique(SMAP_shuffled(:))));
    ylim([0 20]);
    AX_l(2,2).Title.String = 'Histogram with gaussian fitting of shuffled data';
    
    axes(AX_r(1))
    x = h1(2).XData;
    pd_real = pdf(pd, x);
    pd_shuffled = pdf(pd_sh, x);
    plot(x, log10(pd_real), 'k-');
    hold on
    plot(x, log10(pd_shuffled), 'k--');
    AX_r(1).Title.String = 'Probability distribution of similarity coefficients';
    
end
