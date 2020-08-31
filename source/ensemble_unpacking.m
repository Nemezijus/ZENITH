function TVens = ensemble_unpacking(redB)
% TVens = ensemble_unpacking(redB) - each ensemble in redB gets assigned
% time vector indexing for the ensemle raster plot
%
%   INPUT:
%       redB - time vector matrix, thresholded.
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
    cens(:,:) = redB(iens,:,:);
    [a,b] = find(cens);
    una = unique(a);
    unb = unique(b);
    un = unique([una;unb]);
    TVens{iens} = un;
    rast(iens,un) = 1;
end

for iens = 1:Nens
    first(iens) = find(rast(iens,:),1);
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