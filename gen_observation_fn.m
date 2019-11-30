function Z= gen_observation_fn(parameter,X)

%r/theta observation equation

std_r = parameter.sensor_std_r; % measurement range standard deviation
std_a = parameter.sensor_std_a; % measurement azimuth standard deviation
sensor_state = parameter.sensor_state;

mean_noise=[0 0];
state_var = diag([std_r^2 std_a^2]);
noise1d = mvnrnd(mean_noise, state_var);
noise2d = mvnrnd(mean_noise, state_var,2);

if isempty(X)
    Z= [];
else 
    Y= X([1 3],:);
    range = sqrt((Y(1,:)-sensor_state(1,1)).^2+(Y(2,:)-sensor_state(3,1)).^2);
    azimuth = atan2((Y(2,:)-sensor_state(3,1)),(Y(1,:)-sensor_state(1,1)));       
    Z = [range;azimuth];
    ss = size(Z);
    if ss(2) == 1
        Z = Z + noise1d';
    elseif ss(2) == 2
        Z = Z + noise2d';
    else
        
    end
    
end


