function [h_est,h_ideal] = channel_estimate(rx_CES)
global sim_options

r0 = rx_CES(1:sim_options.FFT_Num,1);
r1 = rx_CES(sim_options.FFT_Num+sim_options.CP_Num+1:sim_options.FFT_Num*2+sim_options.CP_Num, 1);
g = (xcorr(r0',sim_options.Ga)+xcorr(r1',sim_options.Gb))/(2*sim_options.FFT_Num);
h_est = conj(g(sim_options.FFT_Num:sim_options.FFT_Num+sim_options.L-1));
h_ideal = sim_options.chn.PathGains;