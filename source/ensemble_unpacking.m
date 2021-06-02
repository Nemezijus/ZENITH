function [TVens, ROIids] = ensemble_unpacking(redB, TFIDF)
% TVens = ensemble_unpacking(redB) - each ensemble in redB gets assigned
% time vector indexing for the ensemle raster plot
%
%   INPUTS:
%       redB - time vector matrix, thresholded.
%       TFIDF - tf-idf matrix
%
%   OUTPUT:
%       TVens - cell array with each element containing indices of time
%       vector matrix attributed to each ensemble
%
%part of ZENITH

sz = size(redB);
Nens = numel(redB(:,1,1));

rast = zeros(sz(1),sz(2));
for iens = 1:Nens
    cells = [];
    cens(:,:) = redB(iens,:,:);
    for irows = 1:sz(2)
        cens(irows,1:irows) = 0;
    end
    [a,b] = find(cens);
    for ia = 1:numel(a)
        va = TFIDF(:,a(ia));
        vb = TFIDF(:,b(ia));
        idxs = find(va.*vb);
        cells = [cells,idxs'];
    end
    ROIids{iens} = unique(cells);
    una = unique(a);
    unb = unique(b);
    un = unique([una;unb]);
    TVens{iens} = un;
    rast(iens,un) = 1;
end

for iens = 1:Nens
    found = find(rast(iens,:),1);
    if isempty(found)
        found = Inf;
    end
    first(iens) = found;
end
[~,Bsort]=sort(first); %Get the order of B
sort_rast = rast(Bsort,:);


raster_plot(sort_rast);
set(gcf,'units', 'normalized', 'position', [0.382 0.419 0.265 0.388]);
ylim([0.5,sz(1)+0.5]);
xlim([0,sz(2)]);
yticks([1:6]);
yticklabels(num2cell(Bsort));
ylabel('ensemble ID');
xlabel('temporal vector index');