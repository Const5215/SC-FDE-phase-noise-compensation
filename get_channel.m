function [tap, gain_dB] = get_channel(L,alpha)

Ex_Power = exp(-alpha*(0:L-1));

tap = 0 : L-1;

Sum_Power = sum(Ex_Power(tap+1));

tap_power = Ex_Power(tap+1)/Sum_Power;

gain_dB = 10*log10(tap_power);