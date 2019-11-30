function [truth_1,truth_2] = find_truth_target_num(parameter,truth)

target1_start_time = parameter.target1_start_time; %target1 starts time
target1_end_time = parameter.target1_end_time;  %target1 ends time

target2_start_time = parameter.target2_start_time; %target2 starts time
target2_end_time = parameter.target2_end_time;  %target2 ends time

truth_1 = cell(truth.K,1);
truth_2 = cell(truth.K,1);

for k1 = 1:truth.K
    if k1<target1_start_time
        truth_1{k1}=[];
    elseif (target1_start_time<=k1 && k1<=target1_end_time)
        truth_1{k1}=truth.X{k1}(:,1);
    else    
        truth_1{k1}=[];
    end
        
end

for k2 = 1:truth.K
    if k2<target2_start_time
        truth_2{k2}=[];
    elseif (target2_start_time<=k2 && k2<=target1_end_time)
        truth_2{k2}=truth.X{k2}(:,2);
    elseif (target1_end_time< k2 && k2<=target2_end_time)
        truth_2{k2}=truth.X{k2}(:,1);
    else
        truth_2{k2}=[];
    end
        
end

end