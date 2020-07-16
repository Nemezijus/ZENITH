function [MMM, time, onoff] = generate_network_spikes(ex, istage)
% [MMM] = generate_network_spikes(ex, istage) - creates a matrix with 
% [nroi x nstims*nreps*nsamples] dimensions, where the columns contain the
% stitched spike probabilities. As the process is time consuming, we save
% the matrix at the very end for future reference.
%
%   INPUTS:
%       ex - experiment object
%       istage - number of the chosen stage (optional)
%
%   OUTPUTS:
%       MMM - matrix with network spike probability data ([nroi x nstims*nreps*nsamples])
% 
%see also raster_plot, probability_to_binary, export_spikes_woopsi
%Part of ZENITH utils


% Part 1
% this part takes a while!
MMM = [];
checker = 1;
refmx = ex.restun{istage};
for iroi = 1:ex.N_roi
    disp(['Processing ROI_', num2str(iroi)]);
    MM = [];
    for irep = 1:ex.N_reps(istage)
        [~, rearranged] = sort(refmx(:,irep));
        M = export_spikes_woopsi(ex, iroi, istage, 0, irep);
        %                 B = probability_to_binary(M);
        %                 B = B(rearranged,:);
        M = M(rearranged,:);
        for istim = 1:ex.N_stim(istage)
            MM = [MM, M(istim,:)];
        end
    end
    MMM = [MMM; MM];
end
[~, time, onoff] = export_spikes_woopsi(ex, iroi, istage, 1, 1);

% Part 2
% save gigantic mx
FILEloc = 'C:\Users\nagy.dominika\Desktop';
currloc = cd;
cd(FILEloc)
fname = ['m', ex.id, '_test', '.mat'];
save(fname, 'MMM', '-v7.3');
cd(currloc)