function [TV, TVstim, STIMSAMP] = temporal_vectors_durstim(B, samples, STIMSAMP)
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
%       TVstim - Temporal Vector matrix
%
%part of ZENITH

ons = STIMSAMP.stim_on:STIMSAMP.full_s:STIMSAMP.full_xl;
offs = STIMSAMP.stim_off:STIMSAMP.full_s:STIMSAMP.full_xl;

samples_stim = []; samples_stimid = [];
for m = 1:numel(samples)
    for n = 1:numel(ons)
        if samples(m) >= ons(n) && samples(m) <= offs(n)
            samples_stim = [samples_stim, samples(m)];
            samples_stimid = [samples_stimid, n];
            break
        end 
    end
end
STIMSAMP.samps = samples_stim;
STIMSAMP.samps_stimid = samples_stimid;

TV = zeros(size(B));
TV(:,samples_stim) = B(:,samples_stim);
TVstim = B(:,samples_stim);
