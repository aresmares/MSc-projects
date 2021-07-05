
function [cumulative, probs] = roulette_wheel(input)

s = sum(input);

cumulative = [0];
probs = zeros(1);
for i=1:size(input,2)
    probs(i) = input(i)/s;
    cumulative(i+1) = cumulative(i) + input(i)/s;
end


cumulative = cumulative(2:end);
end