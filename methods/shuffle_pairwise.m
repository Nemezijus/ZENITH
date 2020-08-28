function [a_sh,b_sh] = shuffle_pairwise(a,b);
% [a_sh,b_sh] = shuffle_pairwise(a,b) - shuffles elements between a and b
% rows
%
%   INPUTS:
%       a,b - pairwise vectors
%
%   OTPUTS
%       a_sh,b_sh - shuffled pairwise vectors
%
%part of ZENITH

N = numel(a);
if numel(b) ~= N
    error
end

A(:,1) = a;
A(:,2) = b;


[M,N] = size(A);
rowIndex = repmat((1:M)',[1 N]);
% Get randomized column indices by sorting a second random array
[~,randomizedColIndex] = sort(rand(M,N),2);
% Need to use linear indexing to create B
newLinearIndex = sub2ind([M,N],rowIndex,randomizedColIndex);
B = A(newLinearIndex);

a_sh = B(:,1);
b_sh = B(:,2);