function [s,S,U,V] = svd_components(B)
% [s,S,V] = svd_components(B) - performs singular value decomposition on
% the binary matrix B and returns the significant singlar values which
% represent distinct clusters
%
%   INPUT:
%       B - binary matrix representing significantly similar time vectors
%       (TxT)
%
%   OTPUTS:
%       s - reduced singular value matrix S diagonal containing onl
%       significant singular values
%       S - full singular valuue matrix
%       V - unitary matrix of orthonormal bases
%
%part of ZENITH
s = [];
[U,S,V] = svd(B);


s = diag(S);
BB = zeros(size(B));
for is = 1:numel(s)
    BB = BB+s(is).*U(:,is)*V(:,is)';
end
a=1;