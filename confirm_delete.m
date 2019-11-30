function [P_confirm_delete,x_confirm_delete,q_confirm_delete ]= confirm_delete(parameter,P_update,x_update,q_update_confirm)

qlength = size(q_update_confirm,2);
unvalid = [];

for j = 1:qlength
    if (q_update_confirm(1,j)<=parameter.delete_confirm && q_update_confirm(2,j)==1)
        unvalid = [unvalid j];
    end
end

all_idx = 1:1:qlength;
valid = setdiff(all_idx,unvalid);

P_confirm_delete = P_update(:,valid);
x_confirm_delete = x_update(:,valid);
q_confirm_delete = q_update_confirm(:,valid);


end