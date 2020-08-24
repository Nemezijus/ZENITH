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
row_sums = sum(M~=0,2);
col_sums = sum(M~=0,1);
zero_rows = sum(M,2) == 0;
SH = zeros(sz);
for icol = sz(2):-1:1
    toshuffle = M(:,icol);
    
    %1 - collect non zeros and zeros
    toplace = toshuffle(toshuffle~=0);
    toplace = toplace(randperm(numel(toplace)));%when its not 1's and 0's
    Z = toshuffle(toshuffle==0);
    
    %2 - certain placement
    still_needed = row_sums;
    certainly = still_needed==icol;
    certainly_idx = find(toplace, sum(certainly), 'first');
    SH(certainly,icol) = toplace(certainly_idx);
    toplace(certainly_idx) = [];
    
    %3 - place the remainder in random spots of the column
    idx = find(still_needed<icol & still_needed~=0);
    rand_idx = idx(randperm(numel(idx)));
    SH(rand_idx(1:numel(toplace)),icol) = toplace;
    SH(rand_idx(numel(toplace)+1:end),icol) = 0;
    row_sums = row_sums - double(SH(:,icol)~=0);
end

if sum(SH~=0,1) ~= col_sums | sum(SH~=0,2) ~= row_sums
    error('invariant shuffle did not succeed');
end