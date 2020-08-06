function [YFit, Xfit, cutoff] = gauss_fit_on_shuffles(SH, Pval, toplot)
% [Fit, cutoff] = gauss_fit_on_shuffles(SH, Pval, toplot) - Gaussian fit on
% the distribution of max shuffles in SH matrix.
%
%   INPUTS:
%       SH - Shuffle matrix
%       Pval - significance cutoff value
%       toplot - logical indicator whether to plot or not
%
%   OUTPUTS:
%       YFit - Gauss fit Y values
%       XFit - Gauss fit X values
%       cutoff - the cutoff value for the requested significance P

if nargin < 3
    toplot = 0;
end
if nargin < 2
    Pval = 0.01;
end

maxSH = max(SH,[],2);

