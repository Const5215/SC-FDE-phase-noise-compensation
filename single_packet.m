%% 单次收发
function bit_errs = single_packet()
global sim_options

%发射器，返回发射的信号和产生的原始数据
[txsignal, tx_inf_bits] = transmitter();
%信道
rxsignal = channel(txsignal);
%接收器，过均衡器并解码得到数据
rx_inf_bits = receiver(rxsignal); 

rx_inf_bits = rx_inf_bits > 0;
tx_inf_bits = tx_inf_bits > 0;
sim_options.BitLength = length(rx_inf_bits);

%对比得到单次误码率
bit_errs = biterr(rx_inf_bits,tx_inf_bits);                                


