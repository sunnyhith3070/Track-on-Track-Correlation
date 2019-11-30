function [P_update,x_update,q_update] = pda_calcu_no_meas(parameter,S,W,H,P_predict,x_predict,q_predict)

p_d = parameter.P_D;
P_predict_4_4 = P_predict;

x_update = x_predict;

P_update_4_4=(eye(4)-W*H)*P_predict_4_4;


q_ped = q_predict(1,:);
q_upd = (1-p_d)*q_ped/(1-p_d*q_ped);

P_update = reshape(P_update_4_4,16,1);
q_update = [q_upd; q_predict(2,:);q_predict(3,:)];


end