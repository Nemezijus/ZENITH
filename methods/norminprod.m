function [si, inprod] = norminprod(a, B, ftype)
% [scoef] = norminprod(a, b) - calculates the similarity index between
% pairs of vectors by their normalized inner product, which represents the
% cosine of the angles between two vectors
%
%   INPUTS:
%       a - reference vector
%       B - cols of vectors || vector to be compared 
%
%   OUTPUT:
%       si - similarity index
%
%Part of ZENITH methods

if strcmp(ftype, 'new')
    inprod = sum(a .* B);
    N = zeros(1,numel(inprod));
    for n = 1:size(B,2)
        N(n) = norm(B(:,n));
    end
    si = inprod ./ (norm(a)*N);
else
    inprod = sum(a .* B);
    si = inprod/(norm(a)*norm(B));
end