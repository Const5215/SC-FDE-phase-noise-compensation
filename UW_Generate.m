function UW=UW_Generate(U)
F = zeros(U,1);
UW = zeros(U,1);

for q = 0:(sqrt(U)-1)
    for p = 0:(sqrt(U)-1)
        F(p+q*sqrt(U)+1,1) = 2*pi*p*q/sqrt(U);
    end
end

I = cos(F);
Q = sin(F);
UW = Q + j*I;