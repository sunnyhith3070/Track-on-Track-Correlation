function plot_rmse_nn(parameter,rmse_1_position,rmse_1_velocity,N_k_1,rmse_2_position,rmse_2_velocity,N_k_2)


rmse_1_pos = sum(rmse_1_position,2);
rmse_1_vel = sum(rmse_1_velocity,2);
N_k1 = sum(N_k_1,2);

rmse_2_pos = sum(rmse_2_position,2);
rmse_2_vel = sum(rmse_2_velocity,2);
N_k2 = sum(N_k_2,2);

r_1_pos = zeros(parameter.K,1);
r_1_vel = zeros(parameter.K,1);
r_2_pos = zeros(parameter.K,1);
r_2_vel = zeros(parameter.K,1);


%%%%%position
for k1 = 1:parameter.K
    if N_k1 == 0
        r_1_pos(k1,:) = NaN;
    else            
        r_1_pos(k1,:) = sqrt(rmse_1_pos(k1,:)/N_k1(k1,:));
    end
end

for k2 = 1:parameter.K
    if N_k2 == 0
        r_2_pos(k2,:) = NaN;
    else            
        r_2_pos(k2,:) = sqrt(rmse_2_pos(k2,:)/N_k2(k2,:));
    end
end

%%%%%velocity
for k1 = 1:parameter.K
    if N_k1 == 0
        r_1_vel(k1,:) = NaN;
    else            
        r_1_vel(k1,:) = sqrt(rmse_1_vel(k1,:)/N_k1(k1,:));
    end
end

for k2 = 1:parameter.K
    if N_k2 == 0
        r_2_vel(k2,:) = NaN;
    else            
        r_2_vel(k2,:) = sqrt(rmse_2_vel(k2,:)/N_k2(k2,:));
    end
end


%%%%%%plot
figure;
plot(r_1_pos);
title('RMSE of target 1 position (Nearest Neighbor)');
xlabel('Time K');
ylabel('RMSE of target 1 position');
xlim=[1 parameter.K];
set(gca,'XLim',xlim);

figure;
plot(r_1_vel);
title('RMSE of target 1 velocity (Nearest Neighbor)');
xlabel('Time K');
ylabel('RMSE of target 1 velocity');
set(gca,'XLim',xlim);

figure;
plot(r_2_pos);
title('RMSE of target 2 position (Nearest Neighbor)');
xlabel('Time K');
ylabel('RMSE of target 2 position');
set(gca,'XLim',xlim);

figure;
plot(r_2_vel);
title('RMSE of target 2 velocity (Nearest Neighbor)');
xlabel('Time K');
ylabel('RMSE of target 2 velocity');
set(gca,'XLim',xlim);

end