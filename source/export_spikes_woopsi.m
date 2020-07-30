function [MM] = export_spikes_woopsi(M, fs, Params)
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

if nargin < 3
    Params.ifast = 100;
    Params.ismc = 0;
    Params.preproc = 0;
end

V = generate_V(M, fs, Params);
V.T= size(M,2);
MM = M;
for irep = 1:size(M, 1)
    nbest = run_oopsi(M(irep,:), V);
    MM(irep,:) = nbest.n';
end
