function [B, popact, signif_popact, stim_list] = epilext_read_data(filename, nRoi)
% [] = epilext_read_data reads in digitalized activity data from an excel and 
% returns the custom binarized matrix and row vector containing "stimuli pattern"
% 
%   INPUT
%       filename
%       nRoi - number of ROIs
%   OUTPUT
%       B - (m x n binary matrix) where m indicates rois and n indicates
%           temporal values; matrix contains 1 if cell was active 0 if not
%       popact - (n x 1 col vector) where population activity is stored
%       signif_popact - (n x 1 col vector) where significant population
%                       activity is indicated with 1
%       stim_list - (n x 1 col vector) where interictalspike (iis) presence
%                   is indicated with 1
%
% This function is part of the epilext_* method family which codes are
% extenstions for epilepsy group so they can also benefit from the Yuster
% clasterization methodology.
%
%Part of ZENITH\other


allData = readmatrix(filename);
B = allData(2:end,2:nRoi+1)'; % binary matrix with cell (row) and temporal (column) data
stim_list = allData(2:end,nRoi+2);
stim_list(isnan(stim_list)) = 0; % stimulus list with interictal data
popact = allData(2:end, end-1); % population activites
signif_popact = allData(2:end,end); % significant population activites
