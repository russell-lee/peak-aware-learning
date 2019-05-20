function [sigma] = compute_sigma(p_g,p_e,e,p_m)
% Compute critical peak demand threshold from given inputs
%   Detailed explanation goes here
pred_diff = p_g - p_e;
sigma = sum(pred_diff.*e)/p_m;
end

