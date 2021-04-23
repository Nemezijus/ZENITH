function [n] = export_MLspikes(roi_dff, par)
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

if nargin < 2
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','MLs_PARS.mat'},'\');
    load(PARloc);
end

par.dt = (roi_dff.time(2)-roi_dff.time(1)) * 1e-3; %0.0323; 
% par.a = 0.5;
% par.tau = 0.6;
ca_stitched = roi_dff.data;
[n] = tps_mlspikes(ca_stitched', par);
