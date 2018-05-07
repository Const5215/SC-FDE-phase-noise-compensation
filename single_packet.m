%% �����շ�
function bit_errs = single_packet()
global sim_options

%�����������ط�����źźͲ�����ԭʼ����
[txsignal, tx_inf_bits] = transmitter();
%�ŵ�
rxsignal = channel(txsignal);
%����������������������õ�����
rx_inf_bits = receiver(rxsignal); 

rx_inf_bits = rx_inf_bits > 0;
tx_inf_bits = tx_inf_bits > 0;
sim_options.BitLength = length(rx_inf_bits);

%�Աȵõ�����������
bit_errs = biterr(rx_inf_bits,tx_inf_bits);                                


