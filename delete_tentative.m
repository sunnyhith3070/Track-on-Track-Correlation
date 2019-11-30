function [P_update, x_update, q_update] = delete_tentative(parameter,P_confirm_delete,x_confirm_delete,q_confirm_delete)

qlength = size(q_confirm_delete,2);

valid = [];

for j = 1:qlength

    if q_confirm_delete(1,j)>=0.001
        valid = [valid j];
    end
    
    if q_confirm_delete(2,j) == 1   %%%life
        q_confirm_delete(3,j) = q_confirm_delete(3,j)+1;
    end
end

P_update = P_confirm_delete(:,valid);
x_update = x_confirm_delete(:,valid);
q_update = q_confirm_delete(:,valid);


end