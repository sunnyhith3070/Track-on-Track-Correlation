function [H, z_hat]= ekf_update_mat(parameter,x_predict)

 x_hat= x_predict([1 3],:);
 sensor_state = parameter.sensor_state;
 
 range = sqrt((x_hat(2)-sensor_state(3))^2+(x_hat(1)-sensor_state(1))^2);
 azimuth = atan2((x_hat(2)-sensor_state(3)),(x_hat(1)-sensor_state(1)));      
      
 r_hat = range;
 theta_hat = azimuth;  
 
 z_hat = [r_hat; theta_hat];
 H = [cos(theta_hat) 0 sin(theta_hat) 0;
      -sin(theta_hat)/r_hat 0 cos(theta_hat)/r_hat 0];
 
