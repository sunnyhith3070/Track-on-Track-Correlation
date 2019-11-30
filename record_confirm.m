function [x_est,q_est] = record_confirm(x_update,q_update)

qlength = size(q_update,2);
valid=[];
for j = 1:qlength
    if q_update(2,j) == 1
        valid = [valid j];
    end
end

x_est = x_update(:,valid);
q_est = q_update(:,valid);

end