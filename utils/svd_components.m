function [redB,s,S,U,V] = svd_components(B)
% [redB,s,S,U,V] = svd_components(B) - performs singular value decomposition on
% the binary matrix B and returns the significant singular values which
% represent distinct clusters
%
%   INPUT:
%       B - binary matrix representing significantly similar time vectors
%       (TxT)
%
%   OTPUTS:
%       redB - N dimensional matrix - decomposition of B. N = number of
%               significant singular values
%       s - reduced singular value matrix S diagonal containing onl
%       significant singular values
%       S - full singular valuue matrix
%       U - left unitary matrix of orthinormal bases
%       V - right unitary matrix of orthonormal bases
%
%part of ZENITH
s = [];
[U,S,V] = svd(B);


s = diag(S);

%check
BB = zeros(size(B));
for is = 1:numel(s)
    BB = BB+s(is).*U(:,is)*V(:,is)';
end
b = round(BB)==B;
if sum(sum(b)) == numel(B)
    fprintf('svd decomposition successful\n');
else
    fprintf('svd decomposition does not reproduce binary matrix\n');
end


N = 6;


for in = 1:N
    redB(in,:,:) = s(in).*U(:,in)*V(:,in)';
end