function SH = shuffle_time_frames(M)
% SH = shuffle_time_frames(M) - shuffles events within time frames or
% columns of the matrix M
%
%   INPUT:
%       M - synchronization matrix. One row - one active ROI, one column -
%           one significant time frame
%
%   OUTPUT:
%       SH - shuffled matrix M
%
%part of ZENITH

sz = size(M);
Ncols = sz(2);
Nrows = sz(1);

SH = zeros(sz);

for icol = 1:Ncols
    permseq = randperm(Nrows);
    SH(:,icol) = M(permseq,icol);
end
