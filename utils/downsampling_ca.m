function [m, t, io] = downsampling_ca(binsize, ex, iroi, istage, istim, irep)
% [M, T, IO, fs] = downsampling_ca(binsize, ex, iroi, istage, istim, irep)
% downsamples dff calcium traces to lower binsize, if binsize = 1, no
% modification is carried out on the data
%
% INPUTS:
%       binsize - integer value of binning
%       ex - experiment object
%       iroi - number of roi
%       istage - number of stage
%       istim - number of stimuli (0-all)
%       irep - number of repetitions (0-all)
%       
% OUTPUTS:
%       m - vector containing the binned data (corresponds to a single
%       repetition)
%       t - time vector containing corresponding timeline
%       io - indices of stimuli on- and off-sets in the time vector
%
%See also generate_network_spikes, export_spikes_woopsi
%Part of ZENITH utils
 
if nargin < 6
    irep = 0;
end


if any(ex.N_stim)
    % Waveform object - we only need a reference time
    W = traces(ex, [iroi, istage, istim, irep], 'dff');
else
    % Waveform object - we only need a reference time
    W = ex.stitch(iroi, istage, 'dff');
end
m = [];

if binsize ~= 1
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
            if icol == size(W.data,2) && binsize ~= 1
                break
            elseif icol == size(W.data,2) && binsize == 1
                binned = W.data(irow,icol);
                binned_line = [binned_line,binned];
                break
            end
            binned = mean(W.data(irow,icol:icol+binsize));
            binned_line = [binned_line,binned];
        end
        m = [m; binned_line];
    end
end

% Reset time
reftime = linspace(W.time(1,1), W.time(1,end), numel(W.time(1,:)));
t = reftime;

if any(ex.N_stim)  
    % H5 attribute readout
    dataroot = ['/',ex.paths{2,1}];
    STAGEstr = [ex.paths{2,2}, num2str(istage)];
    loc = strjoin({dataroot, STAGEstr},'/');
    stimtype = h5readatt(ex.file_loc, loc, 'STIMTYPE');
    
    % Timing of stimuli
    stime = visc_recall_stims(stimtype);
    
    % Time during stimuli
    reftsam = 1:numel(reftime);
    stdur_idx = reftsam(reftime >= stime.static1 & reftime <= stime.blank2);
    io = [stdur_idx(1) stdur_idx(end)];
else
    io = [NaN NaN];
end













