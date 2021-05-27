function epilext_rasterplot(B, SYNC_real, pa, iis, p_thr, m_thrs)
% raster_plot_multi(ncell, iroi, istage, istim) - creats raster plots of
% single cell or the complete cell population
%
%   INPUTS:
%       B - giga network BINARY matrix
%       SYNC_real - synchronization vector of real data M
%       pa - column vector containing population activity
%       iis - binary column vector containing interictalspike presence
%       p_thr - number of synchronizations threshold below which
%               synchronizations happen by chance (gauss fit method)
%       m_thrs - number of synchronizations threshold below which synch
%                happen by chance (median method)
%
%Part of ZENITH\other


% x axis (would corresponds to time) given in samples
x_axis = 1:numel(B(1,:));


% RASTER STRIKE & PLOTTING
F = figure;
set(F,'Units', 'normalized', 'Position', [0.174 0.406 0.643 0.354]);
AX1 = axes; ax_refpos = get(AX1, 'Position');
AX2 = axes;
AX3 = axes;
AX1.Position([2,4]) = [AX1.Position(2) + 0.3 AX1.Position(4) - 0.3];
AX2.Position = ax_refpos;
AX2.Position([2,4]) = [AX2.Position(2) + 0.15 0.15];
AX3.Position = ax_refpos;
AX3.Position(4) = 0.15;
axes(AX1)
for im = 0:numel(B(:,1))-1
    spikes = B(im+1,:);
    spikes(spikes == 0) = NaN;
    xPoints = [ x_axis;
        x_axis;
        NaN(size(x_axis)) ];
    yPoints = [ spikes - 0.3 + im;
        spikes + 0.3 + im;
        NaN(size(spikes)) ];
    xPoints = xPoints(:);
    yPoints = yPoints(:);
    r(im+1) = plot(xPoints,yPoints,'k');
    hold on
end
axes(AX2)
plot(x_axis, SYNC_real, 'k');
hold on
plot(x_axis, p_thr*ones(1,numel(x_axis)), 'r-');
plot(x_axis, m_thrs(1)*ones(1,numel(x_axis)), 'r--');
axes(AX3)
plot(x_axis, pa, 'k');
hold on
plot(x_axis, p_thr*ones(1,numel(x_axis)), 'r-');
plot(x_axis, m_thrs(2)*ones(1,numel(x_axis)), 'r--');



% PATCH
% color = [.1 .1 .1];
% y1 = get(AX1, 'Ylim'); y2 = get(AX2, 'Ylim'); y3=get(AX3, 'Ylim');
% y1 = [y1(1), y1(1), y1(2), y1(2)];
% y2 = [y2(1), y2(1), y2(2), y2(2)];
% y3 = [y3(1), y3(1), y3(2), y3(2)];
% sum_iis= sum(iis);
% xloc_iis = x_axis(logical(iis));
% for niis=1:sum_iis 
%     x = [xloc_iis(niis), xloc_iis(niis)+0.5, xloc_iis(niis)+0.05, xloc_iis(niis)];
%     p1(niis) = patch(AX1, x, y1, color, 'FaceAlpha', 0.9);
%     set(p1(niis), 'EdgeColor', 'none');
%     p2(niis) = patch(AX2, x, y2, color, 'FaceAlpha', 0.9);
%     set(p2(niis), 'EdgeColor', 'none');
%     p3(niis) = patch(AX3, x, y3, color, 'FaceAlpha', 0.9);
%     set(p3(niis), 'EdgeColor', 'none');
% end
% linkaxes([AX1, AX2, AX3], 'x');


% X AXIS
AX1.XTick = [];
AX1.XTickLabel = [];
AX2.XTick = [];
AX2.XTickLabel = [];


% AXIS INSCRIPTIONS
AX1.YLabel.String = 'active cell #';
AX1.YLabel.FontSize = 6;
AX2.YLabel.String ='co-cells';
AX2.YLabel.FontSize = 6;
AX3.YLabel.String ='cell activity %';
AX3.YLabel.FontSize = 6;
AX3.XLabel.String = 'time';
AX3.XLabel.FontSize = 6;