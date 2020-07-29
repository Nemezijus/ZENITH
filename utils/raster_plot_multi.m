function raster_plot_multi(ex, M, T, onoff, SYNC_real, p_thr)
% raster_plot_multi(ncell, iroi, istage, istim) - creats raster plots of
% single cell or the complete cell population
%
%   INPUTS:
%       ex - experiment object
%       M - giga network spikeprob matrix
%       T - the short fragment of time stamp which belongs to one rep
%       onoff - starting and ending positions of visual stimulus window
%       SYNC_real -
%       p_thr - 
%
%   OUTPUTS:
%       -
%
%see also raster_plot, probability_to_binary, export_spikes_woopsi
%Part of ZENITH utils

if numel(unique(M))>2
    % BINARIZATION
    B = probability_to_binary(M);
else
    B = M;
end

% "STITCHING" TIME TOGETHER (in min)
minute_multiplier = 1e-3;
start = T(1);
stop = T(end)*ex.N_stim(1)*ex.N_reps(1);
stepsize = numel(T);
Time = linspace(start, stop, stepsize*ex.N_stim(1)*ex.N_reps(1));

% RASTER STRIKE & PLOTTING
F = figure;
set(F,'units', 'normalized', 'position', [0.174 0.406 0.643 0.354]);
AX1 = axes; ax_refpos = get(AX1, 'Position');
AX2 = axes;
AX1.Position([2,4]) = [AX1.Position(2) + 0.15 AX1.Position(4) - 0.15];
AX2.Position = ax_refpos;
AX2.Position(4) = 0.15;
axes(AX1)
%         Time = 1:size(B,2);
for im = 0:numel(B(:,1))-1
    spikes = B(im+1,:);
    spikes(spikes == 0) = NaN;
    
    xPoints = [ Time;
        Time;
        NaN(size(Time)) ];
    yPoints = [ spikes - 0.3 + im;
        spikes + 0.3 + im;
        NaN(size(spikes)) ];
    xPoints = xPoints(:);
    yPoints = yPoints(:);
    r(im+1) = plot(xPoints,yPoints,'k');
    hold on
end
axes(AX2)
plot(Time, SYNC_real, 'k');
hold on
plot(Time, p_thr*ones(1,numel(Time)), 'r--');

% PATCH
color = [.7 .7 .7];
stepsize = numel(T);
onoffstep = onoff(2)-onoff(1);
y1 = get(AX1, 'Ylim'); y2 = get(AX2, 'Ylim');
y1 = [y1(1), y1(1), y1(2), y1(2)];
y2 = [y2(1), y2(1), y2(2), y2(2)];
timeStamps = [];
for istart = onoff(1):stepsize:numel(Time(1,:))
    %             istart
    x = [Time(istart), Time(istart+onoffstep), Time(istart+onoffstep), Time(istart)];
    p1(istart) = patch(AX1, x, y1, color, 'FaceAlpha', 0.5);
    p2(istart) = patch(AX2, x, y2, color, 'FaceAlpha', 0.5);
    set(p1(istart), 'EdgeColor', 'none');
    set(p2(istart), 'EdgeColor', 'none');
    timestamp = x(1);
    timeStamps = [timeStamps, timestamp];
end

% X AXIS
[stim_order_v] = export_stimulus_order(ex.restun{1});
AX1.YLim = [0 numel(B(:,1))];
AX2.XTick = timeStamps;
AX2.XTickLabel = num2cell(stim_order_v(1:end));
AX2.XTickLabelRotation = 90;
AX1.FontSize = 5;
AX2.FontSize = 5;
%         set(AX1, 'TickLength', [0 0]);
AX1.XTick = [];
set(AX2, 'TickLength', [0 0]);






