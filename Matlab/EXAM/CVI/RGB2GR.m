

Ir = [208 233 71
231 161 140
32 24 245];

Ig = [247 245 36
40 124 107
248 204 234];

Ib = [202 9 173
245 217 193
167 239 190];

Igray = convert_to_gray(Ir,Ig,Ib,8);

function Igray = convert_to_gray(Ir, Ig, Ib, n)
    Igray = size(Ir);
    for i=1:size(Ir,1)
        for j=1:size(Ir,2)
            Igray(i,j) = (Ir(i,j) + Ig(i,j) + Ib(i,j)) / 3;
        end
    end
    Igray = Igray ./ (256 /(2^n));
%     Igray = floor(Igray);
end