function SHM = matrix_shuffle(M,dim,rule,Bidxs)
% SHM = matrix_shuffle(M,dim,rule) - matrix of spike trains shuffling based on the
% specified rule
%
%   INPUTS:
%       M - binary spike train matrix
%       dim - matrix dimension for shuffling (1 - rows, 2 - columns)
%       rule - string specifying a shuffling rule (default - 'intervals');
%       Bidxs - cell array of indices for all '1s' in each row
%   OUTPUTS:
%       SHM - shuffled spike train matrix
%
%Part of ZENITH source
if nargin < 4
    Bidxs = {};
end

if nargin < 3
    rule = 'intervals';
end
if nargin < 2
    dim = 1;
end
fastmethod = 1;
% if numel(unique(M)) > 2
%     error('matrix is not binary')
% end
sz = size(M);

SHM = zeros(sz);

if fastmethod
    Bidxs_r = cellfun(@(x) diff(x), Bidxs,'un',0);
    new_intervals = cellfun(@(x) x(randperm(length(x))), Bidxs_r,'un',0);
    not_empty = ~cellfun(@(x) isempty(x),Bidxs_r);
    new_intervals = new_intervals(not_empty);
    Bidxs_r = Bidxs_r(not_empty);
    Bidxs = Bidxs(not_empty);
    gbuffers = cellfun(@(x, N) x(1)-1+N-x(end),Bidxs,repmat({numel(M(1,:))},1,numel(Bidxs)),'un',0);
    new_start = cellfun(@(x) randi(x+1)-1, gbuffers,'un',0);
    idxs = cellfun(@(x,y) cumsum([x+1, y]),new_start, new_intervals,'un',0);
    
    count = 1;
    for ish = 1:sz(1)
        if not_empty(ish)
%             cshr = SHM(ish,:);
%             cshr(idxs{count}) = 1;
%             SHM(ish,:) = cshr;
            SHM(ish,idxs{count}) = 1;
            count = count+1;
%         else
%             SHM(ish,:) = M(ish,:);
        end
    end
    
    
else
    switch dim
        case 1
            SH = zeros(size(M(1,:)));
            for isz = 1:sz(1)
                row = M(isz,:);
                SHM(isz,:) = spike_shuffle(row,rule, SH, Bidxs{isz});
            end
        case 2
            SH = zeros(size(M(:,1)));
            for isz = 1:sz(2)
                column = M(:,isz);
                SHM(:,isz) = spike_shuffle(column,rule, SH);
            end
    end
end