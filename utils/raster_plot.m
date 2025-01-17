function [F,r] = raster_plot(M,x_axis,col)
% [F,r] = raster_plot(M,x_axis) - raster plot of the binary matrix M
%
%   INPUTS:
%       M - binary matrix
%       x_axis - corresponding x (time) axis. If not specified it is provided in samples
%       col - color
%
%   OUTPUTS:
%       F - handle to the figure
%       r - handle to raster plots (struct)
%
%see also probability_to_binary
%Part of ZENITH utils

if nargin < 2 | isempty(x_axis)
    x_axis = 1:numel(M(1,:));
end
if nargin < 3
    F = figure;
    set(F,'units', 'normalized', 'position', [0.174 0.406 0.643 0.354]);
    col = 'k';
end
% F = gcf;
% AX = axes;
for im = 0:numel(M(:,1))-1
    spikes = M(im+1,:);
    spikes(spikes == 0) = NaN;
    
    xPoints = [ x_axis;
        x_axis;
        NaN(size(x_axis)) ];
    yPoints = [ spikes - 0.3 + im;
        spikes + 0.3 + im;
        NaN(size(spikes)) ];
    xPoints = xPoints(:);
    yPoints = yPoints(:);
    r(im+1) = plot(xPoints,yPoints,'color',col,'linew',3);hold on
end
% plot([0.9*10^4 0.9*10^4], get(AX, 'ylim'), 'r-');
% plot([1.7*10^4 1.7*10^4], get(AX, 'ylim'), 'r-');