function [ex] = update_for_trigger(ex)
%update_for_trigger - filters out cases when trigger in behavior struct is
%a NaN. Those cases are problematic because they cant have velocity and
%behavior alligned;
B = ex.behavior;
Nstages = numel(B.stage);

for istage = 1:Nstages
    offsets = [B.stage(1).unit.time_offset];
    nanmask = ~isnan(offsets);
%     B.stage(istage).unit = B.stage(istage).unit(nanmask);
    ex.restun{istage} = ex.restun{istage}(nanmask);
end