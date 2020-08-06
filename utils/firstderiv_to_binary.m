function [B, M] = firstderiv_to_binary(ex, istage)
% [B] = firstderiv_to_binary(ex,istage) creates the binary matrix based
% upon the preset threshold of 2.5 times the sd of noise from the first
% derivative of dff calcium signals of each rois
%
% INPUTS:
%       ex - experiment object
%       istage - stage of measurement
% OUTPUTS:
%       B - binary matrix
%
%Part of ZENITH utils

M=[];
DXDT = [];
for iroi = 1:ex.N_roi
    m = ex.stitch(iroi, istage, 'dff');
    dx = gradient(m.data);
    dt = gradient(m.time);
    dxdt = dx./dt;
    M = [M;m];
    DXDT = [DXDT; dxdt];
end

B = double(DXDT >= std2(DXDT)*3);


