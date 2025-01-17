function [SYNC, Pcutoff, B, SYNC_shuffled, STIMSAMP, PAR] = networkactivity_fullproc(ex, istage, M, PAR, fig)
% networkactivity_fullproc(ex, PAR) - is a script which runs each steps of
% network activity evaluation leading leading to its visualization
%
%   PREREQUISITE(S):
%       Step 1 - load stored spike probability matrix M (so far it stays as
%               a prerequisite as generating these matrices are apriori tasks,
%               where user stores it is not consistent yet)
%
%   INPUTS:
%       ex - experiment object storing all useful data regarding experiment
%       istage - user must define which stage of the experiment we are
%               dealing with
%       M - matrix containing spike probabilities of all rois of the
%           defined stage
%       PAR - struct containing essential parameters for running the
%           network activity evaluation
%       fig - handle to figure on which plotting occurs
% 
%   OUTPUTS:
%       SYNC - synchronization vector of real data M
%       Pcutoff - number of synchronizations threshold below which
%               synchronizations happen by chance
%       B - the binary spike matrix
%       STIMSAMP  - struct containing the sampsize of a single trace, and
%               the on- and offset of vistim 
%
%Part of ZENITH
if nargin < 5
    fig = [];
end
if nargin < 4 | isempty(PAR)
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','SYNC_PARS.mat'},'\');
    load(PARloc);
end

% adjust PAR.Nrecs to measurement settings
if PAR.Nrecs ~= ex.N_stim(istage)*ex.N_reps(istage)
    PAR.Nrecs = ex.N_stim(istage)*ex.N_reps(istage);
end
w = traces(ex, {1,1,1,1,0},'raw');
t = w.time(1,:);
ts = mean(diff(t))*1e-3;
Fs = 1/ts;
disp(['Sampling Frequency is: ',num2str(Fs), ' Hz']);

PAR.Fs = Fs;
% run synchronized evaluation methods
[SYNC, Pcutoff, B, SYNC_shuffled] = synchronizations(M,PAR, fig);

% adjust PAR
PAR.pcutoff = Pcutoff;

% median threshold
[SYNC_mcutoff] = epilext_threshold_by_median(SYNC);
PAR.mcutoff = SYNC_mcutoff;

% visualize
STIMSAMP = plot_networkactivity(ex, istage, B, SYNC, PAR, fig);

%code below is to be made more adaptable [one day]
if sum(ex.N_stim) == 0
    PAR.stimlist = [0, 1, 2];%0 - not after teleport, 1 - to reward 2 - to clouds
else
    PAR.stimlist = [0:45:315,666,999];
end

