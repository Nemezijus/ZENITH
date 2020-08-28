function [ENS] = ensemble_decoding(SMred, TFIDF, STIMSAMP)
% [] = ensemble_decoding(SM, redSM, TFIDF, STIMSAMP) -
%
%
%   INPUTS:
%       SM - Similarity Map Matrix (symmetric mx, rank: # population vectors)
%       SMred - Similarity Map Matrix reduced to significant SVD components
%       TFIDF - TF*IDF Matrix (# acitve cells x # population vectors)
%       STIMSAMP - Struct carrying info aiding rematching of temporal
%                   (population) vectors
%
%   OUTPUTS:
%
%
% See also
% Part of ZENITH source

s = size(SMred);
for n = 1:s(1)
    %Part1 - Multidimensional array unpacking
    SVD(:,:) = SMred(n,:,:);
    SVDtri = triu(SVD);
    %Part2 - Loop trough SMred-red-red
    pv_idx = [];
    for vit = 1:s(2)-1
        if sum(SVDtri(vit,:)) > 0
            pv_idx = [pv_idx, vit];
            nvit = vit+1:s(2);
            for vjt = nvit
                if SVDtri(vit, vjt)
                    pv_idx = [pv_idx, vjt]; 
                end
            end
        end
    end
    
pv_idx = unique(pv_idx);
pv_mask = logical(zeros(1,s(2)));
pv_mask(pv_idx) = 1;

ENS(n).pv = TFIDF(:,pv_mask);
ENS(n).samps_orig = STIMSAMP.samps_orig(pv_mask);
ENS(n).samps_stimid = STIMSAMP.samps_stimid(pv_mask);
end