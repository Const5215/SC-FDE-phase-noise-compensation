function rx_comp = LMS_iter(rx_orig, path_gain)
global sim_options

%MMSE-FDE
h_tmp = zeros(sim_options.L,1);
h_tmp(sim_options.tap+1) = path_gain;
h_est = h_tmp;
rx_signal = rx_orig;
RX_signal = fft(rx_signal);
H_est = fft(h_est, length(RX_signal));
RX_signal = equalizer(RX_signal, H_est);
rx_signal = ifft(RX_signal);

%去CP
rx_signal = rx_signal(sim_options.CES_Num+1 : end);
rx_signal = reshape(rx_signal, [], sim_options.packetNum);
tmp_signal = zeros(sim_options.PacketLength, sim_options.packetNum);
for i = 1:sim_options.packetNum
    tmp_signal(:,i) = rx_signal(1:sim_options.PacketLength, i);
end
rx_signal = reshape(tmp_signal,[],1);
%解码
received_bits = demodulate(modem.qamdemod('M', sim_options.M, 'SymbolOrder', 'Gray', 'OutputType', 'Bit'), rx_signal);
%再编码
tx_mod = modulate(modem.qammod('M', sim_options.M, 'SymbolOrder', 'Gray', 'InputType', 'Bit'), received_bits);
%加CP，过信道
tx_mod = reshape(tx_mod,[],sim_options.packetNum);
tmp_mod = zeros(sim_options.CP_Num+sim_options.PacketLength, sim_options.packetNum);
for i = 1:sim_options.packetNum
    tmp_mod(:,i) = [tx_mod(:,i);sim_options.CP];
end
tx_mod = reshape(tmp_mod,[],1);
tx_signal = [sim_options.CES;tx_mod];
rx_signal = filter( path_gain, 1, tx_signal );

%计算偏差并更新
base = sim_options.CES_Num - sim_options.CP_Num;
plen = sim_options.CP_Num*2+sim_options.PacketLength;
N = sim_options.CP_Num+sim_options.PacketLength;

rx_comp = rx_orig;
for i = 0:sim_options.packetNum-1
    r_0 = rx_orig( ( 1:plen ) + (base+i*N));
    r_e = rx_signal( ( 1:plen ) + (base+i*N));
    w = ones(1, plen);
    for k = 1 : plen-1
        e(k) = r_0(k) - conj(w(k))*r_e(k);
        w(k+1) = w(k) + sim_options.mu*r_e(k)*conj(e(k));
    end
    phi_e = zeros(1, plen+1);
    phi_e(plen+1) = w(plen);
    for k = plen:-1:1
        phi_e(k) = sim_options.mu*conj(w(k)) + (1 - sim_options.mu)*phi_e(k+1);
    end
    for k = 1:plen
        rx_comp(k + (base+i*N)) = rx_comp(k + (base+i*N)) * conj(phi_e(k));
    end
end