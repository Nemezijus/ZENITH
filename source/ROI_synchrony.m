function [SYNC_real, SYNC_shuffled, SH] = ROI_synchrony(B, Nshuffle, rule, samp_window, Fs)
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
%       Fs - sampling frequency in Hz 
%
%   OUTPUTS:
%       SYNC_real - synchronization vector of real data in B
%       SYNC_shuffled - synchronization matrix of shuffled B data
%       SH - the Nshuffle dimension matrix of shuffled cases
%
%Part of ZENITH source
toplot = 0;
if nargin < 5
    Fs = [];
end
if nargin < 4
    samp_window = 3;
end

if nargin < 3
    rule = 'intervals';
end

if nargin < 2
    Nshuffle = 1000;
end


%SAMP WINDOW
if ~isempty(Fs)
    Ns = numel(B(1,:));
    smooth_filter = local_smooth_filter(Fs, Ns);
    samp_window = smooth_filter * Fs/1000;
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
if nargout == 3
    SH = zeros(Nshuffle,sz(1),sz(2));
end
for ishuff = 1:Nshuffle
    waitbar(ishuff/Nshuffle)
    SHM = matrix_shuffle(B, dim, rule, Bidxs);
    if nargout == 3
        SH(ishuff,:,:) = SHM;
    end
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

function user_entry = local_smooth_filter(Fs, Ns)
def = 100;
user_entry = def;
default = round(5000/Fs);
minimum = round(1000/Fs);
maximum = round(Ns*1000/Fs);
multiple = 1;
if ~isnan(user_entry)
    user_entry=floor(user_entry);
    if(user_entry<0)
        neg=true;
        user_entry=-user_entry;
    end
    % verify if the data is between the limits
    if(user_entry>maximum)
        user_entry=maximum;
    elseif(user_entry<minimum)
        user_entry=minimum;
    end
else
    user_entry=default;
end

if(multiple)
    times=round(user_entry/minimum);
    user_entry=minimum*times;
end

% if(negative && neg)
%     user_entry=-user_entry;
% end
