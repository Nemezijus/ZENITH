function S = shuffled_data_processing(SH, SYNC_SH, Pcutoff, PAR)
% S = shuffled_data_processing(SH, SYNC_SH, Pcutoff, PAR) - performs synchronization
% and similarity steps of data on the shuffled data
%
%   INPUTS:
%       SH - shuffled matrix
%       SYNC_SH - synchronization curves of shuffled data
%       Pcutoff - the cutoff value for significant synchronizations
%       PAR - parameter struct
%
%   OUTPUT:
%       S - struct with results from the analysis
%
%part of ZENITH


Nsh = PAR.Nshuffle;

for ishuffle = 1:Nsh
    cSH = SH(ishuffle,:,:);
    cSYNC = SYNC_SH(ishuffle,:);
    [TV, TVred, samples] = temporal_vectors(cSH, cSYNC, Pcutoff, PAR);
end

