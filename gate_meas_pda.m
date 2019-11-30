function [P_update,x_update,q_update,z_unvalid]= gate_meas_pda(z,gate,parameter,P_predict,x_predict,q_predict)

valid_idx_x = [];
unvalid_idx_x = [];

plength = size(x_predict,2);
% zlength = size(z,2);

z_valid = [];
z_unvalid = [];

P_update=[];
x_update=[];
q_update=[];

for j=1:plength
        P_predict_4_4 = reshape(P_predict(:,j),4,4);
        [H, z_hat]= ekf_update_mat(parameter,x_predict(:,j)); % H is 2 by 4 matrix and z_hat is 2 by 1 matrix
        Sj= H*P_predict_4_4*H' + parameter.R; %Sj is 2 by 2 matrix; 
        Wj = P_predict_4_4*H'*inv(Sj); % kalman gain wj is 4 by 2
        
        mu = z-repmat(z_hat,[1 size(z,2)]);
        dist_z = [];
        valid_zj = [];
        for m = 1:size(mu,2)
            dist_z(:,m) = mu(:,m)'*inv(Sj)*mu(:,m);  % dist_z is a vector which stores distance 
            if dist_z(:,m)<= gate^2
                valid_zj = [valid_zj m];
            end
        end
        
        
        
        %%%%% pda and update
        z_valid = z(:,valid_zj); 
        
        all_z = 1:1:size(z,2);
        unvalid_zj = setdiff(all_z,valid_zj);
        z_unused = z(:,unvalid_zj);
        
        if isempty(valid_zj)
            
            [P_update_j,x_update_j,q_update_j] = pda_calcu_no_meas(parameter,Sj,Wj,H,P_predict_4_4,x_predict(:,j),q_predict(:,j));
            
        else
            [P_update_j,x_update_j,q_update_j] = pda_calcu(parameter,z_valid,z_hat,Sj,Wj,P_predict_4_4,x_predict(:,j),q_predict(:,j));
            
        end
        
        P_update(:,j) = P_update_j;
        x_update(:,j) = x_update_j;
        q_update(:,j) = q_update_j;
        
        z = z_unused;
end



z_unvalid = z;

% all_x = 1:1:plength;
% unvalid_idx_x = setdiff(all_x,valid_idx_x);

% z_unvalid = z;



end