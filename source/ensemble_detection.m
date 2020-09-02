function [B,redB,s,TFIDF,STIMSAMP, ENS, ras,SYNC,Pcutoff, E] = ensemble_detection(ex,M,istage,saveloc)
% ensemble_detection(ex,M,istage) - parent function that processes spiking
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

sz_M = size(M);
fprintf('STEP 1 - SYNCHRONIZATION ESTIMATES\n');
fprintf('\n');
tic;
[SYNC, Pcutoff, B, SYNC_shuffled, STIMSAMP, PAR] = networkactivity_fullproc(ex, istage, M);
ras = B; %raster
t = toc;
if tosave
    saveas(gcf,[saveloc,'\1_raster_plot.fig']);
    print('-r600',gcf,[saveloc,'\1_raster_plot'],'-dpng');
    pause(5)
end
fprintf(['STEP 1 - DONE. Running time: ', num2str(t), ' seconds\n']);
fprintf('\n');
fprintf(['Estimated threshold for synchronizations: ',num2str(Pcutoff),'\n']);
fprintf('\n');

fprintf('STEP 2 - TEMPORAL VECTOR CREATION\n');
fprintf('\n');
tic;
[TV, TVred, samples] = temporal_vectors(B, SYNC, Pcutoff, PAR);
c_restun = ex.restun{istage};
slist = export_stimulus_order(c_restun);
[TVstim, STIMSAMP] = temporal_vectors_durstim(B, samples, STIMSAMP, slist);
t = toc;
fprintf(['STEP 2 - DONE. Running time: ', num2str(t), ' seconds\n']);
fprintf('\n');

fprintf('STEP 3 - TF-IDF NORMALIZATION\n');
fprintf('\n');
tic;
TFIDF = tfidf(TVstim);
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
ensemble_histograms(ENS);
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

fprintf('STEP 10 - VISUALISING ENSEMBLES ON DFF traces\n');
fprintf('\n');
tic
F = ensembles_on_traces(E,ex,STIMSAMP,istage);
t = toc;
fprintf(['STEP 10 - DONE. Running time: ', num2str(t), ' seconds\n']);
fprintf('\n');
if tosave
    for iF = 1:numel(F)
        print('-r600',F(iF),[saveloc,'\9_ensemble_on_dff_',num2str(iF)],'-dpng');
        pause(5)
    end
end