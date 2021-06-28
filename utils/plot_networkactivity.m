function [STIMSAMP] = plot_networkactivity(ex, istage, B, SYNC_real, PAR, fig)
% plot_networkactivity(ex, B, PAR) - plots the raster plot of network
% activity responses to visual stimuli (top) with a temporal histogram
% (bottom) representing coactive cells over time
%
%   PREREQUISITES:
%       Step 1 - load spike-probability matrix M
%       Step 2 - adjust PAR(ameters) if needed --> PAR.Nrecs can vary,
%       which is calculated from ex.N_stim(istage)*ex.N_reps(istage) where
%       istage is the number of stage we invastigate
%       Step 3 - run [SYNC, Pcutoff, B, SYNC_shuffled] = synchronizations(M,PAR);
%       Step 4 - update PAR with Pcutoff 
%
%   INPUTS:
%       ex -
%       istage -
%       B -
%       SYNC_real -
%       PAR -
%       
%   OUTPUTS:
%       STIMSAMP - struct containing stimulus timing related informations
%       
%Part of ZENITH utils
%Replacing rater_plot_multi 
if nargin < 6
    fig = [];
end

if nargin < 4
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','SYNC_PARS.mat'},'\');
    load(PARloc);
end

if PAR.Nrecs ~= ex.N_stim(istage)*ex.N_reps(istage)
    PAR.Nrecs = ex.N_stim(istage)*ex.N_reps(istage);
end

[~, t_ref, onoff] = downsampling_ca(1, ex, 1, istage, 1, 1);
raster_plot_multi(ex, B, t_ref, onoff, SYNC_real, PAR.pcutoff, fig);

STIMSAMP.full_s = numel(t_ref);
STIMSAMP.full_xl = numel(SYNC_real);
STIMSAMP.stim_on = onoff(1);
STIMSAMP.stim_off = onoff(2);
