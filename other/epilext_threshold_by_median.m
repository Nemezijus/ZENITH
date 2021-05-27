function [medhold] = epilext_threshold_by_median(v)
% [] = epilext_threshold_by_median(v)
% calculates the median and the absolute deviation from the mediaon of the
% data in (column) vector v
%
%   INPUTS
%       v - column vector
%
%   OUTPUTS
%       medhold - median threshol, which is the median + 3x the deviation
%                 of median
%
%Part of ZENITH\other


v_ad = zeros(numel(v),1);
m = median(v);
for n=1:numel(v)
    v_ad(n) = abs(v(n) - m);
end
mad = median(v_ad);
medhold = m + (3*mad);