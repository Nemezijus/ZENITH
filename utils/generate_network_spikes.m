function [reM, time, onoff] = generate_network_spikes(ex, istage, par)
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
%       time - time vector representing to a single repetition
%       onoff - indices of on- and offset of visual stimuli at the time
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

reM = [];
% refmx = ex.restun{istage};
for iroi =1:ex.N_roi
    disp(['Processing ROI_', num2str(iroi)]);
%     MM = [];
%     for irep = 1:ex.N_reps(istage)
%         [~, rearranged] = sort(refmx(:,irep));
%         M = downsampling_ca(1, ex, iroi, istage, 0, irep);
%         M = M(rearranged,:);
%         for istim = 1:ex.N_stim(istage)
%             MM = [MM, M(istim,:)];
%         end
%     end
    %spM = export_spikes_woopsi(MM, fs);
    roi_stitched = ex.stitch(iroi, istage, 'dff');
    [spikes_ML] = export_MLspikes(roi_stitched, par);
    reM = [reM; spikes_ML'];
end
[~, time, onoff] = downsampling_ca(1,ex, iroi, istage, 1, 1);

% Part 2: saving
FILEloc = 'C:\Users\nagy.dominika\Desktop';
currloc = cd;
cd(FILEloc)
fname = ['m', ex.id, '_stage', num2str(istage),'_proper', '.mat'];
disp(['SAVING ', fname]);
save(fname, 'reM', '-v7.3'); % modify name tag according to M nomenclature
cd(currloc)