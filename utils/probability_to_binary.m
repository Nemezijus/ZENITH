function B = probability_to_binary(M, thr)
% B = probability_to_binary(M, thr) - converts spike probability matrix to
% thresholded binary spike matrix.
%
%   INPUTS:
%       M - matrix (or vector) containing spiking probabilities. One row - one repetition
%       thr - threshold criteria in standard deviations. Default 3 (3*sd).
%   OUTPUTS:
%       B - binary matrix containing putative spiking events. Same size as M
%
%see also export_spikes_woopsi
%Part of ZENITH source


if nargin < 2
    thr = 3;
end

M_size = size(M);
B = zeros(M_size);
for im = 1:M_size(1)
    Msd = std(M(im,:));
    sd_thr = thr.*Msd;
    B(im,M(im,:)>sd_thr) = 1;
end