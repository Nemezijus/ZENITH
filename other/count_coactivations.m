function [coact, CoA, test_stat] = count_coactivations(B, window, dim, test)
% [coacts] = count_coactivations(B, dim) - counts coactive cells accordign
% to the given dimensionality (1-within, 2-between cells)
%
% INPTUS:
%       B - (double matrix) binary matrix of spike probability
%       window - (integer) window size of frames within we examine coactivations
%       dim - (integer) dimension according to which we should count the
%       coactivations (by default 1: window within a row; 2: window within columns)
%       test - (string) only needed if dim is set to 2, values can be
%       'many/once' (by default) or 'two/many'
%
% OUTPUTS:
%       coacts - struct? storing the time stamps and number of
%       coactivations

% conditions
if nargin < 2
    window = 5;
    dim = 1;
    test = 'many/once';
elseif nargin < 3
    dim = 1;
    test = 'many/once';
elseif nargin < 4
    test = 'many/once';
end

% base case - look for simultaneous activity within a cell (default -> dim 1)
% for first i'll use more discrete windowing approach, then we'll see
CoA = [];
min_number_of_coact_spikes = 2;
for ncells = 1:size(B,1)
    count = 1;
    coa = [];
    for nframes = 1:window:size(B,2)
        % when it faces the final step
        if size(B,2)-nframes < window-1
            if sum(B(ncells, nframes:size(B,2))) >= min_number_of_coact_spikes
                % append struct
                cell_index = nframes:size(B,2);
                coact(ncells).cells(count).sum = sum(B(ncells, nframes:size(B,2)));
                coact(ncells).cells(count).index = cell_index(logical(B(ncells, nframes:size(B,2))));
                %
                coa = [coa, 1];
            else
                coa = [coa, 0];
            end
        end
        % before the end
        sp_train = B(ncells, nframes:nframes+window-1);
        if sum(sp_train) >= min_number_of_coact_spikes
            cell_index = nframes:nframes+window-1;
            coact(ncells).cells(count).sum = sum(sp_train);
            coact(ncells).cells(count).idx = cell_index(logical(sp_train));
            %coact.cells(count).timing = Time(cell_index(logical(sp_train)));
            count = count + 1;
            %
            coa = [coa, 1];
        else
            coa = [coa, 0];
        end
    end
    CoA = [CoA; coa];
end
%
if dim == 2
    test_stat = [];
    switch test
        case 'many/once'
            min_number_of_coact_cells = 4;
            allcell = size(CoA,1);
            for ncols = 1:size(CoA,2)
                cocell = sum(CoA(:,ncols));
                cocell_perc = cocell/allcell * 100;
                test_stat = [test_stat, cocell_perc];
%                 if sum(CoA(:,ncols)) >= min_number_of_coact_cells
%                 end
            end
        case 'two/many'
            return
    end
end

