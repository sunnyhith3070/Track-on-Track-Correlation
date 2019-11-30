function false_track_num = calcu_false_track(parameter,truth,meas,est)

%%%%%%calculate target_truth_1 & target_truth_2
[truth_1,truth_2] = find_truth_target_num(parameter,truth);

%%%%%calculate target_estimate_1 & target_truth_2
[estimate_1,estimate_2] = find_estimate_target_num(parameter,truth_1,truth_2,est.est_x);

for k1=1:parameter.K
    if isempty(estimate_1{k1})
        estimate_1{k1} =[0;0;0;0];
    end
end

for k2=1:parameter.K
    if isempty(estimate_2{k2})
        estimate_2{k2} =[0;0;0;0];
    end
end

%%%%%%calculate false track number
false_track_num = 0;

for k = 1:parameter.K
    x1 = [];
    if isempty(est.est_q{k})
        continue;
    else
        s1 = size(est.est_q{k},2);
        
        for j = 1:s1
            if est.est_q{k}(3,j)==1
                x1 =[x1 est.est_x{k}(:,j)];
            else   
            end
        end
                
        if isempty(x1)
            continue;
        else   
            s2 = size(x1,2);
            
            for g = 1:s2
                if x1(:,g) == estimate_1{k}
                    continue;
                elseif x1(:,g) == estimate_2{k}
                    continue;
                else
                    false_track_num = false_track_num +1;
                end

            end
        end
    end
end


end