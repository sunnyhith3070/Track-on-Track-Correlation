function [confirm_laten,termination_laten] = calcu_latency(parameter,truth,meas,est)

%%%%%%calculate target_truth_1 & target_truth_2
[truth_1,truth_2] = find_truth_target_num(parameter,truth);

%%%%%calculate target_estimate_1 & target_truth_2
[estimate_1,estimate_2] = find_estimate_target_num(parameter,truth_1,truth_2,est.est_x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate confirm Latency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k1 = parameter.target1_start_time:parameter.K
    if isempty(estimate_1{k1})
        continue;
    else
        a = k1;
        break;
    end        
end

confirm_latency_1 = a - parameter.target1_start_time;

for k2 = parameter.target2_start_time:parameter.K
    if isempty(estimate_2{k2})
        continue;
    else
        b = k2;
        break;
    end        
end

confirm_latency_2 = b - parameter.target2_start_time;

confirm_laten = [confirm_latency_1;confirm_latency_2];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate termination Latency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k1 = parameter.target1_end_time:parameter.K
    if size(est.est_x{k1},2)==1
        c = k1-1;
        break;
    else
        
    end    
end        
    
termination_latency_1 = c - parameter.target1_end_time;

if termination_latency_1<0
    termination_latency_1 =0;
end

for k2 = parameter.target2_end_time:parameter.K
    if isempty(est.est_x{k2})
        d = k2-1;
        break;
    else
        
    end    
end        
    
termination_latency_2 = d - parameter.target2_end_time;

if termination_latency_2 <0
    termination_latency_2 =0;
end

termination_laten = [termination_latency_1;termination_latency_2];

end