function compare_spikedetections(roi_stitched, n_roi)
% compare_spikedetections(roi_stitched) compares the distinct methods
% knowns for spike detection purposes
%
% INPUT(S):
%       roi_stitched - stitched traces of a chosen roi
%
%See also fast_oopsi,export_spikes_woopsi,export_MLspikes,firstderiv_to_binary
%Part of ZENITH utils


%FAST OOPSI
% original
%spikes_oopsi = export_spikes_woopsi(roi_stitched.data, roi_stitched.Fs);
% alternative to adjust detection
[~, P, V, ~] = fast_oopsi(roi_stitched.data);
P.b = 0.25;
[spikes_oopsi_alt] = fast_oopsi(roi_stitched.data, V, P);


%ML SPIKES
load('C:\Users\nagy.dominika\Desktop\github\ZENITH\utils\MLs_PARS.mat')
% 1 - by defaul settings
% par.a = 0.45;
% par.tau = 0.6;
[~, spikes_ML_0] = export_MLspikes(roi_stitched, par);
% % 2
% par.a = 0.5;
% par.tau = 0.6;
% [~, spikes_ML_1] = export_MLspikes(roi_stitched, par);
% % 3
% par.a = 0.6;
% par.tau = 0.6;
% [~, spikes_ML_2] = export_MLspikes(roi_stitched, par);
% % % 4
% par.a = 0.05;
% par.tau = 0.8;
% [~, spikes_ML_3] = export_MLspikes(roi_stitched, par);
% % 5
% par.a = 0.15;
% par.tau = 0.8;
% [~, spikes_ML_4] = export_MLspikes(roi_stitched, par);


%FIST DERIVATIVE
dx = gradient(roi_stitched.data);
dt = gradient(roi_stitched.time);
dxdt = dx./dt;
std_dxdt = std(dxdt);
spikes_firstderiv = double(dxdt >= std_dxdt * 2.5);


%PLOTTING
f = figure; 
ax = createAXES(f, 4, 1);
axes(ax(1));
plot(roi_stitched.time, roi_stitched.data, 'Color', [.47 .67 .19]);
axes(ax(2));
plot(roi_stitched.time, spikes_oopsi_alt, 'Color', [.65 .65 .65]);
axes(ax(3));
plot(roi_stitched.time, spikes_ML_0, 'Color', [.35 .35 .35]);
axes(ax(4));
plot(roi_stitched.time, spikes_firstderiv, 'Color', [.15 .15 .15]);
% axes(ax(5));
% plot(roi_stitched.time, spikes_ML_3, 'Color', [.25 .25 .25]);
% axes(ax(6));
% plot(roi_stitched.time, spikes_ML_4, 'Color', [.15 .15 .15]);
linkaxes(ax, 'x');
ax(1).Title.String = ['[ROI', num2str(n_roi), ', STAGE6] DF/F CALCIUM SIGNAL'];
ax(2).Title.String = 'FAST OOPSI';
ax(3).Title.String = 'MLSPIKE';
ax(4).Title.String = 'FIRST DERIVATIVE';
% ax(5).Title.String = 'MLSPIKE A=0.05 TAU=0.8';
% ax(6).Title.String = 'MLSPIKE A=0.15 TAU=0.8';


% Part 2: saving
% FILEloc = 'C:\Users\nagy.dominika\Desktop\neural ensamble test project';
% currloc = cd;
% cd(FILEloc)
% filename = ['ROI_', num2str(n_roi)];
% disp(['SAVING ', filename]);
% savefig(f, filename);
% cd(currloc)




