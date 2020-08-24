function [unistim_cellpools, TV, TVstim, STIMSAMP] = temporal_vectors_durstim(B, samples, STIMSAMP, slist)
% [TVstim] = temporal_vectors_durstim() - creates
% temporal vector binary matrix where each column represents time point and
% every row - 1 or 0 - whether the ROI is coactive or not.
%
%   INPUTS:
%       TVred - Temporal Vector reduced matrix (all-0 columns eliminated)
%       samples - time sample indices that contain significant syncronizations
%
%
%   OUTPUTS:
%       unistim_cellpools - struct
%       TV - Temporal Vector matrix
%       TVstim - Temporal Vector matrix, reduced to during stim only
%       STIMSAMP - struct
%
%part of ZENITH

ons = STIMSAMP.stim_on:STIMSAMP.full_s:STIMSAMP.full_xl;
offs = STIMSAMP.stim_off:STIMSAMP.full_s:STIMSAMP.full_xl;

samples_stim = []; samples_stim_num = [];
for m = 1:numel(samples)
    for n = 1:numel(ons)
        if samples(m) >= ons(n) && samples(m) <= offs(n)
            samples_stim = [samples_stim, samples(m)];
            samples_stim_num = [samples_stim_num, n];
            break
        end
    end
end
STIMSAMP.samps = samples_stim;
STIMSAMP.samps_stimid = samples_stim_num;

TV = zeros(size(B));
TV(:,samples_stim) = B(:,samples_stim);
TVstim = B(:,samples_stim);

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
