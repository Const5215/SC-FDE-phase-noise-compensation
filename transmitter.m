function [tx_signal, orig_bits] = transmitter()
global sim_options

% orig_bits = randint(sim_options.PacketLength*sim_options.packetNum*sim_options.k/2, 1);%生成原始数据
orig_bits = ones(sim_options.PacketLength*sim_options.packetNum*sim_options.k, 1);       %测试用

%交织编码
% conv_out = convenc(orig_bits, sim_options.trel);
% 
% interleav_out = interleaving(conv_out, sim_options.interleave_table);
        
%数字调制
tx_mod = modulate(modem.qammod('M', sim_options.M, 'SymbolOrder', 'Gray', 'InputType', 'Bit'), orig_bits);

%加入CP
tx_mod = reshape(tx_mod,[],sim_options.packetNum);
tmp_mod = zeros(sim_options.CP_Num+sim_options.PacketLength, sim_options.packetNum);
for i = 1:sim_options.packetNum
    tmp_mod(:,i) = [tx_mod(:,i);sim_options.CP];
end
tx_mod = reshape(tmp_mod,[],1);

% tx_signal = [tx_mod(192-64+1:192);tx_mod];

tx_signal = [sim_options.CES;tx_mod];