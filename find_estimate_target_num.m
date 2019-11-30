function [estimate_1,estimate_2] = find_estimate_target_num(parameter,truth_1,truth_2,est)

estimate_1 = cell(parameter.K,1);
estimate_2 = cell(parameter.K,1);

gate =200;

for k1 = 1:parameter.K
    
    esti = est{k1};
    trut_1 = truth_1{k1};
    if isempty(trut_1)|| isempty(esti)
        continue;
    else 
        s1 = size(esti,2); 
        for j = 1:s1
            if ((esti(1,j)-trut_1(1,1))^2 +(esti(3,j)-trut_1(3,1))^2)< (gate^2) 
                estimate_1{k1} = esti(:,j);
            else
                estimate_1{k1} = estimate_1{k1};
            end
        end 
    end    
end

for k2 = 1:parameter.K
    
    esti = est{k2};
    trut_2 = truth_2{k2};
    if isempty(trut_2)|| isempty(esti)
        continue;
    else 
        s1 = size(esti,2); 
        for j = 1:s1
            if ((esti(1,j)-trut_2(1,1))^2 +(esti(3,j)-trut_2(3,1))^2)< (gate^2) 
                estimate_2{k2} = esti(:,j);
                continue;
            else
                estimate_2{k2} = estimate_2{k2};
            end
        end 
    end    
end


end