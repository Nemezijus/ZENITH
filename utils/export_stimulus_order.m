function [stim_order_v] = export_stimulus_order(rest_ref_mx)
% [stim_order_v] = export_stimulus_order(stim_ref_mx) returns the order of
% visual stimuli during our experiments
%
% INPUT:
%       rest_ref_mx - ex.restun{1}
% OUTPUT:
%       stim_order_v - 1xex.N_stim(1)*ex.N_reps(1) long vector containing
%       the real order of stimuli during measurement
% 
%  CHEAT SHEAT:
%       1 - 999, 2 - 0, 3 - 45, 4 - 90, 5 - 135, 6 - 180, 7 - 225, 8 - 270, 9 - 315

st_mx = [999; 0; 45; 90; 135; 180; 225; 270; 315];
st_ref_mx = rest_ref_mx;
for irun = 1:size(rest_ref_mx, 1)
    st_ref_mx(irun,:) = st_mx(irun);
end
rest_ref_mx = reshape(rest_ref_mx, [1, size(rest_ref_mx, 1)*size(rest_ref_mx, 2)]);
stim_order_v = reshape(rest_ref_mx, [1, size(st_ref_mx, 1)*size(st_ref_mx, 2)]);
[~, idx] = sort(rest_ref_mx);
stim_order_v = st_ref_mx(idx);