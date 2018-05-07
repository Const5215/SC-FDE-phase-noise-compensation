function COMP_signal = equalizer(RX_data, freq_channel)
global sim_options
%MMSE算法的均衡系数
snr = 10^(( sim_options.SNR + 10*log10(log2(sim_options.M)) )/10);
sgma = 1/sqrt(snr);
% sgma = 0;
EqCoe=conj(freq_channel)./(sgma^2+abs(freq_channel).^2);
COMP_signal = RX_data.*EqCoe;

