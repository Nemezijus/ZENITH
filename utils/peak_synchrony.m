function SYNC = peak_synchrony(M, samp_window);
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

sz = size(M);
length = sz(2);
zero_append = zeros(sz(1),samp_window-1);
M = horzcat(M, zero_append);
%appending samp_window-1 zero columns to the end of the matrix
for il = 1:length
    subM = M(:,il:il+samp_window-1);
    SYNC(il) = sum(any(subM,2));
end