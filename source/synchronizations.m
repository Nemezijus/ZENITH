function [SYNC, Pcutoff, B, SYNC_shuffled, SH] = synchronizations(M,PAR,fig)
% [SYNC, Pcutoff] = synchronizations(M,PAR) - coagulates analysis
% methods to convert spiking probability matrix M into Synchornization
% vector and significance threshold
%
%   INPUTS:
%       M - spiking probability matrix. One row - one ROI
%       PAR - parameter struct
%           treat_artifacts = 1/0 whether do artifact treatment (default 0)
%           nstart - if treating artifacts, how many starting samples to
%                   set to zero
%           Nrecs - how many recordings are in one M row
%           sd_thr - standard deviation multiplication factor for
%                   binarization of the matric M
%           Nshuffle - how many random shuffles to perform
%           rule - shuffling rule
%           samp_window - window size in samples for synchronization count
%           pval - statistical significance threshold (recommended - 0.01)
%           normalize - wheteher to normalize spike probabilities within
%                   each row
%
%   OUTPUTS:
%       SYNC - synchronization vector of real data M
%       Pcutoff - number of synchronizations threshold below which
%               synchronizations happen by chance
%       B - the binary spike matrix
%       SH - N dimensional matrix of data shuffles
%
%part of ZENITH
if nargin < 3
    fig = [];
end
if nargin < 2
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','SYNC_PARS.mat'},'\');
    load(PARloc);
end
if PAR.treat_artifacts
    sz = size(M);
    period = sz(2)./PAR.Nrecs;
    if mod(period,1) ~= 0
        error('Incorrect number of recordings. Period is not integer.')
    end
    M = treat_artifacts(M, PAR.nstart, period);
end
% B = probability_to_binary(M, PAR.sd_thr, PAR.normalize);
B = discreet_to_binary(M);

[SYNC, SYNC_shuffled] = ROI_synchrony(B, PAR.Nshuffle, PAR.rule, PAR.samp_window, PAR.Fs);

% Pcutoff = gauss_fit_on_shuffles(SYNC_shuffled, PAR.pval, 1); %old method
Pcutoff = coactivity_threshold(SYNC_shuffled, max(SYNC), PAR.pval, 1, fig);
% Pcutoff = pval_teststat(SYNC_shuffled, PAR.pval);