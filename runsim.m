global sim_options;

%% ������Ʋ���
sim_options.PacketLength = 240;                                                             %����������
sim_options.iter = 0;
sim_options.mu = 0.1;
sim_options.M = 4;                                                                          %M�����
sim_options.k = log2(sim_options.M);                                                        %����ת��λ��
sim_options.FrameNum = 250;                                                                 %����ʱ�շ�����

%% �ŵ����Ʋ���
sim_options.packetNum = 4;                                                                  % һ֡�����ݰ���
sim_options.FFT_Num = 256;
sim_options.CP_Num = 16;
[sim_options.Ga, sim_options.Gb] = GolayGenerate(sim_options.FFT_Num);
sim_options.CP = sim_options.Ga(1:sim_options.CP_Num)';
sim_options.CES = [sim_options.Ga';sim_options.CP;sim_options.Gb';sim_options.CP];
sim_options.CES_Num = length(sim_options.CES);

sim_options.N_carr = sim_options.CES_Num+sim_options.packetNum*(sim_options.CP_Num+sim_options.PacketLength);
sim_options.alpha = 0.05;                                                                   % ָ��˥������   alpha = 0 ���ȷֲ���
sim_options.fd = 0;                                                                         % ��������Ƶ��
sim_options.L = 4;                                                                          % �ྶ����
sim_options.Ts = 1/(1.79*1e9);                                                              % ���ų�����
sim_options.Tb = sim_options.Ts/sim_options.N_carr;                                         % �������

[sim_options.tap, pdb] = get_channel(sim_options.L, sim_options.alpha);
tau = sim_options.tap*sim_options.Tb;
sim_options.chn = rayleighchan(sim_options.Tb, sim_options.fd, tau, pdb);                   % �����ྶ�����ŵ�
sim_options.chn.StorePathGains = 1;
sim_options.chn.ResetBeforeFiltering = 1;

%% ��֯�������
sim_options.trel = poly2trellis(7, [171 133]);                                              %����trelis
sim_options.tblen = 5*7;
sim_options.interleave_table = interleav_matrix( ones(1, sim_options.PacketLength*sim_options.packetNum*sim_options.k) );     %����α�����֯��

%% ����ִ�в���
digits(12);
for PNdB = -80 : -50 : -180
    sim_options.PhaseNoisedB = PNdB;
    err = zeros(1,9);
    for SNR_dB = 0 : 1 : 8
        sim_options.SNR = SNR_dB;
        %��֡�շ��õ�ͳ��ƽ��������
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
%     legend('�����������','�����������');
end
xlabel('SNR');
ylabel('BER');
title('QPSK,�����ŵ�,-80dBc/Hz@1MHz��λ����');
legend('�޲���','����λ����','LMS����');
grid on;
hold on;