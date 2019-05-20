
function [x_opt, s_opt, cost] = OFOPT_RHO_Grb(T, P,d, E_c, rho_c, rho_d)

x = sdpvar(1, T,  'full');
s = sdpvar(1, T+1,  'full');

%% Constraints
Cons = [x >= 0];
Cons = Cons + [s(1)==0];
% Cons = Cons + [s(T)==0];

for t=1:T
    Cons = Cons + [x(t) >= d(t) - min(s(t),rho_d)];
    Cons = Cons + [x(t) <= d(t) + min(E_c - s(t),rho_c)];
    Cons = Cons + [s(t+1) == s(t) + x(t) - d(t)];
    Cons = Cons + [s(t+1) <= E_c]; 
    Cons = Cons + [s(t+1) >= 0]; 
end



Obj = sum(P'.*x);

Ops = sdpsettings;
Ops.solver = 'gurobi';
% Ops.showprogress = 1;
Ops.verbose = 0;
% Ops.allowmilp = 1;
% Ops.savesolverinput = 1;
% Ops.savesolveroutput = 1;
% Ops.gurobi.MIPFocus = 1;
% Ops.gurobi.NodefileStart = 0.01;
% %Ops.gurobi.TimeLimit = 300; % runtime <= 20;
% Ops.gurobi.MIPGap = 0.05; % (UB-LB)/UB <= 0.1;
% Ops.gurobi.MIPGapAbs = 1;  % UB-LB <= 10% C_ub;
% Ops.gurobi.Heuristics = 0.2; % 20% of runtime spent in MIP heuristics.
% Ops.gurobi.Presolve = 2; %agrressive
% Ops.gurobi.Method = 3; %3=concurrent root 



% fprintf('Begin to solve optimal problem\n');
tic;
Diag = optimize(Cons, Obj, Ops);

x_opt = value(x);
s_opt = value(s);
cost = value(Obj);