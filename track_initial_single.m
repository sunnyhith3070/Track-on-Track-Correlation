function [P, x, q] = track_initial_single(parameter,meas)

std_r = parameter.sensor_std_r;
std_a = parameter.sensor_std_a;

v_max = parameter.v_max;

range = meas(1);
theta = meas(2);

b1 = exp(-(std_a^2)/2);
b2 = b1^4;

R_11 = ((b1^(-2)-2)*(range^2))* (cos(theta)^2)+ ((range^2) + std_r^2)*(1/2)*(1+ b2 *cos(2*theta)); 
R_33 = ((b1^(-2)-2)*(range^2))* (sin(theta)^2)+ ((range^2) + std_r^2)*(1/2)*(1- b2 *cos(2*theta)); 

R_13 =(((b1^(-2))*(range^2)/2) + ((range^2) + ((std_r)^2)*b2)/2 - (range^2))* (sin(2*theta));
R_31 = R_13;


x_initial_position = range*cos(theta);
y_initial_position = range*sin(theta);


P_initial_state_16_1 = [R_11; 0; R_31; 0; 0; (v_max/2)^2; 0; 0; R_13; 0; R_33; 0; 0; 0; 0; (v_max/2)^2];
%P_initial_state_16_1 = [3000;0;0;0;0;2000;0;0;0;0;3000;0;0;0;0;2000];
P_initial_state_4_4 = [R_11 0 R_13 0;
                       0 (v_max/2)^2 0 0;
                       R_31 0 R_33 0;
                       0 0 0 (v_max/2)^2;];

x_initial_state = [x_initial_position; 0; y_initial_position; 0];

q_initial = [parameter.quality; 0; 0]; % second row stands for tentative,third row stands for life

P = P_initial_state_16_1;
x = x_initial_state;
q = q_initial;


end