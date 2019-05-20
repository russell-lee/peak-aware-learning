
function [cost] = BED_k_cost(T,P_e,P_g,p_m,e,lambda)

sigma_pred = compute_sigma(P_g,P_e,e,p_m);
if sigma_pred > 1
    s = lambda;
else
    s = 1/lambda;
end

threshold = s * p_m;
%only need to know up to time tau to compute v_tau

diff = P_g - P_e;
sq_price = repmat(diff',T,1);
tril_price = tril(sq_price);

sq_demand = repmat(e',T,1);
tril_demand = tril(sq_demand);


critical_sum = sum(tril_price .* tril_demand,2);
grid_times = critical_sum >= threshold;
local_times = critical_sum < threshold;

grid_usage = sum(P_e.*(grid_times.* e));
local_usage = P_g *sum(local_times.*e);

cost = grid_usage + local_usage + max(grid_times)*p_m;


end


    


