function [P_update,x_update,q_update] = pda_calcu(parameter,z_m,z_hat,S,W,P_predict,x_predict,q_predict)

p_d = parameter.P_D;
P_g = parameter.confidence_level;
lemda = parameter.P_F;

%calculate the likelihood ratio
z_mlength = size(z_m,2);
llr = [];

for j = 1:z_mlength
     mvn_j = mvnpdf(z_m(:,j),z_hat,S); 
     llr(:,j) = mvn_j*p_d/lemda;
end

llr_total = sum(llr);


%calculate the assocaition probability for z_m being the correct the
%measurement

beta_0 = (1- p_d*P_g)/(1- p_d*P_g +llr_total);

beta_i = [];
beta_multi_v = [];
v_k_j = [];

for j = 1:z_mlength
    beta_i(:,j) = llr(:,j) /(1- p_d*P_g +llr_total);
    beta_multi_v_2_2 = beta_i(:,j)*((z_m(:,j)-z_hat)*(z_m(:,j)-z_hat)');
    beta_multi_v(:,j) = reshape(beta_multi_v_2_2,4,1);
    v_k_j(:,j) = beta_i(:,j)*(z_m(:,j)-z_hat);
end


beta_multi_v_total = sum(beta_multi_v,2);

beta_multi_v_total_2_2 = reshape(beta_multi_v_total,2,2);
%calculate the v_k
v_k = sum(v_k_j,2);

%calculate P_tilde and P_c

P_tilde = W*(beta_multi_v_total_2_2- v_k*v_k')*W';
P_c = P_predict - W*S*W';

P_update_4_4 = beta_0*P_predict + (1- beta_0)*P_c + P_tilde;
x_update = x_predict + W*v_k;

q_ped = q_predict(1,:);
q_upd = (1-p_d*(1-llr_total))*q_ped/(1-p_d*(1-llr_total)*q_ped);

P_update = reshape(P_update_4_4,16,1);
q_update = [q_upd; q_predict(2,:);q_predict(3,:)];
end


