function [V] = generate_V(w,Params)

V = struct;
if nargin == 1
    Params.ifast = 100;
    Params.ismc = 0;
    Params.preproc = 0;
end
V.Npixels= 1;
V.T= size(w.data,2);
V.dt= 1/round(w.Fs(1)*1e6);
V.est_a= 0;
V.est_b= 1;
V.est_gam= 0;
V.est_lam= 0;
V.est_sig= 0;
V.fast_ignore_post= 0;
V.fast_iter_max= Params.ifast;
V.fast_iter_tot= Params.ifast;
V.fast_nonlin= 0;
V.fast_plot= 0;
V.fast_poiss= 0;
V.fast_thr= 0;
V.fast_time= [];
V.n_max= 2;
V.name= '/oopsi_';
V.plot= 0;
V.post = [];
V.preprocess= Params.preproc;
V.save= 0;
V.smc_iter_max= Params.ismc;