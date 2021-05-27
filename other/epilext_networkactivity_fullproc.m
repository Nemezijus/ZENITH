function [SYNC, Pcutoff, B, SYNC_shuffled, PAR] = epilext_networkactivity_fullproc(B, pa, iis)
% networkactivity_fullproc(ex, PAR) - is a script which runs each steps of
% network activity evaluation leading leading to its visualization
%
%   INPUTS:
%       B - binary matrix containing digitalized activity of the cell
%           population (by Tibi)
%       pa - column vector containing population activity (by Tibi)
%       iis - binary column vector containing interictalspike presence (by
%             Tibi)
%       PAR - struct containing essential parameters for running the
%           network activity evaluation
% 
%   OUTPUTS:
%       SYNC - synchronization vector of real data M
%       Pcutoff - number of synchronizations threshold below which
%               synchronizations happen by chance
%       B - the binary spike matrix
%
%Part of ZENITH\other

if nargin < 5
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','SYNC_PARS.mat'},'\');
    load(PARloc);
end

% run synchronized evaluation methods
[SYNC, Pcutoff, B, SYNC_shuffled] = epilext_synchronizations(B,PAR);

% adjust PAR
PAR.pcutoff = Pcutoff;

% median - median absolute deviation (Tibi féle)
[SYNC_mcutoff] = epilext_threshold_by_median(SYNC);
[pa_mcutoff] = epilext_threshold_by_median(pa);
PAR.mcutoff = [SYNC_mcutoff; pa_mcutoff];

% visualize
epilext_plot_networkactivity(B, SYNC, pa, iis, PAR);






