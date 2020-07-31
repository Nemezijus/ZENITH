function [TV, TVred, samples] = temporal_vectors(B, SYNC, Pcutoff, PAR)
% [TV, TVred, samples] = temporal_vectors(B, SYNC, Pcutoff, PAR) - creates
% temporal vector binary matrix where each column represents time point and
% every row - 1 or 0 - whether the ROI is coactive or not.
%
%   INPUTS:
%       B - binary spike matrix
%       SYNC - synchronization vector of real data
%       Pcutoff - threshold of synchronizations for a given P value
%       PAR - parameter struct
%
%   OUTPUTS:
%       TV - Temporal Vector matrix
%       TVred - Temporal Vector reduced matrix (all-0 columns eliminated)
%       samples - time sample indices that contain significant syncronizations
%
%part of ZENITH

if nargin < 4
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','SYNC_PARS.mat'},'\');
    load(PARloc);
end

logical_SYNC = SYNC >= Pcutoff;
T = 1:numel(SYNC);
samples = T(logical_SYNC);

TV = zeros(size(B));
TV(:,samples) = B(:,samples);
TVred = B(:,samples);