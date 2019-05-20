function output = renewable_scale(input, penetration, demand)
    
mean_demand = mean(demand);
mean_demand = mean_demand(1,2);

output = input.*penetration.*mean_demand./max(input);