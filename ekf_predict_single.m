function [P_predict,x_predict,q_predict] = ekf_predict_single(parameter,P_update,x_update,q_update)    

P_update_4_4 = reshape(P_update,4,4);

F = parameter.F;
Q = parameter.Q;

x_predict = F * x_update;        %state prediction
P_predict_4_4 = F *P_update_4_4*F' + Q;  %covariance prediction
P_predict = reshape(P_predict_4_4,16,1);

q_predict = [parameter.P_S * q_update(1,1); q_update(2,1);q_update(3,1)]; %q is 3 by 1 matrix

end