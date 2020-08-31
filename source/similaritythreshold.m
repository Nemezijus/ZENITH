function [thr, SMAP_real, COMAP_real] = similaritythreshold(M, Nshuff, prc, toplot)
% [thr, SMAP, SMAP_shuffled] = similaritythreshold(M, Nshuff, prc, toplot)
% - calculates the significance threshold based on the similarity
% coefficients and optionally plots probability distributions of similarities
%
%   INPUTS:
%       M - matrix with not only binary values (so far: TFIDF mx)
%       Nshuff - double defining the number of times to shuffle real data
%               (given as PAR.Nshuffle as input)
%       prc - double defining the number of percentile
%       toplot - binary defining to plot or not to plot
%
%   OUTPUTS:
%       thr - double defininf cutoff value of significance     
%       SMAP - matrix of the similarity map for real data
%
%See also tfifd, temporal_vectors_durstim
%Part of ZENITH source

if nargin < 4
    toplot = 0;
end
if nargin < 3
    prc = 5;
end
if nargin < 2
    Nshuff = 1000;
end

max_nco = zeros(Nshuff, 1);
hb = waitbar(0,'Shuffling, please wait!');
for n = 1:Nshuff
    waitbar(n/Nshuff);
    sh = shuffle_time_frames(M);
%     [~, ~, cv_] = similaritymaps(sh);
    [~, ~, ~, cv_] = simmap(sh);
    max_cv_ = max(cv_);
    max_nco(n) = max_cv_; 
end
close(hb);

thr = prctile(max_nco, prc);
% SMAP_shuffled = similaritymaps(sh);
SMAP_shuffled = simmap(sh);
% [SMAP_real, sv_real, cv_real, COMAP_real] = similaritymaps(M);
[SMAP_real, COMAP_real, sv_real, cv_real] = simmap(M);

if toplot
    f = figure;
    set(f, 'units', 'normalized', 'position', [0.174 0.406 0.643 0.354]);
    AX_l = createAXES(f, 2, 2, [0 0.3 0 0]);
    AX_r = createAXES(f, 1, 1, [0.7 0 0 0]);
    
    axes(AX_l(1,1))
    imagesc(SMAP_real);
    AX_l(1,1).Title.String = 'Similarity map of real data';
    
    axes(AX_l(2,1))
    imagesc(SMAP_shuffled);
    AX_l(2,1).Title.String = 'Similarity map of shuffled data';
    
    axes(AX_l(1,2))
    histfit(SMAP_real(:), numel(unique(SMAP_real(:))));
    ylim([0 20]);
    AX_l(1,2).Title.String = 'Histogram with gaussian fitting of real data';
    
    axes(AX_l(2,2))
    histfit(SMAP_shuffled(:), numel(unique(SMAP_shuffled(:))));
    ylim([0 20]);
    AX_l(2,2).Title.String = 'Histogram with gaussian fitting of shuffled data';
    
    axes(AX_r(1))
    plot(cv_real, sv_real, 'kx');
    hold on
    plot([thr thr], get(AX_r(1), 'YLim'), 'r', 'linew', 2);
    AX_r(1).Title.String = 'Probability distribution of similarity coefficients';
    
end
