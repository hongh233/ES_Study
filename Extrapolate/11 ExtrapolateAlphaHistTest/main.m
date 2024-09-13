
distance = [];
distanceAlpha = [];

for i = 1:100
    rng(i);
    [distance, distanceAlpha] = Extrapolate(distance, distanceAlpha);
end

x = 1:length(distance);

figure;
histogram(distance);
hold on;
histogram(distanceAlpha);