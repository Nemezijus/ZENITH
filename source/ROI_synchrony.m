function [SYNC_real, SYNC_shuffled] = ROI_synchrony(B, Nshuffle, rule, samp_window)
% [SYNC_real, SYNC_shuffled] = ROI_synchrony(B, Nshuffle, rule,
% samp_window) - collects synchronization vectors of real data and its
% multiple shuffles.
%
%   INPUTS:
%       B - binary spike matrix, row - one ROI spike data.
%       Nshuffle - number of shuffles to perform (default - 1000)
%       rule - shuffling rule (string). Default - 'intervals'.
%       samp_window - size of sampling window in samples for synchrony
%       estimate (default - 3).
%
%   OUTPUTS:
%       SYNC_real - synchronization vector of real data in B
%       SYNC_shuffled - synchronization matrix of shuffled B data
%
%Part of ZENITH source

if nargin < 4
    samp_window = 3;
end

if nargin < 3
    rule = 'intervals';
end

if nargin < 2
    Nshuffle = 1000;
end
figure;
plot(peak_synchrony(B, samp_window),'k-');hold on
pl = plot(peak_synchrony(B, samp_window));
dim = 1;
h = waitbar(0,'Shuffling data');
Bidxs = local_idxs_of_ones(B);
for ishuff = 1:Nshuffle
    waitbar(ishuff/Nshuffle)
    SHM = matrix_shuffle(B, dim, rule, Bidxs);
    SYNC_shuffled(ishuff,:) = peak_synchrony(SHM, samp_window);
    delete(pl);
    pl = plot(SYNC_shuffled(ishuff,:),'r-');
    drawnow
end
close(h);
SYNC_real = peak_synchrony(B, samp_window);


function b = local_idxs_of_ones(B);
for ib = 1:numel(B(:,1))
    [~,b{ib}] = find(B(ib,:));

end
