function [rmse_1_position,rmse_1_velocity,N_k_1,rmse_2_position,rmse_2_velocity,N_k_2]= calcu_rmse(parameter,truth,meas,est)

%%%%%%calculate target_truth_1 & target_truth_2
[truth_1,truth_2] = find_truth_target_num(parameter,truth);

%%%%%calculate target_estimate_1 & target_truth_2
[estimate_1,estimate_2] = find_estimate_target_num(parameter,truth_1,truth_2,est.est_x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate RMSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_k_1 = zeros(parameter.K,1);   %50 by 1 matrix
N_k_2 = zeros(parameter.K,1);
rmse_1_position = zeros(parameter.K,1);
rmse_2_position = zeros(parameter.K,1);
rmse_1_velocity = zeros(parameter.K,1);
rmse_2_velocity = zeros(parameter.K,1);


truth_1_position = cell(parameter.K,1);
truth_2_position = cell(parameter.K,1);
truth_1_velocity = cell(parameter.K,1);
truth_2_velocity = cell(parameter.K,1);

estimate_1_position = cell(parameter.K,1);
estimate_2_position = cell(parameter.K,1);
estimate_1_velocity = cell(parameter.K,1);
estimate_2_velocity = cell(parameter.K,1);

%%%%%%%calculate truth position and velocity
for k1 = 1:parameter.K
    if isempty(truth_1{k1})
        truth_1_position{k1} = [];
        truth_1_velocity{k1} = [];
    else
        truth_1_position{k1} = [truth_1{k1}(1,:); truth_1{k1}(3,:)];
        truth_1_velocity{k1} = [truth_1{k1}(2,:); truth_1{k1}(4,:)];        
    end            
end

for k2 = 1:parameter.K
    if isempty(truth_2{k2})
        truth_2_position{k2} = [];
        truth_2_velocity{k2} = [];
    else
        truth_2_position{k2} = [truth_2{k2}(1,:); truth_2{k2}(3,:)];
        truth_2_velocity{k2} = [truth_2{k2}(2,:); truth_2{k2}(4,:)];        
    end            
end

%%%%%%%calculate estimate position and velocity
for k1 = 1:parameter.K
    if isempty(estimate_1{k1})
        estimate_1_position{k1} = [];
        estimate_1_velocity{k1} = [];
    else
        estimate_1_position{k1} = [estimate_1{k1}(1,:); estimate_1{k1}(3,:)];
        estimate_1_velocity{k1} = [estimate_1{k1}(2,:); estimate_1{k1}(4,:)];        
    end            
end

for k2 = 1:parameter.K
    if isempty(estimate_2{k2})
        estimate_2_position{k2} = [];
        estimate_2_velocity{k2} = [];
    else
        estimate_2_position{k2} = [estimate_2{k2}(1,:); estimate_2{k2}(3,:)];
        estimate_2_velocity{k2} = [estimate_2{k2}(2,:); estimate_2{k2}(4,:)];        
    end            
end

%%%%% RMSE position
for k1 = 1:parameter.K    
    if isempty(truth_1_position{k1}) || isempty(estimate_1_position{k1})        
        continue;
    else
        rmse_1_position(k1,:)=(truth_1_position{k1}(1,:)-estimate_1_position{k1}(1,:)).^2 + (truth_1_position{k1}(2,:)-estimate_1_position{k1}(2,:)).^2;
        N_k_1(k1,:) = 1;
    end
end

for k2 = 1:parameter.K    
    if isempty(truth_2_position{k2}) || isempty(estimate_2_position{k2})        
        continue;
    else
        rmse_2_position(k2,:)=(truth_2_position{k2}(1,:)-estimate_2_position{k2}(1,:)).^2 + (truth_2_position{k2}(2,:)-estimate_2_position{k2}(2,:)).^2;
        N_k_2(k2,:) = 1;
    end
end

%%%%% RMSE volicity
for k1 = 1:parameter.K    
    if isempty(truth_1_velocity{k1}) || isempty(estimate_1_velocity{k1})        
        continue;
    else
        rmse_1_velocity(k1,:)=(truth_1_velocity{k1}(1,:)-estimate_1_velocity{k1}(1,:)).^2 + (truth_1_velocity{k1}(2,:)-estimate_1_velocity{k1}(2,:)).^2;
    end
end

for k2 = 1:parameter.K    
    if isempty(truth_2_velocity{k2}) || isempty(estimate_2_velocity{k2})        
        continue;
    else
        rmse_2_velocity(k2,:)=(truth_2_velocity{k2}(1,:)-estimate_2_velocity{k2}(1,:)).^2 + (truth_2_velocity{k2}(2,:)-estimate_2_velocity{k2}(2,:)).^2;
    end
end


end