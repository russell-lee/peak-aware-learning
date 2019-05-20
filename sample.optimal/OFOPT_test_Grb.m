
function [u_opt, v_opt, cost] = OFOPT_test_Grb(T, P_e,P_g,p_m, e,C)
u = sdpvar(1, T,  'full');
v = sdpvar(1, T,  'full');
v_p = sdpvar(1);

%% Constraints
Cons = [u >= 0];
Cons = Cons + [v >=0];

for t=1:T
    Cons = Cons + [u(t) + v(t) >= e(t)];
    Cons = Cons + [u(t) <= C];
    Cons = Cons + [v_p >= v(t)];
end

Obj = sum(P_e'.*v) + P_g * sum(u) + p_m * v_p ;

Ops = sdpsettings;
Ops.solver = 'gurobi';
Ops.verbose = 0;

tic;
Diag = optimize(Cons, Obj, Ops);

u_opt = value(u);
v_opt = value(v);
cost = value(Obj);
end
