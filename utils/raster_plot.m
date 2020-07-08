function [F,r] = raster_plot(M,x_axis)
% [F,r] = raster_plot(M,x_axis) - raster plot of the binary matrix M
%
%   INPUTS:
%       M - binary matrix
%       x_axis - corresponding x (time) axis. If not specified it is provided in samples
%
%   OUTPUTS:
%       F - handle to the figure
%       r = handle to raster plots (struct)
%
%see also probability_to_binary
%Part of ZENITH source

if nargin < 2
    x_axis = 1:numel(M(1,:));
end
F = figure;
set(F,'units', 'normalized', 'position', [0.174 0.406 0.643 0.354]);

AX = axes;
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
    r(im+1) = plot(xPoints,yPoints,'k');hold on
end
