function SH = shuffle_diagonal(B);
% SH = shuffle_diagonal(B) - shuffles diagonal matrix B preserving
% diagonality
%
%   INPUT:
%       B - diagonal matrix to be shuffled
%
%   OUTPUT:
%       SH - shuffled diagonal matrix
%
%part of ZENITH

sz = size(B);
SH = diag(diag(B));
vtl = nonzeros(tril(reshape(1:numel(B),sz),-1));
SH(tril(true(sz),-1)) = B(vtl( randperm(length(vtl))));
SH = SH + tril(SH,-1).';