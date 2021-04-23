function [M] = generate_network_spikes(ex, istage, par)
% [M, time, onoff] = generate_network_spikes(ex, istage) - creates a matrix with 
% [nroi x nstims*nreps*nsamples] dimensions, where the columns contain the
% stitched spike probabilities. As the process is time consuming, we save
% the matrix at the very end for future reference.
%
%   INPUTS:
%       ex - experiment object
%       istage - number of the chosen stage (optional)
%
%   OUTPUTS:
%       M - matrix containing the network spike probability data ([nroi x nstims*nreps*nsamples])
% 
%see also raster_plot, probability_to_binary, export_spikes_woopsi
%Part of ZENITH utils

if nargin < 3
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','MLs_PARS.mat'},'\');
    load(PARloc);
end

M = [];
for iroi =1:ex.N_roi
    disp(['Processing ROI_', num2str(iroi)]);
    roi_dff = ex.stitch(iroi, istage, 'dff');
    [spikes_ML] = export_MLspikes(roi_dff, par);
    M = [M; spikes_ML'];
end

% Part 2: saving
currloc = cd;
floc_split = strsplit(ex.file_loc,'\');
FILEloc= strjoin([floc_split(1:end-2), 'Other', 'Ensemble Analysis', 'MLSpike'], '\');
try
    cd(FILEloc)
catch
    mkdir(FILEloc)
    cd(FILEloc)
end
fname = ['m', ex.id, '_stage', num2str(istage), '_mlspike', '.mat'];
disp(['SAVING ', fname]);
save(fname, 'M', '-v7.3'); % modify name tag according to M nomenclature
cd(currloc)