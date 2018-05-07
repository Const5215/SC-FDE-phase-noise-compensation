function rx_signal = channel(tx_signal)
global sim_options
% LOS使用Rayleigh信道
% rx_signal = tx_signal;
rx_signal = filter( sim_options.chn.PathGains, 1, tx_signal );                              % 过信道

rx_signal = awgn( rx_signal, sim_options.SNR + 10*log10(log2(sim_options.M) ), 'measured' );

if sim_options.PhaseNoisedB == -180
    phase_noise = phase_noise_model(sim_options.PhaseNoisedB+100, length(rx_signal));
    rx_signal = rx_signal .* exp(1i*phase_noise);
end

if sim_options.PhaseNoisedB > -100 
    phase_noise = phase_noise_model(sim_options.PhaseNoisedB, length(rx_signal));
    rx_signal = rx_signal .* exp(1i*phase_noise);
end

