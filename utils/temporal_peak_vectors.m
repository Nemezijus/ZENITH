function [TV, TVred, samples, peak_start_end, peak_size] = temporal_peak_vectors(B, SYNC, Pcutoff, binsize, PAR)
% [TV, TVred, samples] = temporal_peak_vectors(B, SYNC, Pcutoff, binsize, PAR) - creates
% temporal vector binary matrix where each column represents time point and
% every row - 1 or 0 - whether the ROI is coactive or not.
%
%   INPUTS:
%       B - binary spike matrix
%       SYNC - synchronization vector of real data
%       Pcutoff - threshold of synchronizations for a given P value
%       binsize - 
%       PAR - parameter struct
%
%   OUTPUTS:
%       TV - Temporal Vector matrix
%       TVred - Temporal Vector reduced matrix (all-0 columns eliminated)
%       samples - sample sequence matiching SYNC with non-zero values
%           indicating the significant samples
%       peak_start_end - pair of sample indices indicating each peak
%           starting and final sample
%       peak_size - the max value of each peak
%
%part of ZENITH
TV = [];
TVred = [];
samples = [];

if nargin < 4
    binsize = 5;
end

if nargin < 5
    loc = [mfilename('fullpath'),'.m'];%path to this HUB file
    loc = strsplit(loc,'\');
    loc = loc(1:end-2);
    PARloc = strjoin({loc{:},'utils','SYNC_PARS.mat'},'\');
    load(PARloc);
end

SYNC = SYNC';
idx = 1:numel(SYNC);
idx_above_threshold = idx(SYNC>Pcutoff)';

if isempty(idx_above_threshold)
    disp('No significant coactivations found!')
    return
end

peak_vector = zeros(size(SYNC));

for cidx = 1:numel(idx_above_threshold)
    peak_vector(idx_above_threshold(cidx)) = cidx;
end
same_peak_idx = find(idx_above_threshold~=...
    [0; (idx_above_threshold(1:numel(idx_above_threshold)-1)+1)]);
Npeaks = numel(same_peak_idx);
if Npeaks > 0
    for ipeak = 1:Npeaks-1
        peak_vector(idx_above_threshold(same_peak_idx(ipeak)):...
            idx_above_threshold(same_peak_idx(ipeak+1)-1),1) = ipeak;
    end
    peak_vector(idx_above_threshold(same_peak_idx(Npeaks)):max(idx_above_threshold),1)=Npeaks;
end


peak_start_end = zeros(Npeaks,2);

for ipeak = 1:Npeaks
    loc = find(peak_vector==ipeak);
    peak_start_end(ipeak,1) = loc(1);
    peak_start_end(ipeak,2) = loc(end);
    widths(ipeak) = length(loc);
end

peak_size = zeros(Npeaks, 1);
new_SYNC = zeros(size(SYNC));
for ipeak = 1:Npeaks
    range = peak_start_end(ipeak,1):peak_start_end(ipeak,2);
    peak_size(ipeak) = max(SYNC(range));
    new_SYNC(range) = deal(peak_size(ipeak));
end
figure;
set(gcf,'units', 'normalized', 'position', [0.0807 0.531 0.855 0.131]);
plot(SYNC,'k-'); hold on;
plot([1,numel(SYNC)],[Pcutoff,Pcutoff],'b-');
plot(new_SYNC,'r-');
a=1;

% see "Get_Peak_Vectors"
%this is the 'sum' method implemented
Nrois = size(B,1);
TVred = zeros(Npeaks,Nrois);
for ipeak = 1:Npeaks
    cpeak = B(:,peak_vector==ipeak);
    TVred(ipeak,:) = sum(cpeak,2);
end
a=1;
TVred = TVred';
TV = B(:,peak_vector>0);
samples = peak_vector; %convenience rename