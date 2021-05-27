function [n] = export_MLspikes(roi_dff, mode)
% [Ffit, spikes] = export_MLspikes(roi_stitched, par) - exports MLspike data
%
% INPUTS:
%       roi_stitched - full, stitched traces of calcium signal of a roi
%       par - parameter struct, where fields are:
%           a - amplitude of 1 spike (0.05 by default)
%           tau - decay time (0.5 sec by default)
%           dt - frame acquisition time (calculated within function)
%           F0 - baseline fluorescence (calculated within function)
%           dographsummary - 0 by default
%
% OUTPUTS:
%       Ffit - vector of spike-threshold for calcium signal 
%       n - vector of spike counts
%
% COMMENTS:
%       a = 0.175 and tau = 0.7 seemed a better parameter choice than the by
%       default set
%
%See also spikes-master, brick-master, tps_mlspikes
%Based on visc_MLspike_single
%Part of ZENITH source/utils


calcium = roi_dff.data;
switch mode
    case 'old'
        %
        par = tps_mlspikes('par');
        % (indicate the frame duration of the data)
        par.dt = (roi_dff.time(2)-roi_dff.time(1)) * 1e-3;
        % (set physiological parameters)
        par.a = 0.4; % DF/F for one spike
        par.tau = 0.6; % decay time constant (second)
        % (set noise parameters)
        par.finetune.sigma = .02;
        % (do not display graph summary)
        par.dographsummary = false;
        %
        [n] = tps_mlspikes(calcium', par);
        %-- check
        figure; plot(n*-1); hold on; plot(calcium);
    case 'new'
        par = tps_mlspikes('par');
        % (indicate the frame duration of the data)
        par.dt = (roi_dff.time(2)-roi_dff.time(1)) * 1e-3;
        % (set physiological parameters)
        par.a = 0.5; % DF/F for one spike
        par.tau = 0.6; % decay time constant (second)
        % (set noise parameters)
        par.finetune.sigma = .02; % a priori level of noise (if par.finetune.sigma
                                  % is left empty, MLspike has a low-level routine 
                                  % to try estimating it from the data
        par.drift.parameter = .01; % if par.drift parameter is not set, the 
                                   % algorithm assumes that the baseline remains
                                   % flat; it is also possible to tell the
                                   % algorithm the value of the baseline by setting
                                   % par.F0
        % (do not display graph summary)
        par.dographsummary = false;
        % spike estimation
        [spikest fit drift] = spk_est(calcium,par); % not what we want
end
