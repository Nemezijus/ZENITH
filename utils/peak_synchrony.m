function SYNC = peak_synchrony(M, samp_window)
% SYNC = peak_synchrony(M, samp_window) - counts how many cells were
% synchronous during expected time window.
%
%   INPUTS:
%       M - binary matrix of responses. each row represents one ROI
%       samp_window - the size of sliding window in samples. 
%
%   OUTPUTS:
%       SYNC - synchronization counts vector. Length is the same as M row
%       dimension
%
%Part of ZENITH source

if nargin < 2
    samp_window = 3;
end


slided = movsum(M,samp_window,2);
SYNC = sum(slided>0);
if(samp_window>1)
    % double smoothing
    SYNC=smooth(SYNC,samp_window);
    SYNC=smooth(SYNC,samp_window);
end