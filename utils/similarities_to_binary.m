function B = similarities_to_binary(M, thr)
% B = similarities_to_binary(M, thr) - converts similarity vectors (matrix
% M) to binary matrix B after thresholding the values with thr
%
%   INPUTS:
%       M - similarity matrix (one column - one significant time instance)
%       thr - threshold (see similaritythreshold)
%
%   OUTPUT:
%       B - binary matrix of thresholded similarities
%
%part of ZENITH

B = double(M>thr);