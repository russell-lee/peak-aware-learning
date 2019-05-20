
function [cost] = BED(T,P_e,P_e_pred,P_g,p_m,e,e_pred,lambda,C)
layer_thresh = 0;
num_layers = max(e);
%u and v indexed by (layer,time)
u_layer = zeros(num_layers,T);
v_layer = zeros(num_layers,T);
for tau = 1:T
    layer_thresh = max(layer_thresh, max(e(tau) - C,0));
    % update layers below threshold
    v_layer(1:layer_thresh,tau) = ones(layer_thresh,1);
    u_layer(1:layer_thresh,tau) = zeros(layer_thresh,1);
    % update layers above threshold with BED-k
    if layer_thresh < num_layers
        for i = layer_thresh+1:num_layers
            % compute layered demand
            e_layer = e >= i;
            e_layer_pred = e_pred >= i;
            % BED_k just returns u and v at time tau
            [u_tau, v_tau,sigma_error, cost_opt] = BED_k(P_e,P_e_pred,P_g,p_m,e_layer,e_layer_pred,tau,lambda);
    
            u_layer(i,tau) = u_tau;
            v_layer(i,tau) = v_tau;
        end
    end
end
u = sum(u_layer);
v = sum(v_layer);
cost = sum(P_e'.*v) + P_g * sum(u) + p_m * max(v) ;
end




    


