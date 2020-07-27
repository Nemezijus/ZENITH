function SH = spike_shuffle(SP,rule)
% SH = spike_shuffle(SP,rule) - spike train shuffling based on the
% specified rule
%
%   INPUTS:
%       SP - binary spike train [vector]
%       rule - string specifying a shuffling rule (default - 'intervals');
%
%   OUTPUTS:
%       SH - shuffled spike train
%
%Part of ZENITH source

if nargin < 2
    rule = 'intervals';
end

switch lower(rule)
    case 'intervals'
        if any(SP) | all(SP)
            idx = 1:numel(SP);
            spike_samples = idx(SP == 1);
            buffer = spike_samples(1)-1 + numel(SP)-spike_samples(end);
            intervals = diff(spike_samples);
            %1 - split buffer into new two segments (start and end)
            cutoff = randi(buffer+1);
            new_start = cutoff-1;
            %2 - shuffle the intervals
            new_intervals = intervals(randperm(length(intervals)));
            SH = zeros(size(SP));
            SH(cumsum([new_start+1,new_intervals])) = 1;
        else
            SH = SP;
        end
end