global sim_options;

%% 仿真控制参数
sim_options.PacketLength = 240;                                                             %比特流长度
sim_options.iter = 0;
sim_options.mu = 0.1;
sim_options.M = 4;                                                                          %M点个数
sim_options.k = log2(sim_options.M);                                                        %编码转换位数
sim_options.FrameNum = 250;                                                                 %仿真时收发次数

%% 信道估计参数
sim_options.packetNum = 4;                                                                  % 一帧中数据包数
sim_options.FFT_Num = 256;
sim_options.CP_Num = 16;
[sim_options.Ga, sim_options.Gb] = GolayGenerate(sim_options.FFT_Num);
sim_options.CP = sim_options.Ga(1:sim_options.CP_Num)';
sim_options.CES = [sim_options.Ga';sim_options.CP;sim_options.Gb';sim_options.CP];
sim_options.CES_Num = length(sim_options.CES);

sim_options.N_carr = sim_options.CES_Num+sim_options.packetNum*(sim_options.CP_Num+sim_options.PacketLength);
sim_options.alpha = 0.05;                                                                   % 指数衰落因子   alpha = 0 均匀分布；
sim_options.fd = 0;                                                                         % 最大多普勒频率
sim_options.L = 4;                                                                          % 多径个数
sim_options.Ts = 1/(1.79*1e9);                                                              % 符号持续期
sim_options.Tb = sim_options.Ts/sim_options.N_carr;                                         % 采样间隔

[sim_options.tap, pdb] = get_channel(sim_options.L, sim_options.alpha);
tau = sim_options.tap*sim_options.Tb;
sim_options.chn = rayleighchan(sim_options.Tb, sim_options.fd, tau, pdb);                   % 产生多径瑞利信道
sim_options.chn.StorePathGains = 1;
sim_options.chn.ResetBeforeFiltering = 1;

%% 交织编码参数
sim_options.trel = poly2trellis(7, [171 133]);                                              %产生trelis
sim_options.tblen = 5*7;
sim_options.interleave_table = interleav_matrix( ones(1, sim_options.PacketLength*sim_options.packetNum*sim_options.k) );     %生成伪随机交织器

%% 仿真执行部分
digits(12);
for PNdB = -80 : -50 : -180
    sim_options.PhaseNoisedB = PNdB;
    err = zeros(1,9);
    for SNR_dB = 0 : 1 : 8
        sim_options.SNR = SNR_dB;
        %多帧收发得到统计平均误码率
        for i = 1 : sim_options.FrameNum
            tic;
            thserr = single_packet();
            err(SNR_dB + 1) = err(SNR_dB + 1) + thserr;
            toc;
        end
        err(SNR_dB + 1) = err(SNR_dB + 1) / (sim_options.FrameNum*sim_options.BitLength);
    end
    SNR_dB = (0:1:8);
    SNR = 10.^(SNR_dB/10);
%     Pe = (4/sim_options.k) * (1 - 1/sqrt(sim_options.M)) * ...
%         qfunc( sqrt(3*sim_options.k*SNR/(sim_options.M-1)) );
    semilogy(SNR_dB, err,'*-');
    hold on;
    %semilogy(SNR_dB, err_comp,'o-');
%     semilogy(SNR_dB, Pe);
%     legend('仿真误比特率','理论误比特率');
end
xlabel('SNR');
ylabel('BER');
title('QPSK,瑞利信道,-80dBc/Hz@1MHz相位噪声');
legend('无补偿','无相位噪声','LMS补偿');
grid on;
hold on;