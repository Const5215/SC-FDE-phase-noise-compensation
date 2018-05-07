function [pilot_index, data_index] = insert_pilot(N_carr,P)

step = floor(N_carr/P);
initial_index = floor((N_carr-(P-1)*step)/2);

pilot_index = initial_index:step:(N_carr-initial_index);

data_index = (1:N_carr);
data_index(pilot_index) = [];