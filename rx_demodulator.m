
function bits_out = rx_demodulator(rx_symbols, sim_options)

if ~isempty(findstr(sim_options.Modulation, 'BPSK'))
	bits_out = real(rx_symbols);
    
elseif ~isempty(findstr(sim_options.Modulation, 'QPSK'))
    bits_out = zeros(2*size(rx_symbols,1),size(rx_symbols,2));
    bit0 = real(rx_symbols) > 0 ; 
    bit1 = imag(rx_symbols) > 0 ;
    bits_out(1:2:size(bits_out, 1),:) = bit0;
    bits_out(2:2:size(bits_out, 1),:) = bit1;

elseif ~isempty(findstr(sim_options.Modulation, '16QAM'))	
    bits_out = zeros(4*size(rx_symbols,1), size(rx_symbols,2));
    bit0 = real(rx_symbols);
    bit2 = imag(rx_symbols);
    bit1 = 2/sqrt(10)-(abs(real(rx_symbols)));
    bit3 = 2/sqrt(10)-(abs(imag(rx_symbols)));
    bits_out(1:4:size(bits_out,1),:) = bit0;
    bits_out(2:4:size(bits_out,1),:) = bit1;
    bits_out(3:4:size(bits_out,1),:) = bit2;
    bits_out(4:4:size(bits_out,1),:) = bit3;
elseif ~isempty(findstr(sim_options.Modulation, '64QAM'))
    bits_out = zeros(6*size(rx_symbols,1), size(rx_symbols,2));
    bit0 = real(rx_symbols);
    bit3 = imag(rx_symbols);
    bit1 = 4/sqrt(42)-abs(real(rx_symbols));
    bit4 = 4/sqrt(42)-abs(imag(rx_symbols));

    for m=1:size(rx_symbols,2)
       for k=1:size(rx_symbols,1)
          if abs(4/sqrt(42)-abs(real(rx_symbols(k,m)))) <= 2/sqrt(42)  % bit is one
             bit2(k,m) = 2/sqrt(42) - abs(4/sqrt(42)-abs(real(rx_symbols(k,m))));
          elseif abs(real(rx_symbols(k,m))) <= 2/sqrt(42) % bit is zero, close to real axis
             bit2(k,m) = -2/sqrt(42) + abs(real(rx_symbols(k,m)));
          else
             bit2(k,m) = 6/sqrt(42)-abs(real(rx_symbols(k,m))); % bit is zero 
          end;

          if abs(4/sqrt(42)-abs(imag(rx_symbols(k,m)))) <= 2/sqrt(42)  % bit is one
             bit5(k,m) = 2/sqrt(42) - abs(4/sqrt(42)-abs(imag(rx_symbols(k,m))));
          elseif abs(imag(rx_symbols(k,m))) <= 2/sqrt(42) % bit is zero, close to real axis
             bit5(k,m) = -2/sqrt(42) + abs(imag(rx_symbols(k,m)));
          else
             bit5(k,m) = 6/sqrt(42)-abs(imag(rx_symbols(k,m)));
          end;
       end;
    end;

    bits_out(1:6:size(bits_out,1),:) = bit0;
    bits_out(2:6:size(bits_out,1),:) = bit1;
    bits_out(3:6:size(bits_out,1),:) = bit2;
    bits_out(4:6:size(bits_out,1),:) = bit3;
    bits_out(5:6:size(bits_out,1),:) = bit4;
    bits_out(6:6:size(bits_out,1),:) = bit5;
else
   error('Undefined modulation');
end

bits_out = reshape(bits_out, 1 , []);