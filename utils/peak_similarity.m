function [similarity, linktree] = peak_similarity(TV, distmethod, linkagemethod)
% [similarity, linktree] = peak_similarity(TV, distmethod, linkagemethod) - estimate 
% similarity of the peaks gathered in the vmatrix TV.
% TV matrix has to be arranged in such a way that one row represents one
% ROI
%
% INPUTS:
%       TV - temporal vector matrix where one row is one ROI!
%       distmethod - method used to estimate the distance between the rows
%           all possible cases are listed in MatLab function pdist
%       linkagemethod - method used to estimate linkage of the distances
%           between vector pairs, all possible cases are listed in MatLab
%           function 'linkage'
%
% OUTPUTS:
%       similarity - similarity matrix for all row pairs in TV
%
% part of ZENITH
if nargin < 2
    distmethod = 'euclidean';
end
if nargin < 3
    linkagemethod = 'ward';
end
alldistmethods = {'euclidean', 'squaredeuclidean','seuclidean','mahalanobis',...
    'cityblock','minkowski','chebychev','cosine','correlation','hamming',...
    'jaccard','spearman'};
alllinkagemethods = {'average','centroid', 'complete', 'median', 'single', 'ward','weighted'};
TV = TV'; %transposition of the TV matrix so that each row represents a time vector
TVsize = size(TV);
if TVsize(1) < 1
    sim = [];
    disp('not enough temporal vectors to estimate similarities! Terminating!');
    return
end
if ~ismember(distmethod,alldistmethods)
    disp('distance estimate method specified is not correct! Terminating');
    return
end
if ~ismember(linkagemethod,alllinkagemethods)
    disp('linkage estimate method specified is not correct! Terminating');
    return
end
distance = squareform(pdist(TV,distmethod));

switch distmethod
    case {'cosine','correlation','spearman','hamming','jaccard'}
        similarity = 1 - distance;
    otherwise
        similarity = 1 - distance/max(distance(:)); % Normalization
end

linktree = linkage(squareform(1-similarity,'tovector'),linkagemethod);