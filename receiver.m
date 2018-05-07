function data_bits = receiver(rx_signal)
global sim_options
%信道估计
rx_CES = rx_signal(1 : sim_options.CES_Num);
[h_est, h_ideal] = channel_estimate(rx_CES);
rx_signal = rx_signal(sim_options.CES_Num+1:end);
%取出CP用作估计
rx_signal = reshape(rx_signal,[],sim_options.packetNum);
CP_received = zeros(sim_options.CP_Num, sim_options.packetNum+1);
CP_received(:,1) = rx_CES(sim_options.FFT_Num*2+sim_options.CP_Num+1:end, 1);
for i = 1:sim_options.packetNum
    CP_received(:,i+1) = rx_signal(sim_options.PacketLength+1:end,i);
end
rx_signal = reshape(rx_signal,[],1);
phi_est = estimate_phi(CP_received, h_est);

% 补偿
if sim_options.PhaseNoisedB == -180
    rx_signal = reshape(rx_signal, [], sim_options.packetNum);
    for i = 1:sim_options.packetNum
        rx_signal(1:sim_options.PacketLength, i) = rx_signal(1:sim_options.PacketLength, i).*conj(exp(1i*phi_est(:,i)));
    end
    rx_signal = reshape(rx_signal,[],1);
    %LMS迭代更新
    rx_signal = [rx_CES;rx_signal];
    W = ones(sim_options.PacketLength,sim_options.packetNum);
    for i = 1 : sim_options.iter
        [rx_signal] = LMS_iter(rx_signal, h_est);
    end
    rx_signal = rx_signal(sim_options.CES_Num+1 : end);
end

%MMSE-FDE
h_tmp = zeros(sim_options.N_carr,1);
h_tmp(sim_options.tap+1) = h_est;
h_est = h_tmp;
rx_signal = [rx_CES;rx_signal];
RX_signal = fft(rx_signal);
H_est = fft(h_est);
RX_signal = equalizer(RX_signal, H_est);
rx_signal = ifft(RX_signal);
rx_signal = rx_signal(sim_options.CES_Num+1:end);
%去CP
rx_signal = reshape(rx_signal, [], sim_options.packetNum);
tmp_signal = zeros(sim_options.PacketLength, sim_options.packetNum);
for i = 1:sim_options.packetNum
    tmp_signal(:,i) = rx_signal(1:sim_options.PacketLength, i);
end
rx_signal = reshape(tmp_signal,[],1);


%数字解调
received_bits = demodulate(modem.qamdemod('M', sim_options.M, 'SymbolOrder', 'Gray', 'OutputType', 'Bit'), rx_signal);
%交织解码
% deinterleav_out = de_interleaving(received_bits, sim_options.interleave_table);
% viterbi_out = vitdec(deinterleav_out, sim_options.trel, sim_options.tblen, 'cont', 'hard');
data_bits = received_bits;