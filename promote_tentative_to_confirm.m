function q_update_confirm = promote_tentative_to_confirm(parameter,q_update)

qlength = size(q_update,2);

for j = 1:qlength
    if q_update(1,j)>=parameter.confirm
       q_update(2,j) = 1;
    end    
    
end

q_update_confirm = q_update;

end