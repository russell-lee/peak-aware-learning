clc ;
clear all;


CITYNAME = 'NEWYORK';
MARKETNAME = 'NYISO';

MONTH = 'DEC';
days = 31;
MONTHS = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", ...
    "AUG", "SEP", "OCT", "NOV", "DEC"];
dayss = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
MONTHS_NO = ["01", "02", "03", "04", "05", "06", "07", ...
    "08", "09", "10", "11", "12"];

demand = csvread(sprintf('%s.csv',CITYNAME));

scale = 1000000;
demand = demand./scale;
scale_solar = 0.3;
scale_wind = 0.3;

min_price = 5; % to avoid negative pricing
wind = csvread('wind.csv');
wind_scaled = renewable_scale(wind,scale_wind, demand);

E_c = 1200; 
rho_c = E_c/10;
rho_d = E_c/10;
% max(demand(:,2))*18;
T = 288;
for i = 10:12
    P = csvread(sprintf('marketprice/%s/2018/%s.csv', MARKETNAME, string(MONTHS(i))));
    P(find(P <= min_price)) = min_price; 
    for j=1:dayss(i)
        P_cur = P(T*(j-1)+1:T*j);

        P_min=min(P_cur);
        P_max=max(P_cur);

        theta = P_max/P_min;
        r = 1./(1 + lambertw((1-theta)/(theta*exp(1))));

        demand_cur = demand(T*(j-1)+1:T*j,2);
        wind_cur = wind_scaled(T*(j-1)+1:T*j);

        demand_net = max((demand_cur - wind_cur),0);
        T,P_cur,demand_net,E_c,rho_c,rho_d
        [x_opt, s_opt, Cost_OPT] = OFOPT_RHO_Grb(T, P_cur, demand_net, E_c, rho_c, rho_d)
        Cost_NOSTR = sum((demand_cur - wind_cur).*P_cur);  

        output = [P_cur demand_net x_opt' s_opt(2:end)'];
        if(j<10)
            outputfilename = sprintf('results/%s/rho/2018/2018-%s-0%i.csv',CITYNAME,string(MONTHS_NO(i)),j);          
        else
               outputfilename = sprintf('results/%s/rho/2018/2018-%s-%i.csv',CITYNAME,string(MONTHS_NO(i)),j);
        end
        csvwrite(outputfilename,output);
    end
end