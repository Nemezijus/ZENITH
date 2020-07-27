function SHM = matrix_shuffle(M,dim,rule)
% SHM = matrix_shuffle(M,dim,rule) - matrix of spike trains shuffling based on the
% specified rule
%
%   INPUTS:
%       M - binary spike train matrix
%       dim - matrix dimension for shuffling (1 - rows, 2 - columns)
%       rule - string specifying a shuffling rule (default - 'intervals');
%
%   OUTPUTS:
%       SHM - shuffled spike train matrix
%
%Part of ZENITH source

if nargin < 3
    rule = 'intervals';
end
if nargin < 2
    dim = 1;
end
if numel(unique(M)) > 2
    error('matrix is not binary')
end
sz = size(M);
switch dim
    case 1
        for isz = 1:sz(1)
            row = M(isz,:);
            SHM(isz,:) = spike_shuffle(row,rule);
        end
    case 2
        for isz = 1:sz(2)
            column = M(:,isz);
            SHM(:,isz) = spike_shuffle(column,rule);
        end
end