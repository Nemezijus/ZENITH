function M = treat_artifacts(M, nstart, period)
% M = treat_artifacts(M, nstart, period) - eliminates artifacts of woopsi spike
% detection which produces artificial spike increase at the beginning of
% the trace
%
%   INPUTS:
%       M - spike probability matrix that needs to be treated
%       nstart - how many samples from the start have to be treated
%       period -one recording length in samples
%
%   OUTPUTS:
%       M - treated spike probability matrix
%Part of ZENITH source


sz = size(M);
N =[];

for isam = 1:nstart
    N = [N,[0:sz(2)./period - 1].*period + isam];
    N = [N,[1:sz(2)./period].*period - (isam-1)];
end
N = sort(N);
M(:,N) = 0;
