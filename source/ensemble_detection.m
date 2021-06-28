function [CLU, B] = ensemble_detection(ex,M,istage,saveloc)
% [B,redB,s,TFIDF,STIMSAMP, ENS, ras,SYNC,Pcutoff, E] = ensemble_detection(ex,M,istage,saveloc)
% ensemble_detection(ex,M,istage, saveloc) - parent function that processes spiking
% activity of experiment and estimates the ensembles within the population
%
%   INPUTS:
%       ex - experiment object
%       M - spiking matrix
%       istage - stage identifier
%       saveloc - location to store figures. If none specified no saving
%               happens
%
%part of ZENITH
[B,redB,s,TFIDF,STIMSAMP, ENS, ras,SYNC,Pcutoff, E] = deal([]);
procedure = 'updated';
cleanup = 0;

%STIMULI
has_stim = 1;
%checking whether there is visual stimulation in this experiment
if isempty(ex.stim_type)
    has_stim = 0;
end
twin = 4;
if has_stim
    c_restun = ex.restun{istage};
    slist = export_stimulus_order(c_restun);
    SAMP = samples_of_vis_stim(ex);
    exptype = 'vis';
else
    SAMP = samples_of_teleported_to(ex, twin);
    slist = SAMP.stage(istage);
    exptype = 'photostim';
end

if nargin < 4
    tosave = 0;
else
    tosave = 1;
end
if tosave
    stage_str = ['stage_',num2str(istage)];
    saveloc = fullfile(saveloc, stage_str);
    if ~isdir(saveloc)
        mkdir(saveloc);
    end
end


%reducing M to only those ROIs that have any activity
if cleanup
    Midx = 1:numel(M(:,1));
    rowsum = sum(M,2);
    responsiveM = M(rowsum>0,:);
    realROIidx = Midx(rowsum>0);
    removed = numel(M(:,1)) - numel(realROIidx);
    M = responsiveM;
    disp([num2str(removed),' ROIs were removed due to showing no activity']);
end

%%%%FIGURE
F = figure;
set(F,'units', 'normalized', 'position', [0 0.037 1 0.892]);
d.F = F;
% d.COL = COL;
d.STIM = slist;
guidata(F,d);

sz_M = size(M);
fprintf('STEP 1 - SYNCHRONIZATION ESTIMATES\n');
fprintf('\n');
tic;
[SYNC, Pcutoff, B, SYNC_shuffled, STIMSAMP, PAR] = networkactivity_fullproc(ex, istage, M, [],F);
ras = B; %raster
t = toc;
% if tosave
%     saveas(gcf,[saveloc,'\1_raster_plot.fig']);
%     print('-r600',gcf,[saveloc,'\1_raster_plot'],'-dpng');
%     pause(5)
% end
fprintf(['STEP 1 - DONE. Running time: ', num2str(t), ' seconds\n']);
fprintf('\n');
fprintf(['Estimated threshold for synchronizations: ',num2str(Pcutoff),'\n']);
fprintf('\n');

fprintf('STEP 2 - TEMPORAL VECTOR CREATION\n');
fprintf('\n');
tic;
binsize = 5;
[TV, TVred, samples, start_end, peak_size] = temporal_peak_vectors(B, SYNC, Pcutoff, binsize, PAR, F);
% [TV, TVred, samples] = temporal_vectors(B, SYNC, Pcutoff, PAR);

% if has_stim
%     c_restun = ex.restun{istage};
%     slist = export_stimulus_order(c_restun);
%     [TVall, STIMSAMP] = temporal_vectors_durstim(B, samples, STIMSAMP, slist);
% else
%     TVall = TVred;
% end


%here we branch out - either using older TF-IDF method or the new linkage
%method
distmethod = 'euclidean';
linkagemethod = 'ward';
switch procedure
    case 'updated'
        [similarity, linktree] = peak_similarity(TVred, distmethod, linkagemethod);
        AX = autoaxes(F,1,3,[0.5 0.001 0.005 0.7], [0.025 0.025]);
%         set(gcf,'units', 'normalized', 'position', [0.119 0.388 0.797 0.335]);
%         subplot(1,3,1);
        axes(AX(1))
        imagesc(similarity);
        set(gca,'YDir','normal');
        title('Similarity');
        AX(1).Tag = 'Similarity';
        drawnow
        
        axes(AX(2))
        [han, nodes, perms] = dendrogram(linktree,0);
        title('Linkage');
        set(gca,'xtick',[]);
        AX(2).Tag = 'Linkage';
        drawnow
        
        axes(AX(3))
        imagesc(similarity(perms,perms));
        title('Similarity sorted');
        set(gca,'YDir','normal');
        AX(3).Tag = 'Similarity_sorted';
        drawnow
        
%         testmethod = 'dunn';
        testmethod = 'davies';
        Nclust = cluster_detection(linktree, similarity, testmethod, F);
        COL.raster = custom_color_gradient([0 0.6706 0.6235], [0.851 0.3255 0.0980], Nclust);
        d = guidata(F);
        d.COL = COL;
        guidata(d.F, d);
        disp(['Recommended number of Clusters: ',num2str(Nclust)]);
        cluster_assignment = cluster(linktree,'maxclust',Nclust);
        
        cluidx = 1:numel(cluster_assignment);
        for iclu = 1:Nclust
            mask = cluster_assignment == iclu;
            CLU(iclu).samples = cluidx(mask);
            CLU(iclu).start_end = start_end(mask,:);
            CLU(iclu).peak_size = peak_size(mask);
        end
        replot_raster(F, B, CLU, COL);
        replot_coactivity(F, SYNC, CLU, COL);
        [PaS, zones] = peaks_and_stimuli(CLU, SAMP.stage(istage),exptype);
        
        AX2 = autoaxes(F,1,3,[0.5 0.001 0.3 0.4], [0.025 0.025]);
        plot_clusters_and_zones(PaS, zones, AX2);
        set(AX2(3),'visible','off');
        [CLU, structure] = rois2clusters(B, CLU);
        plot_rois_in_clusters(structure, F, CLU, B);
        disp('DONE');
    otherwise
        [TVall, STIMSAMP] = temporal_vectors_durstim(B, samples, STIMSAMP, slist);
        
        t = toc;
        fprintf(['STEP 2 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf('\n');
        
        fprintf('STEP 3 - TF-IDF NORMALIZATION\n');
        fprintf('\n');
        tic;
        TFIDF = tfidf(TVall);
        sz_tfidf = size(TFIDF);
        t = toc;
        fprintf(['STEP 3 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf(['TFIDF matrix generated. Number of significant time vectors is ',...
            num2str(sz_tfidf(2)),'/',num2str(sz_M(2)),'\n']);
        fprintf('\n');
        
        fprintf('STEP 4 - SIMILARITY MATRIX ESTIMATION\n');
        fprintf('\n');
        P = 5;
        % fprintf(['Performing ',num2str(PAR.Nshuffle),' shuffles across columns\n']);
        tic;
        PAR.Nshuffle = 100;
        [thr, SMAP_real, COMAP_real] = similaritythreshold(TFIDF, PAR.Nshuffle, P, 1);
        t = toc;
        if tosave
            set(gcf,'units', 'normalized', 'position', [0.0807 0.105 0.86 0.735])
            saveas(gcf,[saveloc,'\2_similarity_map.fig']);
            print('-r600',gcf,[saveloc,'\2_similarity_map'],'-dpng');
            pause(5)
        end
        fprintf(['STEP 4 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf('\n');
        fprintf(['Maximum number of coactive cells occuring by chance is: ',num2str(thr),'\n']);
        fprintf('\n');
        
        fprintf('STEP 5 - THRESHOLDING SIMILARITY MATRIX\n');
        fprintf('\n');
        
        tic
        B = similarities_to_binary(SMAP_real, COMAP_real, thr);
        t = toc;
        fprintf(['STEP 5 - DONE. Running time: ', num2str(t), ' seconds\n']);
        figure;imagesc(B);
        if tosave
            saveas(gcf,[saveloc,'\3_similarity_map_binary.fig']);
            print('-r600',gcf,[saveloc,'\3_similarity_map_binary'],'-dpng');
            pause(5)
        end
        title('Thresholded similarity matrix');
        fprintf('\n');
        
        fprintf('STEP 6 - ESTIMATING SVD\n');
        fprintf('\n');
        tic
        [redB, s, S, U, V] = svd_components(B);
        t = toc;
        if tosave
            saveas(gcf,[saveloc,'\4_ensembles.fig']);
            print('-r600',gcf,[saveloc,'\4_ensembles'],'-dpng');
            pause(5)
        end
        fprintf(['STEP 6 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf('SVD PROCESSED. B COMPONENTS CALCULATED (6) \n');
        fprintf('\n');
        
        fprintf('STEP 7 - DECODING ENSEMBLES\n');
        fprintf('\n');
        tic;
        [ENS] = ensemble_decoding(redB, TFIDF, STIMSAMP);
        t = toc;
        
        %plotting stimuli distribution for ensembles
        ensemble_histograms(ENS, PAR.stimlist);
        if tosave
            saveas(gcf,[saveloc,'\5_ensemble_stimuli.fig']);
            print('-r600',gcf,[saveloc,'\5_ensemble_stimuli'],'-dpng');
            pause(5)
        end
        
        fprintf(['STEP 7 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf('\n');
        
        fprintf('STEP 8 - UNPACKING ENSEMBLES\n');
        fprintf('\n');
        tic;
        [TVens, ROIids] = ensemble_unpacking(redB, TFIDF);
        t = toc;
        if tosave
            saveas(gcf,[saveloc,'\6_ensemble_vectors.fig']);
            print('-r600',gcf,[saveloc,'\6_ensemble_vectors'],'-dpng');
            pause(5)
        end
        
        fprintf(['STEP 8 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf('\n');
        
        fprintf('STEP 9 - VISUALISING ENSEMBLES ON RASTER\n');
        fprintf('\n');
        tic;
        [F1,F2,E] = ensembles_on_raster(ENS, ras, redB, TFIDF, STIMSAMP, SYNC, Pcutoff);
        t = toc;
        fprintf(['STEP 9 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf('\n');
        if tosave
            %     saveas(F1,[saveloc,'\7_ensembles_on_raster.fig']);
            print('-r600',F1,[saveloc,'\7_ensemble_on_raster'],'-dpng');
            pause(5)
            %     saveas(F2,[saveloc,'\8_ensembles_on_raster_individual.fig']);
            print('-r600',F2,[saveloc,'\8_ensemble_on_raster_individual'],'-dpng');
            pause(5)
        end
        
        fprintf('STEP 10 - DETECTING CORE NEURONS IN THE ENSEMBLES\n');
        fprintf('\n');
        tic;
        [Core] = ensemble_cores(TFIDF, E, STIMSAMP);
        t = toc;
        fprintf(['STEP 10 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf('\n');
        
        fprintf('STEP 11 - VISUALISING ENSEMBLES ON DFF traces\n');
        fprintf('\n');
        tic
        F = ensembles_on_traces(E,ex,STIMSAMP,istage,Core);
        t = toc;
        fprintf(['STEP 11 - DONE. Running time: ', num2str(t), ' seconds\n']);
        fprintf('\n');
        if tosave
            for iF = 1:numel(F)
                print('-r600',F(iF),[saveloc,'\9_ensemble_on_dff_',num2str(iF)],'-dpng');
                pause(5)
            end
        end
end

function replot_raster(F, B, CLU, COL)
d = guidata(F);
ch = get(F, 'Children');
ax = ch(ismember({ch.Tag},'raster'));
raster_time = d.raster_x;
cla(ax);

B_template = B;
B_other = zeros(size(B));
for iclu = 1:numel(CLU)
    mask = zeros(size(B));
    clu = CLU(iclu);
    for isamp = 1:numel(clu.samples)
        mask(:,clu.start_end(isamp,1):clu.start_end(isamp,2)) = 1;
    end
    B_other = B_other + mask;
    CLU(iclu).raster = B_template.*mask;
end
axes(ax);
for iclu = 1:numel(CLU)
    raster_plot(CLU(iclu).raster, raster_time,COL.raster(iclu,:));hold on
    drawnow
end
raster_plot(B_template.*~B_other,raster_time,[0.91 0.91 0.91]);
drawnow
yl = ylim;
ylim([yl(1),yl(2)+2]);
box off;

function replot_coactivity(F, COA, CLU, COL)
d = guidata(F);
ch = get(F, 'Children');
ax = ch(ismember({ch.Tag},'coactivations'));
x_axis = ax.Children(1).XData;
axes(ax);

for iclu = 1:numel(CLU)
    clu = CLU(iclu);
    for isamp = 1:numel(clu.samples)
        nanaxis = x_axis.*NaN;
        mask = logical(zeros(size(x_axis)));
        nanaxis(clu.start_end(isamp,1):clu.start_end(isamp,2)) = 1;
        x = x_axis(~isnan(nanaxis));
        mask(clu.start_end(isamp,1):clu.start_end(isamp,2)) = 1;
        plot(x,COA(mask),'Color', COL.raster(iclu,:),'linew',3); hold on;
    end
    drawnow
end

function [PS, zones] = peaks_and_stimuli(CLU, stim, flag)
if nargin < 3
    flag = 'photostim';
end
switch flag
    case 'photostim'
    zones = unique([stim.unit.zones_to]);
    case 'vis'
        fn = fieldnames(stim);
        zones = fn(startsWith(fn,'st_'));
end
Nzones = numel(zones);
zones{end+1} = 'other';

for iclu = 1:numel(CLU)
    clu = CLU(iclu);
    PS.cluster(iclu).zone = {};
    for ipeak = 1:numel(clu.samples)
        samps = clu.start_end(ipeak,1):clu.start_end(ipeak, 2);
        registered = 0;
        for izone = 1:Nzones
            memb = ismember(samps,stim.(zones{izone}));
            if any(memb)
                PS.cluster(iclu).zone{numel(PS.cluster(iclu).zone)+1} = zones{izone};
                registered = 1;
                break
            end
        end
        if ~registered
            PS.cluster(iclu).zone{numel(PS.cluster(iclu).zone)+1} = zones{end};
        end
    end
end

function plot_clusters_and_zones(ps, zones, ax)
d = guidata(get(ax(1), 'Parent'));
Nclu = numel(ps.cluster);

for iclu = 1:Nclu
    N = numel(ps.cluster(iclu).zone);
    for izone = 1:numel(zones)
        Y(iclu,izone) = sum(ismember(ps.cluster(iclu).zone, zones{izone}));
    end
    x{iclu} = ['cluster ', num2str(iclu)];
    pie_label{iclu} = ['c',num2str(iclu),': ', num2str(N)];
end

axes(ax(1));
PIE = pie(sum(Y,2),pie_label);
patchHand = findobj(gca, 'Type', 'Patch');
patchHand = flipud(patchHand);%temporary fix?
newC = d.COL.raster(1:Nclu,:);
set(patchHand, {'FaceColor'}, mat2cell(newC, ones(size(newC,1),1), 3));
title('NPeaks per Cluster')
% ax(1).View = [120 90];


text_handles = PIE(2:2:end);
for ihandle = 1:numel(text_handles);
    text_handles(ihandle).Rotation = 45;
end

y = Y';
axes(ax(2));
X = categorical(x);
bar(X,(y./sum(y))','stacked');
legend(zones);
title('Ratio of events per cluster');

function [CLU, structure] = rois2clusters(B, CLU)
szB = size(B);

structure = zeros(szB(1),numel(CLU)+1);
roiidx = 1:szB(1);
for iclu = 1:numel(CLU)
    mask = false(1,szB(2));
    clu = CLU(iclu);
    for ipeak = 1:numel(clu.samples)
        mask(clu.start_end(ipeak,1):clu.start_end(ipeak,2)) = true;
    end
    filtB = B(:,mask);
    sf = sum(filtB,2);
    roimask = sf > 0;
    CLU(iclu).ROIs = roiidx(roimask);
    structure(:,iclu) = roimask.*iclu;
end

function plot_rois_in_clusters(structure, F, CLU, B)
axes(F,'Position',[0.8410 0.0405 0.1330 0.6345]);
d = guidata(F);

Nclusters = numel(CLU);
Nrois = numel(B(:,1));
pcolor(structure);
colormap(gca,[1 1 1;d.COL.raster])
% colormap(gca,[1 1 1;colors])
xticks(1.5:Nclusters+0.5)
xticklabels(1:Nclusters)
yticks(1.5:10:Nrois+0.5)
yticklabels(1:10:Nrois)
ylabel('neuron #')
xlabel('ensemble #')