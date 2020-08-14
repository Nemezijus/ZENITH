function [TFIDF] = tfidf(TVstim)
% [tfid] = tfidf(TVstim) calculates tf*idf values for each roi within each
% significant vectors during stimulus
%
%   INPUT(S):
%       TVstim - significant temporal vectors happening during the visual
%       stimulation window
%
%   OUTPUT(S):
%       TFIDF - matrix containing the tf-idf values
%
%Part of ZENITH source

%DEFINITIONS
%TERM FREQUENCY (TF)
%measures active neurons normalized by the total number of active neurons
%for each frame
% @(a,n)1/sum(a(:,n))
% @(a,n)log10(1+sum(a(:,n)))
% @(a,n)1+log10(sum(a(:,n)))
%INVERSE DOCUMENT FREQUENCY(IDF)
%measures the number of times that a neuron appears in the tital number of
%significant vectors
% @(a,n)log10(numel(a(n,:))/sum(a(n,:)))
% @(a,n)log10(numel(a(n,:))/(1+sum(a(n,:))))+1
% @(a,n)log10(1+numel(a(n,:))/sum(a(n,:)))
% @(a,n)log10(numel(a(n,:))/sum(a(n,:)))+1

TFIDF = zeros(size(TVstim)); % 1 x numel(significant_vectors)
for isv = 1:size(TVstim,2)
%     tf = sum(TVstim(:,isv))/numel(TVstim(:,isv));
    tf = 1/sum(TVstim(:,isv));
    for iroi = 1:size(TVstim,1)
        idf = log10(numel(TVstim(iroi,:))/sum(TVstim(iroi,:))) + 1;
        if isinf(idf)
            idf = 0;
        end
        TFIDF(iroi,isv) = tf*idf; 
    end
end

