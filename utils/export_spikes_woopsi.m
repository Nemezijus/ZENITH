function [M] = export_spikes_woopsi(ex, iroi, istage, istim, Params)
% M = export_spikes_woopsi(ex,iroi,istage,istim,V) - extracts spiker from experiment object ex, and
% stores the spike probabilites in a matrix M.
%
% Inputs
%   ex: experiment object 
%   iroi: number of roi (loop through all)
%   istage: number of stage (between 1-6)
%   istim: number of stimulus (between 1-9)
%   Params: parameters necessary to define to fast_oopsi to work properly
%        - ifast: number of iterations of fast oopsi (0,1,...)
%        - ismc: number of iterations of smc oopsi (it should be 0)
%        (- fr: frame rate in Hz (== 1/fr))
%        - preproc: 0 or 1 (high-pass filter no or yes)
%
% Outputs
%   M:  [r X ss] matrix storing spike probabilities where r is repetition
%   size and ss is sample size
%
%Part of ZENITH source
%Uses methods of oopsi 

% Step0
if nargin < 5
    Params.ifast = 100;
    Params.ismc = 0;
    Params.preproc = 0;
end
% Step1
% export traces of experiment object and store them in a waveform object
W = traces(ex, [iroi, istage, istim, 0], 'dff');
V = generate_V(W,Params);
% Step2
M = W.data;
for irep = 1:size(W.data, 1)
    nbest = run_oopsi(W.data(irep,:), V);
    M(irep,:) = nbest.n';
end
