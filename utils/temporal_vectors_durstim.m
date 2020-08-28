function [unistim_cellpools, TV, TVstim, STIMSAMP] = temporal_vectors_durstim(B, samples, STIMSAMP, slist)
% [[unistim_cellpools, TV, TVstim, STIMSAMP] = temporal_vectors_durstim(B, samples, STIMSAMP, slist) - 
% in the first place creates a reduced binary matrix where each column represents time point and
% every row whether the ROI is coactive or not - 1 or 0 -
%
%   INPUTS:
%       B - original binary matrix
%       samples - time sample indices that contain significant syncronizations
%       STIMSAMP - struct containing info about stim on- and offsets and
%                   the lenght of the bigger (full_xl) and base (full_s) 
%                   time vectors
%       slist - stimulus list vector defining the original order of stimuli
%               during measurement
%
%   OUTPUTS:
%       unistim_cellpools - struct containing the info about coactive cells
%                           during stimuli
%       TV - Temporal Vector matrix
%       TVstim - Temporal Vector matrix, reduced to during stim times only
%       STIMSAMP - struct containg info helping in retracing significant
%                   temporal vectors
%
%part of ZENITH

ons = STIMSAMP.stim_on:STIMSAMP.full_s:STIMSAMP.full_xl;
offs = STIMSAMP.stim_off:STIMSAMP.full_s:STIMSAMP.full_xl;

samples_orig = []; samples_stim_num = [];
for m = 1:numel(samples)
    for n = 1:numel(ons)
        if samples(m) >= ons(n) && samples(m) <= offs(n)
            samples_orig = [samples_orig, samples(m)];
            samples_stim_num = [samples_stim_num, n];
            break
        end
    end
end
STIMSAMP.samps_orig = samples_orig;
STIMSAMP.samps_stimid = samples_stim_num;

TV = zeros(size(B));
TV(:,samples_orig) = B(:,samples_orig);
TVstim = B(:,samples_orig);

coact_cells = {};
cells = 1:size(B,1);
signif_vectors = 1:size(TVstim, 2);
for ivec = 1:size(TVstim, 2)
    cocell_mask = logical(TVstim(:,ivec));
    coact_cells{1,ivec} = cells(cocell_mask);
    coact_cells{2,ivec} = samples_stim_num(ivec);
end
% Create struct of coactive cell pools per stimuli window
unistims = unique(samples_stim_num);
if numel(unistims)
    unistim_cellpools(1).stim_num = unistims(1);
    unistim_cellpools(1).stim_id = slist(unistims(1));
    unistim_cellpools(1).coactive_cells = unique([coact_cells{1,:}]);
else
    dunistims = (diff([coact_cells{2,:}]) > 0);
    dunistims(end+1) = 0;
    stim_shift_idx = signif_vectors(logical(dunistims))+1;
    unistim_cellpools(1).stim_num = unistims(1);
    unistim_cellpools(1).stim_id = slist(unistims(1));
    unistim_cellpools(1).coactive_cells = unique([coact_cells{1,1:stim_shift_idx(1)-1}]);
    for n = 2:numel(stim_shift_idx)
        unistim_cellpools(n).stim_num = unistims(n);
        unistim_cellpools(n).stim_id = slist(unistims(n));
        if n == numel(stim_shift_idx)
            unistim_cellpools(n).coactive_cells = unique([coact_cells{1,stim_shift_idx(n):end}]);
            break
        end
        unistim_cellpools(n).coactive_cells = unique([coact_cells{1,stim_shift_idx(n):stim_shift_idx(n+1)-1}]);
    end
end
