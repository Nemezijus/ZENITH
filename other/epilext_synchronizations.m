function [SYNC, Pcutoff, B, SYNC_shuffled, SH] = epilext_synchronizations(B,PAR)
% [SYNC, Pcutoff] = synchronizations(M,PAR) - coagulates analysis
% methods to convert spiking probability matrix M into Synchornization
% vector and significance threshold
%
%   INPUTS:
%       B - the binary spike matrix; One row - one ROI
%       PAR - parameter struct
%               treat_artifacts = 1/0 whether do artifact treatment (default 0)
%               nstart - if treating artifacts, how many starting samples to
%                        set to zero
%               Nrecs - how many recordings are in one M row
%               sd_thr - standard deviation multiplication factor for
%                        binarization of the matric M
%               Nshuffle - how many random shuffles to perform
%               rule - shuffling rule
%               samp_window - window size in samples for synchronization count
%               pval - statistical significance threshold (recommended - 0.01)
%               normalize - wheteher to normalize spike probabilities within
%                           each row
%
%   OUTPUTS:
%       SYNC - synchronization vector of real data B
%       Pcutoff - number of synchronizations threshold below which
%               synchronizations happen by chance
%       B - the binary spike matrix
%       SH - N dimensional matrix of data shuffles
%
%part of ZENITH\other

if nargin < 2
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','SYNC_PARS.mat'},'\');
    load(PARloc);
end

[SYNC, SYNC_shuffled] = ROI_synchrony(B, PAR.Nshuffle, PAR.rule, PAR.samp_window);

%-- Calculate the % of coactive cells
nRois = size(B,1);
SYNC = SYNC ./ nRois;
SYNC_shuffled = SYNC_shuffled ./ nRois;

Pcutoff = gauss_fit_on_shuffles(SYNC_shuffled, PAR.pval, 1);