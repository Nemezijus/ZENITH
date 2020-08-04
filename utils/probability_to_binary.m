function B = probability_to_binary(M, thr, normalize)
% B = probability_to_binary(M, thr, normalize) - converts spike probability matrix to
% thresholded binary spike matrix.
%
%   INPUTS:
%       M - matrix (or vector) containing spiking probabilities. One row - one repetition
%       thr - threshold criteria in standard deviations. Default 3 (3*sd).
%       normalize - (1 or 0) whether to normalize probabilities within each
%           row; (default - 0)
%   OUTPUTS:
%       B - binary matrix containing putative spiking events. Same size as M
%
%see also export_spikes_woopsi
%Part of ZENITH source

if nargin < 3
    normalize = 0;
end
if nargin < 2
    thr = 3;
end
if normalize
    M = M./(max(M,[],2));
end

M_size = size(M);
B = zeros(M_size);
Msd = std2(M);%for the whole matrix
sd_thr = thr.*Msd;
for im = 1:M_size(1)
    Msd = std(M(im,:));
%     mm(im) = Msd;
%     sd_thr = thr.*Msd;
    B(im,M(im,:)>sd_thr) = 1;
end