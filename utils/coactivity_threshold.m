function Thr = coactivity_threshold(sync, maxsync, pval, toplot, fig)
%Thr = coactivity_threshold(sync, maxsync, pval, toplot) - estimates the coactivity
%threshold from the random shuffle data in sync, with respect of the
%requested threshold probability pval.
%
%INPUTS:
%       sync - vector or matrix of synchronization curves from data
%       shuffling. each row is a result of one shuffle
%       pval - the significance criteria (default 0.01)
%       maxsync - maximum synchronization in original data
%       toplot - logical 1 or 0 indicating whether the results should be
%       visualized
%
%OUTPUTS:
%       Thr - the estimated synchronization threshold, above which the
%       synchronizations should be considered significant with the level of
%       pval.
%part of ZENITH
if nargin < 5 | isempty(fig)
    mainfigure = 0;
else
    mainfigure = 1;
end

if nargin < 3
    pval = 0.01;
end
if nargin < 4
    toplot = 0;
end

sz = size(sync);
nshuffle = sz(1);
linaxis = 0:0.1:maxsync;
NCP = zeros(nshuffle, numel(linaxis));


for ishu = 1:nshuffle
    counts = histc(sync(ishu,:),linaxis);
    NCP(ishu,:) = cumsum(counts)/sum(counts);%Normalized Cumulative Probability
end
NCPmean = mean(NCP);

th_idx = find(NCPmean>=(1-pval),1,'first');
Thr = linaxis(th_idx);

if mainfigure
    AX = axes(fig,'Position',[0.0268 0.0654 0.2151 0.2574]);
    plot(linaxis, NCP, '-','Color',[0.6 0.6 0.6]); hold on
    plot(linaxis,NCPmean,'k-');
    plot([Thr,Thr],[0,1],'r-');
    xlabel('Coactivity count');
    ylabel('Probability');
    drawnow
else
    
    if toplot
        figure;plot(linaxis,NCPmean,'k-'); hold on
        plot([Thr,Thr],[0,1],'r-');
        xlabel('Coactivity count');
        ylabel('Probability');
    end
end