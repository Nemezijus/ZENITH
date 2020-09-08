function [ENS] = ensemble_cores(TFIDF, E, STIMSAMP, toplot)
% [ENS] = ensemble_cores(TFIDF, E, STIMSAMP) - returns a struct which
% contains the tfidf matrix of the most representative neurons and the
% number of these core neurons
%
%   INPUTS:
%       TFIDF - TFIDF Matrix of the significant vectors (sv)
%       E - E(nsemble) struct containing most similiar sv pairs with
%           the participating roi numbers
%       STIMSAMP - Struct containing useful data regarding stimulus and
%                   sample sizes
%       toplot - zero by default
%
%   OUTPUTS:
%       ENS - Struct containing data about the most representative core
%               neurons of each ensembles
%
%See also ensemble_detection, ensemble_on_traces
%Part of ZENITH source
if nargin < 4
    toplot = 0;
end

sE = size(E); %E-pair-samples,rois
sTI = size(TFIDF);
EN = zeros([sTI(1) sTI(2) sE(2)]); %rois x singif vecs x ensebmles
mask_iorig = STIMSAMP.samps_orig;
mask_stim = STIMSAMP.samps_stimid;
mask_isignif = 1:numel(mask_iorig);
for n = 1:sE(2)
    ENSEMBLE = [];
    ens_stim = zeros(1,numel(mask_stim));
    for mp = 1:size(E(n).pair, 2)
        proi = E(n).pair(mp).rois';
        pvec_orig = E(n).pair(mp).samples;
        pvec_signif = [mask_isignif(mask_iorig == pvec_orig(1)),...
            mask_isignif(mask_iorig == pvec_orig(2))];
        EN(proi,pvec_signif,n) = 1;
        ens_stim(:,pvec_signif) = [mask_stim(mask_iorig == pvec_orig(1)),...
            mask_stim(mask_iorig == pvec_orig(2))];
    end
    ENSEMBLE(:,:) = EN(:,:,n); % cut out ensemble from multiarray
    % Delete all zero columns
    % todel = all(~ENSEMBLE,1);
    % ENSEMBLE(:,todel) = [];
    % ens_stim(:,todel) = [];
    
    % Construct ensemble struct
    ens_tfidf = tfidf(ENSEMBLE); % tfidf
    ens_tfidf(isnan(ens_tfidf))=0;
    prc = 99;
    x = prctile(prctile(ens_tfidf, prc), prc);
    ENS(n).core = ens_tfidf.* double(ens_tfidf>= x); % filtering: highest ranked values from all the population vectors (pvs)
    ens_rois = repmat((1:sTI(1))', 1, sTI(2)); % collecting the number of core rois
    rois = sort( (ens_rois .* double(ENS(n).core > 0)) , 'descend');
    core = [];
    for vi = 1:sTI(2)
        %         if any(rois(:,vi))
        %             ENS(n).core_rois{vi} = rois(rois(:,vi)>0,vi);
        core = [core, rois(rois(:,vi)>0,vi)'];
        %         else
        %             ENS(n).core_rois{vi} = [];
        %         end
    end
    ENS(n).core_allroi = unique(core);
    % During domstim
    domstim = mode(ens_stim);
    logical_domstim = ens_stim == domstim;
    ENS(n).domstim = domstim;
    ENS(n).core_domstim = ENS(n).core(:,logical_domstim);
    
    if toplot
        figure;
        hax1 = imagesc(ens_tfidf);
        hax1.Parent.Title.String = ['Neurons of ensemble', num2str(n)];
        figure;
        hax2 = imagesc(ENS(n).core);
        hax2.Parent.Title.String = ['Most representative neurons (core) of ensemble', num2str(n)];
    end
end