function [si] = norminprod(a, b)
% [scoef] = norminprod(a, b) calculates the similarity index between
% pairs of vectors by their normalized inner product, which represents the
% cosine of the angles between two vectors
%
%   INPUTS:
%       a - vector #1
%       b - vector #2
%
%   OUTPUT:
%       si - similarity index
%
%Part of ZENITH methods

si = dot(a,b)/(norm(a)*norm(b));