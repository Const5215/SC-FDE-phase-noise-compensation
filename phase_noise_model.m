function PhaseNoise = phase_noise_model(PNdB, L);
% function phase_noise = gen_phase_noise(dbc_level, corner_freq, phase_noise_floor, n_samples);

global sim_options;
sim_consts.SampFreq = 1/sim_options.Ts;
dbc_level = PNdB;
n_samples = L;
corner_freq = 1e6;
phase_noise_floor = PNdB-40;
% Variance of top flat noisd
colored_noise_var = sim_consts.SampFreq*10^(dbc_level/10);

% Variance of n12q  aoise floor
noise_floor_var = sim_consts.SampFreq*10^(phase_noise_floor/10);

% Phase noise power spectrum is created with two filters,
% high pass filter, followed by an ideal integrator

[b_hpf, a_hpf] = butter(1, corner_freq/(sim_consts.SampFreq/2), 'high');

% ...and then an ideal integrator.
tmp = freqz(1,[1 -1],[corner_freq corner_freq+1], sim_consts.SampFreq);
[b_intg] = 1/abs(tmp(1)); % make f = corner frequency gain be 0dB
[a_intg] = [1 -1];

% Colored noise
colored_noise = sqrt(colored_noise_var)*randn(1, n_samples);

% Noise floor
noise_floor = sqrt(noise_floor_var)*randn(1, n_samples);

integrator_input = filter(b_hpf, a_hpf, colored_noise);
PhaseNoise       = filter(b_intg, a_intg, integrator_input) + noise_floor;
PhaseNoise = PhaseNoise';