% eg inputs = [sym("d1") sym("q2") ...]

function [V] = tool_jacobian(ArmMatrix, inputs)
assume(inputs,'real');


W(1:3) = ArmMatrix(1:3,4);
W(4:6) = -exp(inputs(end)/pi) * ArmMatrix(1:3,3);

V=sym(zeros(6,size(inputs,2)));
for i=1:size(inputs,2)
    V(:,i) = diff(W',inputs(i));
end
V = simplify(V)
end

