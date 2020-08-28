function [B,redB,s,TFIDF,STIMSAMP] = ensemble_detection(ex,M,istage)
% ensemble_detection(ex,M,istage) - parent function that processes spiking
% activity of experiment and estimates the ensembles within the population
%
%   INPUTS:
%       ex - experiment object
%       M - spiking matrix
%       istage - stage identifier
%
%part of ZENITH
sz_M = size(M);
fprintf('STEP 1 - SYNCHRONIZATION ESTIMATES\n');
fprintf('\n');
tic;
[SYNC, Pcutoff, B, SYNC_shuffled, STIMSAMP, PAR] = networkactivity_fullproc(ex, istage, M);
t = toc;
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
[thr, SMAP_real, COMAP_real] = similaritythreshold(TFIDF, PAR.Nshuffle, P, 1);
t = toc;
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
title('Thresholded similarity matrix');
fprintf('\n');

fprintf('STEP 6 - ESTIMATING SVD\n');
fprintf('\n');
tic
[redB, s, S, U, V] = svd_components(B);
t = toc;
fprintf(['STEP 6 - DONE. Running time: ', num2str(t), ' seconds\n']);
fprintf('SVD PROCESSED. B COMPONENTS CALCULATED (6) \n');
fprintf('\n');





