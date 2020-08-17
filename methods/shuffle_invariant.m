function SH = shuffle_invariant(M)
% SH = shuffle_invariant(M) - shuffles matrix M by preserving the
% activities for all rows and columns
%
%   INPUT:
%       M - Matrix to be shuffled
%
%   OUTPUT:
%       SH - shuffled matrix
%
%part of ZENITH
sz = size(M);
row_sums = sum(M,2);
col_sums = sum(M,1);
zero_rows = sum(M,2) == 0;
SH = zeros(sz);
for icol = sz(2):-1:1
    toshuffle = M(~zero_rows,icol);
    shuffled = toshuffle(randperm(numel(toshuffle)));
    still_needed = row_sums;
    certainly = still_needed==icol;
    idx = find(shuffled, sum(certainly), 'first');
    SH(certainly,icol) = shuffled(idx);
    shuffled(idx) = [];
    if sum(shuffled)~=4
        a=1;
    end
    SH(~zero_rows&~certainly,icol) = shuffled;
    row_sums = row_sums - SH(:,icol);
    a=1;
end
