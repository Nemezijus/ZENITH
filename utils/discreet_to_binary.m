function B = discreet_to_binary(M)
% B = discreet_to_binary(M) - converts discreet spike matrix to
% binary spike matrix. Typically used on MLSpike output
%
%   INPUTS:
%       M - discreet spike matrix
%
%   OUTPUTS:
%       B - binary matrix containing putative spiking events. Same size as M
%
%part of ZENITH

B = M;
B(B>0) = 1;