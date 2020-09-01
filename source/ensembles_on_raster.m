function [R, F2, E] = ensembles_on_raster(ENS, ras, redB, TFIDF, STIMSAMPS, SYNC, Pcutoff)
% R = ensembles_on_raster(ENS, B, redB, TFIDF) - collects ensemble ROIs and
% their timings onto the raster plot
%
%   INPUTS:
%       ENS - ensemble struct
%       ras - binary spike matrix
%       redB - time vector matrix, thresholded
%       TFIDF - tf-idf matrix
%       STIMSAMPS - struct with stimulus window information
%       SYNC - synchronization curve
%       Pcutoff - synchronization cutoff value
%
%   OUTPUT:
%       R - raster figure
%       F2 - complementary figure
%
%part of ZENITH
cols = {'r','b','g','m','y','c'};
F = figure;
set(gcf,'units', 'normalized', 'position', [0.174 0.406 0.643 0.354])
AX1 = autoaxes(F,1,1,[0.05 0.05 0.05 0.2]);
AX2 = autoaxes(F,1,1,[0.05 0.05 0.73 0.05]);

axes(AX1);
local_raster(AX1,ras,[0.8 0.8 0.8]);

Nrecs = STIMSAMPS.full_xl/STIMSAMPS.full_s;
yl = ylim(AX1);
for irec = 1:Nrecs
    patch([STIMSAMPS.stim_on+STIMSAMPS.full_s*(irec-1), STIMSAMPS.stim_off+STIMSAMPS.full_s*(irec-1),...
        STIMSAMPS.stim_off+STIMSAMPS.full_s*(irec-1),STIMSAMPS.stim_on+STIMSAMPS.full_s*(irec-1)],...
        [yl(1),yl(1),yl(2),yl(2)],[0.5 0.5 0.5],'EdgeColor','None','FaceAlpha',0.5);
end
for iens = 1:numel(ENS)
    empty_raster = zeros(size(ras));
    cB(:,:) = redB(iens,:,:);
    cB = nullify(cB);
    cENS = ENS(iens);

    [a,b] = find(cB);
    for ia = 1:numel(a)
        orig_samp_a = STIMSAMPS.samps_orig(a(ia));
        orig_samp_b = STIMSAMPS.samps_orig(b(ia));
        va = TFIDF(:,a(ia));
        vb = TFIDF(:,b(ia));
        idxs = find(va.*vb);
        E(iens).pair(ia).samples = [orig_samp_a,orig_samp_b];
        E(iens).pair(ia).rois = idxs;
        empty_raster(idxs,[orig_samp_a,orig_samp_b]) = 1;
    end

    local_raster(AX1,empty_raster,cols{iens});
end
set(gca,'xtick',[])
set(gca,'xlim',[1,numel(ras(1,:))]);


axes(AX2);
plot(SYNC,'k-','linew',1); hold on;
plot([1,numel(ras(1,:))],[Pcutoff,Pcutoff],'r-','linew',2);
yl = ylim(AX2);
for irec = 1:Nrecs
    patch([STIMSAMPS.stim_on+STIMSAMPS.full_s*(irec-1), STIMSAMPS.stim_off+STIMSAMPS.full_s*(irec-1),...
        STIMSAMPS.stim_off+STIMSAMPS.full_s*(irec-1),STIMSAMPS.stim_on+STIMSAMPS.full_s*(irec-1)],...
        [yl(1),yl(1),yl(2),yl(2)],[0.5 0.5 0.5],'EdgeColor','None','FaceAlpha',0.5);
end
set(gca,'xlim',[1,numel(ras(1,:))]);
R = gcf;




%%%%%%%%%FIGURE 2%%%%%%%%%%%%%%%%%%%%%
F2 = figure;
set(F2,'units', 'normalized', 'position', [0.0156 0.0491 0.97 0.869])
AX = autoaxes(F2,3,2,[0.05 0.05 0.05 0.05],[0.05 0.05]);
for iens = 1:numel(ENS)
    axes(AX(iens))
    empty_raster = zeros(size(ras));
    cB(:,:) = redB(iens,:,:);
    cB = nullify(cB);
    cENS = ENS(iens);

    [a,b] = find(cB);
    for ia = 1:numel(a)
        orig_samp_a = STIMSAMPS.samps_orig(a(ia));
        orig_samp_b = STIMSAMPS.samps_orig(b(ia));
        va = TFIDF(:,a(ia));
        vb = TFIDF(:,b(ia));
        idxs = find(va.*vb);
        empty_raster(idxs,[orig_samp_a,orig_samp_b]) = 1;
    end

    local_raster(AX(iens),empty_raster,cols{iens});
    yl = ylim(AX(iens));
    for irec = 1:Nrecs
        patch([STIMSAMPS.stim_on+STIMSAMPS.full_s*(irec-1), STIMSAMPS.stim_off+STIMSAMPS.full_s*(irec-1),...
            STIMSAMPS.stim_off+STIMSAMPS.full_s*(irec-1),STIMSAMPS.stim_on+STIMSAMPS.full_s*(irec-1)],...
            [yl(1),yl(1),yl(2),yl(2)],[0.8 0.8 0.8],'EdgeColor','None','FaceAlpha',0.5);
    end
    stims = ENS(iens).samps_stimid;
    domstim = mode(stims);
    stims = setdiff(unique(stims),domstim);
    title([num2str(domstim),' [',num2str(stims),']']);
end
set(gca,'xtick',[])
set(gca,'xlim',[1,numel(ras(1,:))]);

function A = nullify(A)
sz = size(A);
for irows = 1:sz(2)
        A(irows,1:irows) = 0;
end


function local_raster(ax,M,col)
axes(ax);
x_axis = 1:numel(M(1,:));
for im = 0:numel(M(:,1))-1
    spikes = M(im+1,:);
    spikes(spikes == 0) = NaN;
    
    xPoints = [ x_axis;
        x_axis;
        NaN(size(x_axis)) ];
    yPoints = [ spikes - 0.3 + im;
        spikes + 0.3 + im;
        NaN(size(spikes)) ];
    xPoints = xPoints(:);
    yPoints = yPoints(:);
    r(im+1) = plot(xPoints,yPoints,'Color',col,'linew',2);hold on
end