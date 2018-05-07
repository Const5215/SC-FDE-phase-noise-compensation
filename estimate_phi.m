function phi_est = estimate_phi(CP_received, h_est)
global sim_options
snr = 10^(( sim_options.SNR + 10*log10(log2(sim_options.M)) )/10);
sgma = 1/sqrt(snr);
% sgma = 0;
g = filter(h_est, 1, sim_options.CP);
replica = g(sim_options.L:sim_options.CP_Num);
phi_tmp = zeros(1, sim_options.packetNum+1);
for i = 1:sim_options.packetNum+1
    phi_tmp(i) = sum( angle( (CP_received(sim_options.L:sim_options.CP_Num,i).*conj(replica))./(abs(replica).^2+sgma^2) ) ) /(sim_options.CP_Num-sim_options.L+1);
end
phi_est = zeros(sim_options.PacketLength,sim_options.packetNum);
for i = 1:sim_options.packetNum
    for j = 1:sim_options.PacketLength
        phi_est(j,i) = ( phi_tmp(i)*(sim_options.PacketLength-j) + phi_tmp(i+1)*j ) / sim_options.PacketLength;
    end
end