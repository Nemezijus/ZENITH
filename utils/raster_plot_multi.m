function raster_plot_multi(ncell, ex, M, T, onoff)
% raster_plot_multi(ncell, iroi, istage, istim) - creats raster plots of
% single cell or the complete cell population
%
%   INPUTS:
%       ex - experiment object
%       M - giga network spikeprob matrix
%       (ncell - 'single' or 'population'(string))
%       istage - number of the chosen stage (optional)
%       (iroi - number of the chosen cell(optional))
%       (istim - number of the chosen stimulus(optional))
%
%   OUTPUTS:
%       -
%see also raster_plot, probability_to_binary, export_spikes_woopsi
%Part of ZENITH utils


switch ncell
    case 'single'
        [m,t] = export_spikes_woopsi(ex, iroi, istage, istim);
        B = probability_to_binary(m);
        [f,r] = raster_plot(B, t.time(1,:));
        
    case 'population'
        % "STITCHING" TIME TOGETHER (in min)
        minute_multiplier = 1e-4;
        start = T(1)*minute_multiplier;
        stop = T(end)*minute_multiplier*ex.N_stim(1)*ex.N_reps(1);
        stepsize = numel(T);
        Time = linspace(start, stop, stepsize*ex.N_stim(1)*ex.N_reps(1));
        % BINARIZATION
        B = probability_to_binary(M);
        % RASTER STRIKE
        F = figure;
        set(F,'units', 'normalized', 'position', [0.174 0.406 0.643 0.354]);
        AX1 = axes; ax_refpos = get(AX1, 'Position');
        AX2 = axes;
        AX1.Position([2,4]) = [AX1.Position(2) + 0.15 AX1.Position(4) - 0.15];
        AX2.Position = ax_refpos;
        AX2.Position(4) = 0.15;
        axes(AX1)
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
        % PATCH
        color = [.7 .7 .7];
        stepsize = numel(T);
        onoffstep = onoff(2)-onoff(1);
        minute_multiplier = 1e-4;
        y1 = get(AX1, 'Ylim'); y2 = get(AX2, 'Ylim');
        y1 = [y1(1), y1(1), y1(2), y1(2)];
        y2 = [y2(1), y2(1), y2(2), y2(2)];
        for istart = onoff(1):stepsize+1:numel(Time(1,:))
            x = [Time(istart), Time(istart+onoffstep), Time(istart+onoffstep), Time(istart)];
            p1(istart) = patch(AX1, x, y1, color, 'FaceAlpha', 0.5);
            p2(istart) = patch(AX2, x, y2, color, 'FaceAlpha', 0.5);
            set(p1(istart), 'EdgeColor', 'none');
            set(p2(istart), 'EdgeColor', 'none');
        end
        AX1.XTickLabel = {};
        AX1.YLim = [0 numel(B(:,1))];
        [stim_order_v] = export_stimulus_order(ex.restun{1});
        AX2.XTick = linspace(Time(1),Time(end), 90);
        AX2.XLim = [Time(1) Time(end)];
        AX2.FontSize = 5;
        AX2.XTickLabel = num2cell(stim_order_v);
end