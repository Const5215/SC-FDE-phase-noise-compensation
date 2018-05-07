function [Ga, Gb] = GolayGenerate(Golay_Num)
Ga = [1 1 -1 1];
Gb = [1 1 1 -1];

while(length(Ga) < Golay_Num)
    Gc = [Ga Gb];
    Gd = [Ga -Gb];
    Ga = Gc;
    Gb = Gd;
end