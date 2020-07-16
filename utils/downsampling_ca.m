function [M, T, IO] = downsampling_ca(binsize, ex, iroi, istage, istim, irep)
% DESCRIPTION LATER


% 20/07/13 
% - place the extraction of traces outside of this function
% - make it scalable
% Modified from downsampling_ca(binsize, ex, iroi, istage, istim, irep)
 
if nargin < 6
    irep = 0;
end

W = traces(ex, [iroi, istage, istim, irep], 'dff');
M = [];

% Define start col
if logical(mod(size(W.data,2),binsize))
    r = rem(size(W.data,2),binsize);
    start = r;
else
    start = 1;
end

% Binning
for irow = 1:size(W.data,1)
    binned_line = [];
    for icol = start:binsize:size(W.data,2)
        if icol == size(W.data,2)
            break
        end
        binned = mean(W.data(irow,icol:icol+binsize));
        binned_line = [binned_line,binned];
    end
    M = [M; binned_line];
end

% Stimuli export
h5floc = 'N:\DATA\Betanitas\!Mouse Gramophon\2_Imaging\group30\30A1 (112, Máté)\Other\m30A_1.h5';
% h5 attribute readout
dataroot = ['/',ex.paths{2,1}];
STAGEstr = [ex.paths{2,2}, num2str(istage)];
loc = strjoin({dataroot, STAGEstr},'/');
stimtype = h5readatt(h5floc, loc, 'STIMTYPE');
% visc - finer details
stime = visc_recall_stims(stimtype);

% Reset time
reftime = linspace(W.time(1,1), W.time(1,end), numel(M(1,:)));
reftsam = 1:numel(reftime);
stdur_idx = reftsam(reftime >= stime.static1 & reftime <= stime.blank2);
start = reftime(stdur_idx(1));
stop = reftime(stdur_idx(end));
IO = [stdur_idx(1) stdur_idx(end)];
T = reftime;









