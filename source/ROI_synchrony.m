function [SYNC_real, SYNC_shuffled, SH] = ROI_synchrony(B, Nshuffle, rule, samp_window)
% [SYNC_real, SYNC_shuffled, SH] = ROI_synchrony(B, Nshuffle, rule,
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
%       SH - the Nshuffle dimension matrix of shuffled cases
%
%Part of ZENITH source
toplot = 0;
if nargin < 4
    samp_window = 3;
end

if nargin < 3
    rule = 'intervals';
end

if nargin < 2
    Nshuffle = 1000;
end
if toplot
    figure;
    plot(peak_synchrony(B, samp_window),'k-');hold on
    pl = plot(peak_synchrony(B, samp_window));
end
dim = 1;
h = waitbar(0,'Shuffling data');
Bidxs = local_idxs_of_ones(B);
sz = size(B);
SH = zeros(Nshuffle,sz(1),sz(2));
for ishuff = 1:Nshuffle
    waitbar(ishuff/Nshuffle)
    SHM = matrix_shuffle(B, dim, rule, Bidxs);
    SH(ishuff,:,:) = SHM;
    SYNC_shuffled(ishuff,:) = peak_synchrony(SHM, samp_window);
    if toplot
        delete(pl);
        pl = plot(SYNC_shuffled(ishuff,:),'r-');
        drawnow
    end
end
close(h);
SYNC_real = peak_synchrony(B, samp_window);


function b = local_idxs_of_ones(B);
for ib = 1:numel(B(:,1))
    [~,b{ib}] = find(B(ib,:));

end
