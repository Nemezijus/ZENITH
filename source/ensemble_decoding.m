function [ENS] = ensemble_decoding(SMred, TFIDF, STIMSAMP)
% [ENS] = ensemble_decoding(SM, redSM, TFIDF, STIMSAMP) - remaps the participating
% significant temporal vectors based on the factorized binary matrices by
% SVD (SMred) and generates the struct of neuronal ensembles to store the
% population vectors, their original sample numbers and the corresponding stimulus id
%
%   INPUTS:
%       SM - Similarity Map Matrix (symmetric mx, rank: # population vectors)
%       SMred - Similarity Map Matrix reduced to significant SVD components
%       TFIDF - TF*IDF Matrix (# acitve cells x # population vectors)
%       STIMSAMP - Struct carrying info aiding rematching of temporal
%                   (population) vectors
%
%   OUTPUTS:
%       ENS - ENS(emble) struct containing info about detected ensembles
%
% See also ensemble_detection
% Part of ZENITH source

s = size(SMred);
counter = 1;
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
    %Part3 - Create mask for population vectors
    if isempty(pv_idx)
        continue
    else
        pv_idx = unique(pv_idx);
        pv_mask = logical(zeros(1,s(2)));
        pv_mask(pv_idx) = 1;
        %Part4 - Fill up ENSemble struct
        ENS(counter).pv = TFIDF(:,pv_mask);
        ENS(counter).samps_orig = STIMSAMP.samps_orig(pv_mask);
        ENS(counter).samps_stimid = STIMSAMP.samps_stimid(pv_mask);
        counter = counter + 1;
    end
end