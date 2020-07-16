function [MM, T, onoff] = export_spikes_woopsi(ex, iroi, istage, istim, irep, Params)
% M = export_spikes_woopsi(ex,iroi,istage,istim,V) - extracts spiker from experiment object ex, and
% stores the spike probabilites in a matrix M.
%
%  INPUTS:
%       exdata - experiment object
%       iroi - number of desired roi (loop through all)
%       istage - number of desired stage (between 1-6)
%       istim - number of desired stimulus (between 1-9)
%       irep - number of desired repetitions, 0 by default -> extract all
%       traces into waveform object
%       Params - parameters necessary to define to fast_oopsi to work properly
%           - ifast: number of iterations of fast oopsi (0,1,...)
%           - ismc: number of iterations of smc oopsi (it should be 0)
%           - preproc: 0 or 1 (high-pass filter no or yes)
%           (- fr: frame rate in Hz (== 1/fr))
%
%  OUTPUTS:
%       M - [r X fs] matrix storing spike probabilities where r is repetition
%       size and fs is frame size
%       time - time axis of the desired trace(s) (for plotting)
% 
%See also run_oopsi, downsampling_ca, generate_V
%Part of ZENITH utils

% -- Step 0
if nargin < 5
    irep = 0;
    Params.ifast = 100;
    Params.ismc = 0;
    Params.preproc = 0;
end

if nargin < 6
    Params.ifast = 100;
    Params.ismc = 0;
    Params.preproc = 0;
end

% -- Step 1
% export traces of experiment object and store them in a waveform object
W_ref = traces(ex, [iroi, istage, istim, 1], 'dff');
V = generate_V(W_ref,Params);

% -- Step 1/2 (will not stay here)(probably)
[M, T, onoff] = downsampling_ca(4, ex, iroi, istage, istim);
V.T= size(M,2);

% -- Step 2
% M = W.data;
MM = M;
for irep = 1:size(M, 1)
    nbest = run_oopsi(M(irep,:), V);
    MM(irep,:) = nbest.n';
end
