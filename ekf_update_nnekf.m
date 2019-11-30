function [P_upd, x_upd, q_upd, z_unvalid] = ekf_update_nnekf(z,parameter, P_predict,x_predict,q_predict,z_valid,z_unvalid,valid_x,unvalid_x )

p_d = parameter.P_D;
p_fa = parameter.P_F;

s_x = size(valid_x,2);

P_upd = [];
x_upd = [];
q_upd = [];

x_pred = [x_predict(:,valid_x) x_predict(:,unvalid_x)];
P_pred = [P_predict(:,valid_x) P_predict(:,unvalid_x)];
q_pred = [q_predict(:,valid_x) q_predict(:,unvalid_x)];

% z_valid = z(:,valid_z);
% z_unvalid = z(:,unvalid_z);
plength = size(x_pred,2);

for j=1:plength
    qq = [];
    q_ped = q_pred(1,j);
    P_predict_4_4 = reshape(P_pred(:,j),4,4);
    [H, z_hat]= ekf_update_mat(parameter,x_pred(:,j)); % H is 2 by 4 matrix and z_hat is 2 by 1 matrix
    S= H*P_predict_4_4*H' + parameter.R; %Sj is 2 by 2 matrix; 

    if j <=s_x   %associated
         W = P_predict_4_4*H'*inv(S); % kalman gain
         x_update=x_pred(:,j)+W*(z_valid(:,j)-z_hat);
         P_update_4_4=(eye(4)-W*H)*P_predict_4_4;
         P_update = reshape(P_update_4_4,16,1);
         
         mvn = mvnpdf(z_valid(:,j),z_hat,S); 
         likeli = mvn * p_d;
         q_update = (1-p_d*(1-(likeli/p_fa)))*q_ped/(1-p_d*(1-(likeli/p_fa))*q_ped);
        
    elseif j > s_x         %non-associated
         W = P_predict_4_4*H'*inv(S); % kalman gain
         x_update=x_predict(:,j);
         P_update_4_4=(eye(4)-W*H)*P_predict_4_4;
         P_update = reshape(P_update_4_4,16,1);
        
         q_update = (1-p_d)*q_ped/(1-p_d*q_ped);
        
    end
    
    P_upd =[P_upd P_update];
    x_upd =[x_upd x_update];
    qq = [q_update; q_pred(2,j);q_pred(3,j)]; %q is 3 by 1 matrix 
    q_upd = [q_upd qq];
%     P_upd(:,j) = P_update;
%     x_upd(:,j) = x_update;
%     q_upd(:,j) = [q_update; q_pred(2,j)];
    
end


end
