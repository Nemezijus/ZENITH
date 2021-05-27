function epilext_plot_networkactivity(B, SYNC_real, pa, IIS_list, PAR)
% plot_networkactivity(ex, B, PAR) - plots the raster plot of network
% activity responses to visual stimuli (top) with a temporal histogram
% (bottom) representing coactive cells over time
%
%   INPUTS:
%       B - the binary spike matrix; One row - one ROI
%       SYNC_real - SYNC - synchronization vector of real data B
%       pa - column vector containing population activity
%       iis - binary column vector containing interictalspike presence
%       PAR - struct containing essential parameters for running the
%               network activity evaluation
%       
%   OUTPUTS:
%       (none)
%       
%Part of ZENITH\other

if nargin < 4
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','SYNC_PARS.mat'},'\');
    load(PARloc);
end

epilext_rasterplot(B, SYNC_real, pa, IIS_list, PAR.pcutoff, PAR.mcutoff);
