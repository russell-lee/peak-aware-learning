clc ;
clear all;


CITYNAME = 'NEWYORK';
MARKETNAME = 'NYISO';

MONTH = 'DEC';
days = 31;
MONTHS = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", ...
    "AUG", "SEP", "OCT", "NOV", "DEC"];
days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
MONTHS_NO = ["01", "02", "03", "04", "05", "06", "07", ...
    "08", "09", "10", "11", "12"];

demand = csvread(sprintf('%s.csv',CITYNAME));

scale = 100000;
% problem assumes integer demand
demand = round(demand./scale);

min_price = 5; % to avoid negative pricing

T = 288;
scale_peak_price = 75;
scale_capacity = 0.6;
% run on specific season





for i = 4:12
    P = csvread(sprintf('marketprice/%s/2018/%s.csv', MARKETNAME, string(MONTHS(i))));
    P(find(P <= min_price)) = min_price; % make all prices at least min_price
    costs = zeros(days(i),1);
    for j=1:days(i)
        P_cur = P(T*(j-1)+1:T*j);
        P_max=max(P_cur);
        P_m = scale_peak_price * P_max;
        demand_cur = demand(T*(j-1)+1:T*j,2);
        C = round(scale_capacity * max(demand_cur));
        
        

        [u_opt, v_opt, Cost_OPT] = OFOPT_test_Grb(T, P_cur, P_max,P_m, demand_cur, C);
        costs(j) = Cost_OPT;
        if(j<10)
            outputfilename = sprintf('results/%s/peak/2018/2018-%s-0%i.csv',CITYNAME,string(MONTHS_NO(i)),j);          
        else
            outputfilename = sprintf('results/%s/peak/2018/2018-%s-%i.csv',CITYNAME,string(MONTHS_NO(i)),j);
        end
        output = [P_cur demand_cur u_opt' v_opt'];
        csvwrite(outputfilename,output);
        
    end
    outputfilename = sprintf('results/%s/peak/2018-%s-costs.csv',CITYNAME,string(MONTHS_NO(i)));
    csvwrite(outputfilename,costs);
end

