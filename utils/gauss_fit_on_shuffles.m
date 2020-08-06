function [cutoff, YFit, XFit] = gauss_fit_on_shuffles(SH, Pval, toplot)
% [cutoff, Xfit, Yfit] = gauss_fit_on_shuffles(SH, Pval, toplot) - Gaussian fit on
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
[h_counts, h_units] = hist(maxSH,unique(maxSH)); 
[mu,sigma,muci,sigmaci] = normfit(maxSH);
y = normpdf(h_units,mu,sigma);
h_unitsinterp = [h_units(1):0.01:h_units(end)];
yinterp = normpdf(h_unitsinterp, mu, sigma);


pd = fitdist(maxSH,'Normal');
Plim_left = icdf(pd,Pval);
Plim_right = icdf(pd, 1-Pval);
Plim_center = icdf(pd, 0.5);

cutoff = Plim_right;
YFit = yinterp;
XFit = h_unitsinterp;

if toplot
    f = figure;
    set(f,'units', 'normalized', 'position', [0.329 0.075 0.364 0.832]);
    AX = autoaxes(f,2,1,[0.1 0.05 0.05 0.05],[0 0.05]);
    axes(AX(1));
    bar(h_units, h_counts./sum(h_counts)); hold on
    plot(h_unitsinterp, yinterp,'r-','linew',3);
    ylabel('fraction of total');
    xlabel('coactivation count');
    xlim([min(maxSH), max(maxSH)]);
    text(0.85, 0.95, ['p = ', num2str(Pval)], 'units', 'normalized');
    text(0.85, 0.85, ['thr = ', sprintf('%0.2f',Plim_right)], 'units', 'normalized','color','r');
    text(0.001, 0.85, ['thr = ', sprintf('%0.2f',Plim_left)], 'units', 'normalized');
    
    axes(AX(2));
    h = histfit(maxSH,numel(unique(maxSH)));
    xlim([min(maxSH), max(maxSH)]);
    yl = ylim;
    xl = xlim;
    hold on;
    patch([xl(1) Plim_left Plim_left xl(1)],[yl(1) yl(1) yl(2) yl(2)],...
        [0.4 0.4 0.4],'FaceAlpha',0.2,'EdgeColor', 'None');
    patch([xl(2) Plim_right Plim_right xl(2)],[yl(1) yl(1) yl(2) yl(2)],...
        [0.4 0.4 0.4],'FaceAlpha',0.2,'EdgeColor', 'None');
    ylabel('count');
    xlabel('coactivation count');
    text(0.85, 0.95, ['p = ', num2str(Pval)], 'units', 'normalized');
    text(0.85, 0.85, ['thr = ', sprintf('%0.2f',Plim_right)], 'units', 'normalized','color','r');
    text(0.001, 0.85, ['thr = ', sprintf('%0.2f',Plim_left)], 'units', 'normalized');
    
    %add gray areas to ax1
    axes(AX(1));
    yl = ylim;
    xl = xlim;
    patch([xl(1) Plim_left Plim_left xl(1)],[yl(1) yl(1) yl(2) yl(2)],...
        [0.4 0.4 0.4],'FaceAlpha',0.2,'EdgeColor', 'None');
    patch([xl(2) Plim_right Plim_right xl(2)],[yl(1) yl(1) yl(2) yl(2)],...
        [0.4 0.4 0.4],'FaceAlpha',0.2,'EdgeColor', 'None');
end

