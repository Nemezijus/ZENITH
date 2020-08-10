function [TFIDF] = tfidf(TVstim)
% [tfid] = tfidf(TVstim)
%
%
%   INPUT(S):
%       TVstim -
%
%   OUTPUT(S):
%       TFIDF -
%
%Part of ZENITH

%DEFINITIONS
%TERM FREQUENCY (TF)
%measures active neurons normalized by the total number of active neurons
%for each frame
%INVERSE DOCUMENT FREQUENCY(IDF)
%measures the number of times that a neuron appears in the tital number of
%significant vectors

TFIDF = zeros(size(TVstim)); % 1 x numel(significant_vectors)
for isv = 1:size(TVstim,2)
    tf = sum(TVstim(:,isv))/numel(TVstim(:,isv));
    for iroi = 1:size(TVstim,1)
        idf = log(numel(TVstim(iroi,:))/sum(TVstim(iroi,:)));
        if isinf(idf)
            idf = 0;
        end
        TFIDF(iroi,isv) = tf*idf; 
    end
end

