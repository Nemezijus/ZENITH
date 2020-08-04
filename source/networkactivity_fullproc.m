function networkactivity_fullproc(ex, istage, M, PAR)
% networkactivity_fullproc(ex, PAR) is a script which runs each steps of
% network activity evaluation leading leading to its visualization
%
% PREREQUISITE(S):
%       Step 1 - load stored spike probability matrix M (so far it stays as
%       a prerequisite as generating these matrices are apriori tasks,
%       where user stores it is not consistent yet)
%
% INPUTS:
%       ex - experiment object storing all useful data regarding experiment
%       istage - user must define which stage of the experiment we are
%       dealing with
%       M - matrix containing spike probabilities of all rois of the
%       defined stage
%       PAR - struct containing essential parameters for running the
%       network activity evaluation
%
%Part of ZENITH

if nargin < 3
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

% -by default PAR settings so far
PAR.treat_artifacts = 1;
PAR.nstart = 30;

% run synchronized evaluation methods
[SYNC, Pcutoff, B, SYNC_shuffled] = synchronizations(M,PAR);

% adjust PAR
PAR.pcutoff = Pcutoff;

% visualize
plot_networkactivity(ex, istage, B, SYNC, PAR);


