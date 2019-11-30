function [z_valid,z_unvalid,valid_idx_x,unvalid_idx_x]= gate_meas_nnekf(z,gate,parameter,P_predict,x_predict)

valid_idx_x = [];
unvalid_idx_x = [];

plength = size(x_predict,2);
% zlength = size(z,2);

z_valid = [];
z_unvalid = [];

for j=1:plength
        P_predict_4_4 = reshape(P_predict(:,j),4,4);
        [H, z_hat]= ekf_update_mat(parameter,x_predict(:,j)); % H is 2 by 4 matrix and z_hat is 2 by 1 matrix
        Sj= H*P_predict_4_4*H' + parameter.R; %Sj is 2 by 2 matrix; 
        
        mu = z-repmat(z_hat,[1 size(z,2)]);
        dist_z = [];
        for m = 1:size(mu,2)
            dist_z(:,m) = mu(:,m)'*inv(Sj)*mu(:,m);
        end
        
        %%%%%NN data association
        [s_dist, idx]=min(dist_z);
        
%         z_keep = [];
        
        if s_dist < gate^2
            z_keep = z(:,idx);
            z_valid = [z_valid z_keep];
%             valid_idx_z = [valid_idx_z idx];
            valid_idx_x = [valid_idx_x j];
            
            all_z_d=1:1:size(z,2);
            unvalid_idx_z_d= setdiff(all_z_d,idx);
            
            z = z(:,unvalid_idx_z_d);
%             
        else
%             valid_idx_z = [valid_idx_z];
            z = z;
            valid_idx_x = [valid_idx_x];
            
        end
        
        if isempty(z)
            return;
        end
end

% all_z=1:1:size(z,2);
% unvalid_idx_z= setdiff(all_z,valid_idx_z);

all_x = 1:1:plength;
unvalid_idx_x = setdiff(all_x,valid_idx_x);

z_unvalid = z;

end