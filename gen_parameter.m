function parameter= gen_parameter

parameter.MC_num = 100;
% basic parameters
parameter.x_dim= 4;   %dimension of state vector
parameter.z_dim= 2;   %dimension of observation vector

% state transformation given by gen_newstate_fn,
parameter.T = 1;      %sampling period
parameter.K = 50;

%parameter of gen_truth
target1_x_position = 5000;
target1_x_velocity = -200;
target1_y_position = 6000;
target1_y_velocity = -300;

target2_x_position = -5000;
target2_x_velocity = 200;
target2_y_position = -1000;
target2_y_velocity = -300;

parameter.target1_initial_state = [target1_x_position; 
                                   target1_x_velocity;
                                   target1_y_position;
                                   target1_y_velocity];
parameter.target1_start_time = 5; %target1 starts time
parameter.target1_end_time = 30;  %target1 ends time
                               
parameter.target2_initial_state = [target2_x_position; 
                                   target2_x_velocity;
                                   target2_y_position;
                                   target2_y_velocity];
parameter.target2_start_time = 15; %target2 starts time
parameter.target2_end_time = 40;  %target2 ends time

%initialize v_max for initializing the covariance
parameter.v_max = 200;  

%initialize the quality
parameter.quality = 0.2;

T = parameter.T;

parameter.G=[(T^2)/2 0 0 0;
                 0 T 0 0;
                 0 0 (T^2)/2 0;
                 0 0 0 T];
 
parameter.F = [ 1 T 0 0;
                0 1 0 0;
                0 0 1 T;
                0 0 0 1]; % transition matrix F

%parameter of the sensor
parameter.sensor_position = [0 0];
parameter.sensor_velocity= [0 0];
parameter.sensor_state = [parameter.sensor_position(1);
                          parameter.sensor_velocity(1);
                          parameter.sensor_position(2);
                          parameter.sensor_velocity(2)]; % sensor state[0;0;0;0]                        
            
parameter.sensor_std_r = 10; % measurement range standard deviation
parameter.sensor_std_a = 0.01; % measurement azimuth standard deviation
parameter.sensor_std_R = diag([parameter.sensor_std_r;
                               parameter.sensor_std_a]); % measurement standard deviation
parameter.sensor_var_R = parameter.sensor_std_R.^2; % variance               
               
               
% process standard deviation
std_x =0.1;
std_y =0.1;
std_xy= [std_x^2 std_x^2 0 0;
        std_x^2 std_x^2 0 0;
        0 0 std_y^2 std_y^2;
        0 0 std_y^2 std_y^2]; 
    
% Q is assumed process noise covariance
parameter.Q= [(T^4)/4 (T^3)/2 0 0;
             (T^3)/2 (T^2)   0 0;
              0     0     (T^4)/4 (T^3)/2;
              0     0     (T^3)/2 (T^2)].*std_xy;

std_r = parameter.sensor_std_r;
std_a = parameter.sensor_std_a;
parameter.R = diag([std_r^2, std_a^2]);

% survival/death parameters
parameter.P_S= 0.99;
parameter.delete_tentative= 0.1;       %probability of deleting tentative
parameter.confirm = 0.9;                 %probability of promoting tentative to confirm
parameter.delete_confirm = 0.01;          %probability of deleting comfirm
 
% detection parameters
parameter.P_D= 0.9;   %probability of detection in measurements
parameter.Q_D= 1-parameter.P_D; %probability of missed detection in measurements

% clutter parameters
parameter.max_range = 10000;
parameter.P_F = 1e-4;     % false alarm density
parameter.range_c= [ 0 parameter.max_range; 0 2*pi ];          %uniform clutter on r/theta
parameter.lambda_c=parameter.P_F*prod(parameter.range_c(:,2)-parameter.range_c(:,1)); %poisson average rate of uniform clutter (per scan)

parameter.degree_of_freedom = 2; % degree of freedom
parameter.confidence_level = 0.99; % condience level
parameter.gate = chi2inv(parameter.confidence_level,parameter.degree_of_freedom); % gate



